(function() {
    let radarData = null;
    let currentViewBand = '5G';
    let scanning = false;
    let activeHighlightId = null;

    const CHANNELS_24G = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13];
    const CHANNELS_5G = [36, 40, 44, 48, 52, 56, 60, 64, 149, 153, 157, 161, 165];

    // ---- 真实频谱轴：信道号并不连续，5G 从 64（5320MHz）直接跳到 149（5745MHz），
    //      中间 100–144（DFS，本机不支持）必须留出"省略段"，否则图谱会假装频谱是连续的。
    const AXIS_SEGMENTS_24G = [
        { f0: 2412, f1: 2472, ratio: 1, chs: CHANNELS_24G }
    ];
    const AXIS_SEGMENTS_5G = [
        { f0: 5180, f1: 5320, ratio: 0.44, chs: [36, 40, 44, 48, 52, 56, 60, 64] },
        { gap: true, f0: 5320, f1: 5745, ratio: 0.12, note: '100–144' },
        { f0: 5745, f1: 5825, ratio: 0.44, chs: [149, 153, 157, 161, 165] }
    ];

    function channelToFreqMHz(ch) {
        if (ch <= 14) return ch === 14 ? 2484 : 2412 + (ch - 1) * 5;
        return 5000 + ch * 5;
    }

    // 与 renderSpectrumChart 的绘图常量保持一致（W=640 / padL=42 / padR=24 / bandMargin=40）
    function radarAxis(band) {
        const padL = 42, padR = 24, bandMargin = 40, W = 640;
        const inner = (W - padL - padR) - bandMargin * 2;
        const defs = band === '2.4G' ? AXIS_SEGMENTS_24G : AXIS_SEGMENTS_5G;
        let cursor = padL + bandMargin;
        const segs = defs.map(s => {
            const w = inner * s.ratio;
            const seg = Object.assign({}, s, { x0: cursor, x1: cursor + w, w: w });
            cursor += w;
            return seg;
        });
        let pxPerMHz = 1;
        for (const s of segs) {
            if (!s.gap && s.f1 > s.f0) { pxPerMHz = s.w / (s.f1 - s.f0); break; }
        }
        return { inner: inner, segs: segs, pxPerMHz: pxPerMHz, band: band };
    }

    // 按频率定位（段内线性），落在段外则夹到边界
    function axisXForChannel(axis, ch) {
        const freq = channelToFreqMHz(ch);
        for (const s of axis.segs) {
            if (freq >= s.f0 && freq <= s.f1) {
                return s.x0 + ((freq - s.f0) / (s.f1 - s.f0)) * s.w;
            }
        }
        const first = axis.segs[0], last = axis.segs[axis.segs.length - 1];
        if (freq < first.f0) return first.x0;
        if (freq > last.f1) return last.x1;
        return first.x0;
    }

    // 高斯 σ 由真实带宽换算：钟形的可见范围是 ±2.4σ，所以取 σ ≈ 带宽/4.71 时，
    // "曲线可见宽度 ≈ 该 AP 的真实带宽"（20MHz 的峰只占一个信道宽，160MHz 的几乎铺满整段）。
    // 早前按 FWHM(2.355) 换算会让可见宽度变成带宽的 2 倍 —— 160MHz 的曲线会宽到越出整个 5G 段。
    function axisSigmaForBandwidth(axis, bandwidthMHz) {
        const bw = bandwidthMHz > 0 ? bandwidthMHz : 20;
        return Math.max((bw / 4.71) * axis.pxPerMHz, 2.5);
    }

    const PALETTE = [
        '#6366f1', '#ec4899', '#8b5cf6', '#14b8a6', '#f59e0b',
        '#10b981', '#06b6d4', '#f97316', '#84cc16', '#a855f7',
        '#3b82f6', '#e11d48', '#059669', '#d97706', '#4f46e5'
    ];

    function hashColor(str) {
        let hash = 0;
        for (let i = 0; i < str.length; i++) {
            hash = str.charCodeAt(i) + ((hash << 5) - hash);
        }
        return PALETTE[Math.abs(hash) % PALETTE.length];
    }

    function initRadarUI() {
        const btnScan = document.getElementById('btn-scan-radar');
        const btn24G = document.getElementById('radar-tab-24g');
        const btn5G = document.getElementById('radar-tab-5g');
        const btnAutoSwitch = document.getElementById('btn-auto-switch-channel');
        const applyChannelBtn = document.getElementById('apply-channel');

        if (btnScan) {
            btnScan.addEventListener('click', () => fetchRadarData(true));
        }

        if (btn24G && btn5G) {
            btn24G.addEventListener('click', () => {
                currentViewBand = '2.4G';
                btn24G.classList.add('active');
                btn5G.classList.remove('active');
                renderRadarView();
                updateDiagnostics();
            });
            btn5G.addEventListener('click', () => {
                currentViewBand = '5G';
                btn5G.classList.add('active');
                btn24G.classList.remove('active');
                renderRadarView();
                updateDiagnostics();
            });
        }

        if (btnAutoSwitch) {
            btnAutoSwitch.addEventListener('click', applyRecommendedChannel);
        }

        // Intercept standard apply-channel button to ensure robust execution
        if (applyChannelBtn) {
            const newBtn = applyChannelBtn.cloneNode(true);
            applyChannelBtn.parentNode.replaceChild(newBtn, applyChannelBtn);
            newBtn.addEventListener('click', () => {
                const sel = document.getElementById('channel-select');
                const ch = parseInt(sel.value, 10);
                if (!ch) {
                    showRadarToast('请选择信道', 'error');
                    return;
                }
                if (!window.confirm(`切换 Wi-Fi 信道至 ${ch} 会断开当前连接。继续？`)) {
                    return;
                }
                const mode = ch <= 14 ? '2.4G' : '5G';
                switchChannel(ch, mode);
            });
        }

        // Initial load
        fetchRadarData(false);
    }

    async function fetchRadarData(triggerScan) {
        if (scanning) return;
        scanning = true;

        const scanBtn = document.getElementById('btn-scan-radar');
        const scanStatus = document.getElementById('radar-scan-status');
        if (scanBtn) {
            scanBtn.disabled = true;
            scanBtn.textContent = '探测中…';
        }
        if (scanStatus) {
            scanStatus.textContent = '正在执行全频段空中扫描，约需 10 秒…';
            scanStatus.style.display = 'block';
        }

        try {
            const resp = await fetch('/air-api/wifi/radar' + (triggerScan ? '?force=1' : ''), {
                cache: 'no-store'
            });
            if (!resp.ok) throw new Error('探测接口响应异常 (' + resp.status + ')');
            radarData = await resp.json();
            window.radarData = radarData;
            window.fetchRadarData = fetchRadarData;

            // Auto-select tab matching current device mode on first load
            if (!triggerScan && radarData.current_mode) {
                currentViewBand = radarData.current_mode;
                const btn24G = document.getElementById('radar-tab-24g');
                const btn5G = document.getElementById('radar-tab-5g');
                if (currentViewBand === '2.4G') {
                    if (btn24G) btn24G.classList.add('active');
                    if (btn5G) btn5G.classList.remove('active');
                } else {
                    if (btn5G) btn5G.classList.add('active');
                    if (btn24G) btn24G.classList.remove('active');
                }
            }

            renderRadarView();
            updateDiagnostics();

            if (scanStatus) {
                const count = (radarData.networks || []).length;
                scanStatus.textContent = `探测完成：发现 ${count} 个周围热点，已生成频域图与信号明细`;
                setTimeout(() => {
                    if (scanStatus) scanStatus.style.display = 'none';
                }, 3500);
            }
        } catch (e) {
            console.error('Radar scan error:', e);
            if (scanStatus) {
                scanStatus.textContent = '探测失败: ' + e.message;
            }
        } finally {
            scanning = false;
            if (scanBtn) {
                scanBtn.disabled = false;
                scanBtn.textContent = '探测周围信道';
            }
        }
    }

    function getBandNetworks() {
        if (!radarData) return [];
        const rawList = (radarData.networks || []).filter(n => n.band === currentViewBand);
        const selfCh = radarData.current_channel;
        const selfMode = radarData.current_mode;
        const isSelfBand = (selfMode === currentViewBand);

        const list = [];
        let hasSelf = false;

        rawList.forEach((n, idx) => {
            const isSelf = isSelfBand && (n.channel === selfCh) && (n.ssid === radarData.current_ssid);
            if (isSelf) hasSelf = true;
            list.push({
                ...n,
                id: 'ap_' + (n.bssid ? n.bssid.replace(/[^a-zA-Z0-9]/g, '') : idx),
                isSelf: isSelf
            });
        });

        if (isSelfBand && selfCh > 0 && !hasSelf) {
            list.unshift({
                id: 'ap_self_active',
                ssid: radarData.current_ssid || 'SZ50-AIR',
                bssid: '本机热点',
                channel: selfCh,
                freq: radarData.current_freq || 5180,
                band: selfMode,
                rssi: -35,
                flags: 'WPA2-PSK',
                isSelf: true,
                // 本机 AP 收不到自己的 beacon，设备侧读不出带宽；这里是按手机端实测
                // （Cellular-Z 扫本机为 80MHz）与本机 tether 的默认 VHT80 配置标定的。
                bandwidth: 80
            });
        }

        // Sort: self AP on top, then by signal strength descending
        list.sort((a, b) => {
            if (a.isSelf) return -1;
            if (b.isSelf) return 1;
            return b.rssi - a.rssi;
        });

        return list;
    }

    function renderRadarView() {
        const nets = getBandNetworks();
        renderSpectrumChart(nets);
        renderAPList(nets);
    }

    function renderSpectrumChart(nets) {
        const svg = document.getElementById('wifi-radar-svg');
        if (!svg) return;
        svg.innerHTML = '';

        const W = 640;
        const H = 250;
        const padL = 42;
        const padR = 24;
        const padT = 28;
        const padB = 34;

        const plotW = W - padL - padR;
        const plotH = H - padT - padB;
        const baseY = padT + plotH;

        const channels = currentViewBand === '2.4G' ? CHANNELS_24G : CHANNELS_5G;
        const minRSSI = -95;
        const maxRSSI = -30;

        // Reserve edge margin for complete double-sideband bell curves
        const bandMargin = 40;
        const channelSpanW = plotW - bandMargin * 2;

        const axis = radarAxis(currentViewBand);
        function xForChannel(ch) {
            return axisXForChannel(axis, ch);
        }

        function yForRSSI(rssi) {
            const clamped = Math.max(minRSSI, Math.min(maxRSSI, rssi));
            const ratio = (clamped - minRSSI) / (maxRSSI - minRSSI);
            return baseY - ratio * plotH;
        }

        // SVG Defs
        const defs = document.createElementNS('http://www.w3.org/2000/svg', 'defs');
        defs.innerHTML = `
            <linearGradient id="grad-self" x1="0" y1="0" x2="0" y2="1">
                <stop offset="0%" stop-color="#2563eb" stop-opacity="0.45"/>
                <stop offset="100%" stop-color="#2563eb" stop-opacity="0.05"/>
            </linearGradient>
            <filter id="glow-self" x="-20%" y="-20%" width="140%" height="140%">
                <feGaussianBlur stdDeviation="3" result="blur" />
                <feComposite in="SourceGraphic" in2="blur" operator="over" />
            </filter>
        `;
        svg.appendChild(defs);

        // 1. Horizontal grid lines (dBm)
        const dbmLevels = [-40, -60, -80];
        dbmLevels.forEach(lvl => {
            const y = yForRSSI(lvl);
            const line = document.createElementNS('http://www.w3.org/2000/svg', 'line');
            line.setAttribute('x1', padL);
            line.setAttribute('y1', y);
            line.setAttribute('x2', W - padR);
            line.setAttribute('y2', y);
            line.setAttribute('stroke', '#e2e8f0');
            line.setAttribute('stroke-dasharray', '3,3');
            line.setAttribute('stroke-width', '0.6');
            svg.appendChild(line);

            const label = document.createElementNS('http://www.w3.org/2000/svg', 'text');
            label.setAttribute('x', padL - 6);
            label.setAttribute('y', y + 3);
            label.setAttribute('text-anchor', 'end');
            label.setAttribute('font-size', '10');
            label.setAttribute('fill', '#94a3b8');
            label.textContent = lvl;
            svg.appendChild(label);
        });

        // Base line
        const baseLine = document.createElementNS('http://www.w3.org/2000/svg', 'line');
        baseLine.setAttribute('x1', padL);
        baseLine.setAttribute('y1', baseY);
        baseLine.setAttribute('x2', W - padR);
        baseLine.setAttribute('y2', baseY);
        baseLine.setAttribute('stroke', '#cbd5e1');
        baseLine.setAttribute('stroke-width', '0.8');
        svg.appendChild(baseLine);

        // Unit label
        const unitTxt = document.createElementNS('http://www.w3.org/2000/svg', 'text');
        unitTxt.setAttribute('x', padL - 6);
        unitTxt.setAttribute('y', padT - 10);
        unitTxt.setAttribute('text-anchor', 'end');
        unitTxt.setAttribute('font-size', '10');
        unitTxt.setAttribute('font-weight', '600');
        unitTxt.setAttribute('fill', '#64748b');
        unitTxt.textContent = 'dBm';
        svg.appendChild(unitTxt);

        // 2. Channel vertical grid & labels
        const labelMap = {};
        channels.forEach((ch) => {
            const x = xForChannel(ch);

            // Channel tick
            const tick = document.createElementNS('http://www.w3.org/2000/svg', 'line');
            tick.setAttribute('x1', x);
            tick.setAttribute('y1', baseY);
            tick.setAttribute('x2', x);
            tick.setAttribute('y2', baseY + 5);
            tick.setAttribute('stroke', '#94a3b8');
            tick.setAttribute('stroke-width', '1');
            svg.appendChild(tick);

            // Channel label
            const label = document.createElementNS('http://www.w3.org/2000/svg', 'text');
            label.setAttribute('x', x);
            label.setAttribute('y', baseY + 18);
            label.setAttribute('text-anchor', 'middle');
            label.setAttribute('font-size', '11');
            const isPrimary = (currentViewBand === '2.4G' && (ch === 1 || ch === 6 || ch === 11));
            label.setAttribute('font-weight', isPrimary ? '700' : '500');
            label.setAttribute('fill', isPrimary ? '#2563eb' : '#64748b');
            label.textContent = ch;
            svg.appendChild(label);
            labelMap[ch] = label;
        });

        // 2b. 被省略的频段（5G 的 100–144）：虚线边界 + 省略号 + 频段标注
        axis.segs.filter(s => s.gap).forEach(s => {
            [s.x0, s.x1].forEach(x => {
                const edge = document.createElementNS('http://www.w3.org/2000/svg', 'line');
                edge.setAttribute('x1', x);
                edge.setAttribute('y1', padT);
                edge.setAttribute('x2', x);
                edge.setAttribute('y2', baseY);
                edge.setAttribute('stroke', '#cbd5e1');
                edge.setAttribute('stroke-dasharray', '4,4');
                edge.setAttribute('stroke-width', '0.8');
                svg.appendChild(edge);
            });

            const ell = document.createElementNS('http://www.w3.org/2000/svg', 'text');
            ell.setAttribute('x', s.x0 + s.w / 2);
            ell.setAttribute('y', baseY - plotH * 0.52);
            ell.setAttribute('text-anchor', 'middle');
            ell.setAttribute('font-size', '20');
            ell.setAttribute('font-weight', '700');
            ell.setAttribute('fill', '#cbd5e1');
            ell.textContent = '⋯';
            svg.appendChild(ell);

            const note = document.createElementNS('http://www.w3.org/2000/svg', 'text');
            note.setAttribute('x', s.x0 + s.w / 2);
            note.setAttribute('y', baseY + 18);
            note.setAttribute('text-anchor', 'middle');
            note.setAttribute('font-size', '8');
            note.setAttribute('fill', '#94a3b8');
            note.textContent = s.note;
            svg.appendChild(note);

            const tip = document.createElementNS('http://www.w3.org/2000/svg', 'title');
            tip.textContent = '此处省略 ' + s.note + ' 频段（DFS，本机射频不支持）';
            ell.appendChild(tip);
        });

        // Channel axis title
        const chTitle = document.createElementNS('http://www.w3.org/2000/svg', 'text');
        chTitle.setAttribute('x', W - padR);
        chTitle.setAttribute('y', baseY + 20);
        chTitle.setAttribute('text-anchor', 'end');
        chTitle.setAttribute('font-size', '10');
        chTitle.setAttribute('fill', '#94a3b8');
        chTitle.textContent = '信道';
        svg.appendChild(chTitle);

        if (!nets.length) {
            const emptyTxt = document.createElementNS('http://www.w3.org/2000/svg', 'text');
            emptyTxt.setAttribute('x', W / 2);
            emptyTxt.setAttribute('y', H / 2);
            emptyTxt.setAttribute('text-anchor', 'middle');
            emptyTxt.setAttribute('font-size', '13');
            emptyTxt.setAttribute('fill', '#94a3b8');
            emptyTxt.textContent = '点击上方“探测周围信道”绘制频域图谱';
            svg.appendChild(emptyTxt);
            return;
        }

        // 3. Draw Gaussian Curves for APs
        // 每个 AP 用自己带宽决定的 σ（原实现全图共用同一个 σ → 所有热点看起来一样宽，不符合实际频谱）

        // Container group for all curves
        const curvesContainer = document.createElementNS('http://www.w3.org/2000/svg', 'g');
        curvesContainer.setAttribute('id', 'radar-curves-layer');
        svg.appendChild(curvesContainer);

        // Sort: draw weaker APs first, self/stronger APs on top
        const renderOrder = [...nets].sort((a, b) => a.rssi - b.rssi);

        renderOrder.forEach((net) => {
            const xc = xForChannel(net.channel);
            const yPeak = yForRSSI(net.rssi);
            const color = net.isSelf ? '#2563eb' : hashColor(net.bssid || net.ssid);
            const sigmaX = axisSigmaForBandwidth(axis, net.bandwidth);

            const group = document.createElementNS('http://www.w3.org/2000/svg', 'g');
            group.setAttribute('class', 'radar-curve-group');
            group.setAttribute('id', 'curve_' + net.id);
            group.setAttribute('data-id', net.id);

            // Generate Gaussian bell path: complete symmetric double sidebands
            const steps = 36;
            const spread = 2.4 * sigmaX;
            const startX = xc - spread;
            const endX = xc + spread;

            let d = `M ${(startX - 1).toFixed(1)} ${baseY.toFixed(1)}`;
            for (let i = 0; i <= steps; i++) {
                const x = startX + (i / steps) * (endX - startX);
                const dx = (x - xc) / sigmaX;
                const factor = Math.exp(-0.5 * dx * dx);
                const y = baseY - (baseY - yPeak) * factor;
                d += ` L ${x.toFixed(1)} ${y.toFixed(1)}`;
            }
            d += ` L ${(endX + 1).toFixed(1)} ${baseY.toFixed(1)} Z`;

            // Area path
            const path = document.createElementNS('http://www.w3.org/2000/svg', 'path');
            path.setAttribute('d', d);
            path.setAttribute('class', 'radar-curve-area');
            path.setAttribute('fill', net.isSelf ? 'url(#grad-self)' : color);
            path.setAttribute('fill-opacity', net.isSelf ? '0.85' : '0.10');
            path.setAttribute('stroke', color);
            path.setAttribute('class', 'radar-curve-path');
            path.setAttribute('stroke-width', net.isSelf ? '1.1' : '0.65');
            if (net.isSelf) {
                path.style.filter = 'drop-shadow(0 1px 3px rgba(37,99,235,0.3))';
            }
            group.appendChild(path);

            // Peak Dot
            const dot = document.createElementNS('http://www.w3.org/2000/svg', 'circle');
            dot.setAttribute('cx', xc);
            dot.setAttribute('cy', yPeak);
            dot.setAttribute('r', net.isSelf ? '2.5' : '1.8');
            dot.setAttribute('fill', color);
            dot.setAttribute('stroke', '#ffffff');
            dot.setAttribute('stroke-width', '0.8');
            dot.setAttribute('class', 'radar-curve-dot');
            group.appendChild(dot);

            // If SELF AP, draw distinct luminous badge
            if (net.isSelf) {
                const badge = document.createElementNS('http://www.w3.org/2000/svg', 'g');
                badge.setAttribute('class', 'radar-self-badge-pin');
                
                const bText = document.createElementNS('http://www.w3.org/2000/svg', 'text');
                bText.setAttribute('x', xc);
                bText.setAttribute('y', Math.max(16, yPeak - 9));
                bText.setAttribute('text-anchor', 'middle');
                bText.setAttribute('font-size', '11');
                bText.setAttribute('font-weight', '700');
                bText.setAttribute('fill', '#1d4ed8');
                bText.textContent = `★ ${net.ssid} (本机)`;
                badge.appendChild(bText);
                group.appendChild(badge);
            }

            // Curve interaction events
            group.addEventListener('mouseenter', () => highlightAP(net.id));
            group.addEventListener('mouseleave', () => unhighlightAP());

            curvesContainer.appendChild(group);
        });

        // 3b. 同信道多热点角标：同 SSID 不同 MAC 的多个 AP（校园网布点常见）落在同一信道时，
        //     频谱上完全重合，只画曲线会让人以为"少显示了" —— 在峰值旁标出该信道的热点数量。
        const chCount = {};
        renderOrder.forEach((net) => {
            if (typeof net.channel !== 'number') return;
            chCount[net.channel] = (chCount[net.channel] || 0) + 1;
        });
        Object.keys(chCount).forEach((chKey) => {
            const cnt = chCount[chKey];
            if (cnt < 2) return;
            const ch = parseInt(chKey, 10);
            const group = renderOrder.filter((n) => n.channel === ch);
            const top = group.reduce((a, b) => (a.rssi >= b.rssi ? a : b));
            const x = xForChannel(ch);
            const y = Math.max(12, yForRSSI(top.rssi) - 11);
            const badge = document.createElementNS('http://www.w3.org/2000/svg', 'text');
            badge.setAttribute('x', x + 5);
            badge.setAttribute('y', y);
            badge.setAttribute('font-size', '9');
            badge.setAttribute('font-weight', '700');
            badge.setAttribute('fill', '#64748b');
            badge.textContent = '×' + cnt;
            const badgeTip = document.createElementNS('http://www.w3.org/2000/svg', 'title');
            badgeTip.textContent = 'CH ' + ch + ' 上有 ' + cnt + ' 个热点在重叠（频谱上重合，下方列表里可分别查看）';
            badge.appendChild(badgeTip);
            svg.appendChild(badge);
        });

        // 4. Interactive Channel Column Scanner
        // Vertical guide line
        const cursorLine = document.createElementNS('http://www.w3.org/2000/svg', 'line');
        cursorLine.setAttribute('id', 'radar-cursor-line');
        cursorLine.setAttribute('y1', padT);
        cursorLine.setAttribute('y2', baseY);
        cursorLine.setAttribute('stroke', '#3b82f6');
        cursorLine.setAttribute('stroke-width', '0.8');
        cursorLine.setAttribute('stroke-dasharray', '3,3');
        cursorLine.style.display = 'none';
        svg.appendChild(cursorLine);

        // Translucent highlight band for hovered channel
        const chBand = document.createElementNS('http://www.w3.org/2000/svg', 'rect');
        chBand.setAttribute('id', 'radar-ch-band');
        chBand.setAttribute('y', padT);
        chBand.setAttribute('height', plotH);
        chBand.setAttribute('fill', 'rgba(59, 130, 246, 0.08)');
        chBand.setAttribute('rx', '4');
        chBand.style.display = 'none';
        chBand.style.pointerEvents = 'none';
        svg.insertBefore(chBand, curvesContainer);

        // Dynamic Callout Group (shown when hovering a specific curve)
        const calloutGroup = document.createElementNS('http://www.w3.org/2000/svg', 'g');
        calloutGroup.setAttribute('id', 'radar-hover-callout');
        calloutGroup.style.display = 'none';
        calloutGroup.style.pointerEvents = 'none';
        svg.appendChild(calloutGroup);

        // Invisible overlay to track channel hover cleanly across entire chart
        const overlay = document.createElementNS('http://www.w3.org/2000/svg', 'rect');
        overlay.setAttribute('x', padL);
        overlay.setAttribute('y', padT);
        overlay.setAttribute('width', plotW);
        overlay.setAttribute('height', plotH);
        overlay.setAttribute('fill', 'transparent');
        overlay.style.cursor = 'crosshair';

        overlay.addEventListener('mousemove', (e) => {
            const rect = svg.getBoundingClientRect();
            const mouseX = ((e.clientX - rect.left) / rect.width) * W;

            // Find closest channel
            let closestCh = channels[0];
            let minDist = 99999;
            channels.forEach(ch => {
                const cx = xForChannel(ch);
                const dist = Math.abs(mouseX - cx);
                if (dist < minDist) {
                    minDist = dist;
                    closestCh = ch;
                }
            });

            const cx = xForChannel(closestCh);
            const bandW = (channelSpanW / (channels.length - 1 || 1)) * 0.8;

            cursorLine.setAttribute('x1', cx);
            cursorLine.setAttribute('x2', cx);
            cursorLine.style.display = 'block';

            chBand.setAttribute('x', cx - bandW / 2);
            chBand.setAttribute('width', bandW);
            chBand.style.display = 'block';

            // Filter APs on this channel
            const chAPs = nets.filter(n => n.channel === closestCh);
            showChannelTooltip(e, closestCh, chAPs);
        });

        overlay.addEventListener('mouseleave', () => {
            cursorLine.style.display = 'none';
            chBand.style.display = 'none';
            hideTooltip();
        });

        svg.appendChild(overlay);
    }

    function showChannelTooltip(e, channel, aps) {
        const tip = document.getElementById('radar-tooltip');
        if (!tip) return;

        let content = `
            <div class="radar-tip-header">
                <span class="radar-tip-ch">信道 ${channel}</span>
                <span class="radar-tip-count">${aps.length ? `共 ${aps.length} 个热点` : '无热点占用'}</span>
            </div>
        `;

        if (!aps.length) {
            content += `<div style="font-size:11px;color:#10b981;padding:4px 0;">✔ 该信道当前完全空闲</div>`;
        } else {
            content += `<div class="radar-tip-list">`;
            aps.forEach(ap => {
                const isSelf = ap.isSelf;
                const dotColor = isSelf ? '#2563eb' : hashColor(ap.bssid || ap.ssid);
                content += `
                    <div class="radar-tip-item ${isSelf ? 'self' : ''}">
                        <div style="display:flex;align-items:center;gap:5px;min-width:0;">
                            <span style="display:inline-block;width:6px;height:6px;border-radius:50%;background:${dotColor};flex-shrink:0;"></span>
                            <span class="radar-tip-name">${isSelf ? '★ ' : ''}${escapeHtml(ap.ssid || '隐藏网络')}</span>
                        </div>
                        <span class="radar-tip-rssi">${ap.rssi} dBm</span>
                    </div>
                `;
            });
            content += `</div>`;
        }

        tip.innerHTML = content;
        tip.style.display = 'block';

        const svgBox = document.querySelector('.radar-chart-container').getBoundingClientRect();
        let left = e.clientX - svgBox.left + 12;
        let top = e.clientY - svgBox.top - 15;

        // Boundary checks
        if (left + 220 > svgBox.width) {
            left = e.clientX - svgBox.left - 230;
        }
        if (top < 10) top = 10;

        tip.style.left = left + 'px';
        tip.style.top = top + 'px';
    }

    function hideTooltip() {
        const tip = document.getElementById('radar-tooltip');
        if (tip) tip.style.display = 'none';
    }

    // 5. Render Detected AP List Table / Cards
    function renderAPList(nets) {
        const listEl = document.getElementById('radar-ap-list');
        const countEl = document.getElementById('radar-ap-count');
        if (!listEl) return;

        if (countEl) {
            countEl.textContent = `${nets.length} 个热点`;
        }

        if (!nets.length) {
            listEl.innerHTML = `<div style="text-align:center;padding:16px;color:#94a3b8;font-size:12px;">当前频段未探测到周围热点</div>`;
            return;
        }

        let html = '';
        nets.forEach(net => {
            const color = net.isSelf ? '#2563eb' : hashColor(net.bssid || net.ssid);
            // RSSI percentage (clamped between -95 and -30)
            const pct = Math.max(8, Math.min(100, Math.round(((net.rssi - (-95)) / 65) * 100)));
            const barColor = net.rssi >= -55 ? '#10b981' : net.rssi >= -75 ? '#f59e0b' : '#94a3b8';
            let crypto = 'OPEN';
            if (net.flags) {
                const f = net.flags.toUpperCase();
                if (f.includes('WPA3') && f.includes('WPA2')) {
                    crypto = 'WPA2/WPA3-Personal';
                } else if (f.includes('WPA3')) {
                    crypto = 'WPA3-SAE';
                } else if (f.includes('WPA2') && f.includes('WPA-')) {
                    crypto = 'WPA/WPA2-PSK';
                } else if (f.includes('WPA2')) {
                    crypto = f.includes('CCMP') ? 'WPA2-PSK (CCMP)' : 'WPA2-PSK';
                } else if (f.includes('WPA')) {
                    crypto = 'WPA-PSK';
                } else if (f.includes('WEP')) {
                    crypto = 'WEP';
                } else if (!f.includes('WPA')) {
                    crypto = 'OPEN';
                } else {
                    crypto = net.flags.replace(/[\[\]]/g, ' ').trim();
                }
            }

            html += `
                <div class="radar-ap-item ${net.isSelf ? 'self' : ''}" id="item_${net.id}" data-id="${net.id}">
                    <div class="radar-ap-col-info">
                        <span class="radar-ap-dot" style="background:${color}"></span>
                        <span class="radar-ap-name" title="${escapeHtml(net.ssid || '隐藏网络')}">${escapeHtml(net.ssid || '隐藏网络')}</span>
                        ${net.isSelf ? '<span class="radar-ap-self-badge">本机热点</span>' : ''}
                    </div>
                    <div class="radar-ap-col-params">
                        <span class="radar-ap-col-ch">CH ${net.channel}<span class="radar-ap-bw-tag" title="${net.bandwidth ? '带宽 ' + net.bandwidth + ' MHz（解析自驱动上报的 IE）' : '本机 AP 收不到自己的 beacon，带宽无法从设备侧读取，可用手机扫描（如 Cellular-Z）核对'}">${net.bandwidth ? net.bandwidth + 'M' : '—'}</span></span>
                        <div class="radar-ap-rssi-box">
                            <div class="radar-ap-mini-bar">
                                <div class="radar-ap-mini-fill" style="width:${pct}%;background:${barColor}"></div>
                            </div>
                            <span class="radar-ap-rssi-val">${net.rssi} dBm</span>
                        </div>
                        <span class="radar-ap-crypto-tag" title="${escapeHtml(crypto)}">${escapeHtml(crypto)}</span>
                    </div>
                </div>
            `;
        });

        listEl.innerHTML = html;

        // Attach list row hover events
        nets.forEach(net => {
            const row = document.getElementById('item_' + net.id);
            if (row) {
                row.addEventListener('mouseenter', () => highlightAP(net.id));
                row.addEventListener('mouseleave', () => unhighlightAP());
            }
        });
    }

    // Bidirectional Highlighting
    function highlightAP(apId) {
        if (!radarData) return;
        activeHighlightId = apId;

        const nets = getBandNetworks();
        const target = nets.find(n => n.id === apId);
        if (!target) return;

        // 1. Highlight curve in SVG
        const allCurves = document.querySelectorAll('.radar-curve-group');
        allCurves.forEach(cg => {
            if (cg.getAttribute('data-id') === apId) {
                cg.classList.add('highlighted');
                cg.classList.remove('dimmed');
                // Bring to front
                cg.parentNode.appendChild(cg);
            } else {
                cg.classList.add('dimmed');
                cg.classList.remove('highlighted');
            }
        });

        // 2. Render prominent peak callout
        const svg = document.getElementById('wifi-radar-svg');
        const calloutGroup = document.getElementById('radar-hover-callout');
        if (svg && calloutGroup) {
            calloutGroup.innerHTML = '';
            const axis = radarAxis(currentViewBand);
            const xc = axisXForChannel(axis, target.channel);
            const yPeak = (28 + 188) - Math.max(0, Math.min(1, (target.rssi - (-95)) / 65)) * 188;

            const color = target.isSelf ? '#2563eb' : hashColor(target.bssid || target.ssid);
            const name = target.isSelf ? `★ ${target.ssid} (本机)` : (target.ssid || '隐藏热点');
            const txt = `${name}  ${target.rssi} dBm`;

            // Callout Box
            const g = document.createElementNS('http://www.w3.org/2000/svg', 'g');
            const rect = document.createElementNS('http://www.w3.org/2000/svg', 'rect');
            const text = document.createElementNS('http://www.w3.org/2000/svg', 'text');

            text.setAttribute('x', xc);
            text.setAttribute('y', Math.max(16, yPeak - 12));
            text.setAttribute('text-anchor', 'middle');
            text.setAttribute('font-size', '11');
            text.setAttribute('font-weight', '700');
            text.setAttribute('fill', '#ffffff');
            text.textContent = txt;

            // Render text first to measure or estimate width
            const boxW = Math.min(220, txt.length * 7 + 16);
            rect.setAttribute('x', xc - boxW / 2);
            rect.setAttribute('y', Math.max(4, yPeak - 24));
            rect.setAttribute('width', boxW);
            rect.setAttribute('height', '18');
            rect.setAttribute('rx', '5');
            rect.setAttribute('fill', color);
            rect.style.filter = 'drop-shadow(0 2px 5px rgba(0,0,0,0.25))';

            g.appendChild(rect);
            g.appendChild(text);
            calloutGroup.appendChild(g);
            calloutGroup.style.display = 'block';
        }

        // 3. Highlight list item
        const allItems = document.querySelectorAll('.radar-ap-card, .radar-ap-item');
        allItems.forEach(item => {
            if (item.getAttribute('data-id') === apId) {
                item.classList.add('active');
            } else {
                item.classList.remove('active');
            }
        });
    }

    function unhighlightAP() {
        activeHighlightId = null;

        const allCurves = document.querySelectorAll('.radar-curve-group');
        allCurves.forEach(cg => {
            cg.classList.remove('dimmed');
            cg.classList.remove('highlighted');
        });

        const calloutGroup = document.getElementById('radar-hover-callout');
        if (calloutGroup) {
            calloutGroup.style.display = 'none';
            calloutGroup.innerHTML = '';
        }

        const allItems = document.querySelectorAll('.radar-ap-card, .radar-ap-item');
        allItems.forEach(item => {
            item.classList.remove('active');
        });
    }

    function updateDiagnostics() {
        if (!radarData) return;

        const currentChEl = document.getElementById('radar-cur-channel');
        const recommendChEl = document.getElementById('radar-rec-channel');
        const scoreEl = document.getElementById('radar-rec-score');
        const reasonEl = document.getElementById('radar-rec-reason');
        const btnAuto = document.getElementById('btn-auto-switch-channel');

        const curCh = radarData.current_channel;
        const is24G = currentViewBand === '2.4G';
        const bestCh = is24G ? radarData.best_channel_24g : radarData.best_channel_5g;

        const scores = is24G ? radarData.scores_24g : radarData.scores_5g;
        const scoreObj = scores ? scores.find(s => s.channel === bestCh) : null;
        const scoreVal = scoreObj ? scoreObj.score : 95;
        const apCount = scoreObj ? scoreObj.ap_count : 0;

        const curScores = (radarData.current_mode === '2.4G') ? radarData.scores_24g : radarData.scores_5g;
        const curScoreObj = curScores ? curScores.find(s => s.channel === curCh) : null;
        const curScoreVal = curScoreObj ? curScoreObj.score : (bestCh === curCh ? scoreVal : null);

        if (currentChEl) {
            const freqText = radarData.current_freq ? `${radarData.current_freq} MHz · ` : '';
            const modeText = radarData.current_mode || '';
            currentChEl.textContent = curCh ? `信道 ${curCh} (${freqText}${modeText})` : '自动选择';
        }

        const curScoreEl = document.getElementById('radar-cur-score');
        if (curScoreEl) {
            if (curScoreVal !== null && curScoreVal !== undefined) {
                curScoreEl.textContent = `(清洁度 ${curScoreVal}分)`;
                curScoreEl.style.color = curScoreVal >= 80 ? '#15803d' : curScoreVal >= 50 ? '#ca8a04' : '#dc2626';
            } else {
                curScoreEl.textContent = '';
            }
        }

        if (recommendChEl) {
            recommendChEl.textContent = `信道 ${bestCh}`;
        }

        if (scoreEl) {
            scoreEl.textContent = `(清洁度 ${scoreVal}分)`;
        }

        if (reasonEl) {
            if (bestCh === curCh) {
                reasonEl.textContent = '当前信道同频干扰最低';
                if (btnAuto) {
                    btnAuto.disabled = true;
                    btnAuto.textContent = '✓ 当前最佳';
                }
            } else {
                reasonEl.textContent = `同频干扰更低（附近同频 ${apCount} 个）`;
                if (btnAuto) {
                    btnAuto.disabled = false;
                    btnAuto.textContent = '⚡ 一键应用';
                }
            }
        }
    }

    async function applyRecommendedChannel() {
        if (!radarData) return;
        const is24G = currentViewBand === '2.4G';
        const bestCh = is24G ? radarData.best_channel_24g : radarData.best_channel_5g;

        const confirmMsg = `切换信道需要重新初始化射频发射机，Wi-Fi 连接将短暂断开约 2 秒（手机与电脑会自动重连）。\n\n确定将 ${currentViewBand} 信道切换至最优信道【${bestCh}】吗？`;
        if (!window.confirm(confirmMsg)) return;

        switchChannel(bestCh, currentViewBand);
    }

    async function switchChannel(channel, mode) {
        const btnAuto = document.getElementById('btn-auto-switch-channel');
        const applyBtn = document.getElementById('apply-channel');
        if (btnAuto) btnAuto.disabled = true;
        if (applyBtn) applyBtn.disabled = true;

        if (typeof showChannelStatus === 'function') {
            showChannelStatus('正在切换信道，断线后请重新连接', 'pending');
        }
        if (typeof window.markChannelPending === 'function') window.markChannelPending(channel);
        showRadarToast(`正在切换至信道 ${channel}，物理射频重载中…`);

        try {
            const resp = await fetch('/air-api/wifi/channel', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ channel: channel, mode: mode })
            });
            const data = await resp.json();
            if (!resp.ok) throw new Error(data.error || '信道切换指令拒绝');

            if (typeof showChannelStatus === 'function') {
                showChannelStatus('已生效', 'success');
            }
            showRadarToast(data.message || `信道已成功切换至 ${channel}`);

            // Trigger radar refresh after channel change
            setTimeout(() => fetchRadarData(true), 3000);
        } catch (e) {
            console.error('Channel switch error:', e);
            if (typeof showChannelStatus === 'function') {
                showChannelStatus('切换失败: ' + e.message, 'error');
            }
            showRadarToast('信道切换失败: ' + e.message, 'error');
        } finally {
            if (btnAuto) btnAuto.disabled = false;
            if (applyBtn) applyBtn.disabled = false;
        }
    }

    function showRadarToast(text, type = '') {
        if (typeof window.showToast === 'function') {
            window.showToast(text, type);
            return;
        }
        const toast = document.getElementById('toast');
        const toastText = document.getElementById('toast-text');
        if (!toast || !toastText) return;

        toastText.textContent = text;
        toast.className = type === 'error' ? 'toast error' : 'toast';
        toast.classList.add('show');
        setTimeout(() => toast.classList.remove('show'), 3000);
    }

    function escapeHtml(str) {
        if (!str) return '';
        return String(str).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;');
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', initRadarUI);
    } else {
        initRadarUI();
    }
})();
