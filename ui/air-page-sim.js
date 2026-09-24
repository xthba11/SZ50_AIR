/* sim 页逻辑（从原内联脚本抽出）
   · IIFE 隔离：这些脚本有几十个顶层声明，不隔离会和其它分页/主界面冲突
   · DOMContentLoaded 拦截：脚本是「切到该页时才动态加载」的，那时该事件早已触发，
     拦截后改为立即执行，否则页面会停在初始的"读取中"状态 */
(function(){
  var _ael = document.addEventListener.bind(document), _wrap = true;
  document.addEventListener = function(t, fn, o){
    if (_wrap && t === 'DOMContentLoaded') {
      if (document.readyState === 'loading') { return _ael(t, fn, o); }
      try { fn(); } catch (e) { console.error('[page-init]', e); }
      return;
    }
    return _ael(t, fn, o);
  };

        let currentSimData = {};
        let currentNetworkData = {};

        function airSimInit() {
            loadSimData();
            loadNetworkModeData();
            setupButtonEvents();
            initSpeedChart();
        }
        if (document.readyState === 'loading') { window.addEventListener('load', airSimInit); } else { airSimInit(); }
        
        function setupButtonEvents() {
            // SIM卡切换按钮
            document.getElementById('switch-to-sim1').addEventListener('click', function() {
                switchSimCard('SIM1');
            });
            
            document.getElementById('switch-to-sim2').addEventListener('click', function() {
                switchSimCard('SIM2');
            });
            
            // 网络模式切换按钮
            document.getElementById('switch-to-auto').addEventListener('click', function() {
                switchNetworkMode('auto');
            });
            
            document.getElementById('switch-to-5g').addEventListener('click', function() {
                switchNetworkMode('5g_only');
            });
            
            document.getElementById('switch-to-4g').addEventListener('click', function() {
                switchNetworkMode('4g_only');
            });
        }
        
        function loadSimData() {
            fetch('/cgi-bin/traffic.cgi?action=get_wifi')
                .then(response => {
                    if (!response.ok) throw new Error('网络请求失败');
                    return response.json();
                })
                .then(data => {
                    currentSimData = data;
                    updateSimDisplay(data);
                })
                .catch(error => {
                    console.error('加载SIM卡数据失败:', error);
                    document.getElementById('current-sim').textContent = '加载失败';
                });
        }
        
        function loadNetworkModeData() {
            fetch('/cgi-bin/traffic.cgi?action=get_network_mode')
                .then(response => {
                    if (!response.ok) throw new Error('网络请求失败');
                    return response.json();
                })
                .then(data => {
                    currentNetworkData = data;
                    updateNetworkModeDisplay(data);
                })
                .catch(error => {
                    console.error('加载网络模式数据失败:', error);
                    document.getElementById('current-network-mode').textContent = '加载失败';
                });
        }
        
        function updateSimDisplay(data) {
            const currentSim = data.sim_status || '未知';
            document.getElementById('current-sim').textContent = currentSim;
            
            const sim1Btn = document.getElementById('switch-to-sim1');
            const sim2Btn = document.getElementById('switch-to-sim2');
            
            if (currentSim === 'SIM1') {
                sim1Btn.disabled = true;
                sim1Btn.className = 'btn btn-disabled';
                sim2Btn.disabled = false;
                sim2Btn.className = 'btn';
            } else if (currentSim === 'SIM2') {
                sim1Btn.disabled = false;
                sim1Btn.className = 'btn';
                sim2Btn.disabled = true;
                sim2Btn.className = 'btn btn-disabled';
            } else {
                sim1Btn.disabled = false;
                sim1Btn.className = 'btn';
                sim2Btn.disabled = false;
                sim2Btn.className = 'btn';
            }
        }
        
        function updateNetworkModeDisplay(data) {
            const currentMode = data.network_mode || '未知';
            const modeCode = data.mode_code || '未知';
            const modeDesc = data.mode_desc || '';
            
            document.getElementById('current-network-mode').textContent = currentMode;
            document.getElementById('network-mode-code').textContent = modeCode;
            document.getElementById('network-mode-desc').textContent = modeDesc;
            
            // 更新按钮状态
            const autoBtn = document.getElementById('switch-to-auto');
            const fiveGBtn = document.getElementById('switch-to-5g');
            const fourGBtn = document.getElementById('switch-to-4g');
            
            // 重置所有按钮
            autoBtn.disabled = false;
            autoBtn.className = 'btn';
            fiveGBtn.disabled = false;
            fiveGBtn.className = 'btn';
            fourGBtn.disabled = false;
            fourGBtn.className = 'btn';
            
            // 根据当前模式禁用相应按钮
            if (currentMode.includes('自动模式')) {
                autoBtn.disabled = true;
                autoBtn.className = 'btn btn-disabled';
            } else if (currentMode.includes('仅5G')) {
                fiveGBtn.disabled = true;
                fiveGBtn.className = 'btn btn-disabled';
            } else if (currentMode.includes('仅4G')) {
                fourGBtn.disabled = true;
                fourGBtn.className = 'btn btn-disabled';
            }
        }
        
        function switchSimCard(targetSim) {
            showToast('SIM卡切换中...', 'info');
            
            document.getElementById('switch-to-sim1').disabled = true;
            document.getElementById('switch-to-sim2').disabled = true;
            document.getElementById('switch-to-sim1').className = 'btn btn-disabled';
            document.getElementById('switch-to-sim2').className = 'btn btn-disabled';
            
            fetch('/cgi-bin/traffic.cgi', {
                method: 'POST',
                headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                body: `action=switch_sim&target_sim=${targetSim}`
            })
            .then(response => {
                if (!response.ok) throw new Error('切换失败');
                return response.json();
            })
            .then(data => {
                showToast(data.message || `已切换到${targetSim}`);
                setTimeout(() => {
                    loadSimData();
                }, 2000);
            })
            .catch(error => {
                const message = `切换到${targetSim}失败: ` + error.message;
                showToast(message, 'error');
                setTimeout(() => {
                    loadSimData();
                }, 2000);
            });
        }
        
        function switchNetworkMode(targetMode) {
            let modeName = '';
            switch(targetMode) {
                case 'auto': modeName = '自动模式'; break;
                case '5g_only': modeName = '仅5G模式'; break;
                case '4g_only': modeName = '仅4G模式'; break;
            }
            
            showToast(`${modeName}切换中...`, 'info');
            
            const networkBtns = ['switch-to-auto', 'switch-to-5g', 'switch-to-4g'];
            networkBtns.forEach(id => {
                const btn = document.getElementById(id);
                btn.disabled = true;
                btn.className = 'btn btn-disabled';
            });
            
            fetch('/cgi-bin/traffic.cgi', {
                method: 'POST',
                headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                body: `action=switch_network_mode&target_mode=${targetMode}`
            })
            .then(response => {
                if (!response.ok) throw new Error('网络模式切换失败');
                return response.json();
            })
            .then(data => {
                showToast(data.message || `已切换到${modeName}`);
                setTimeout(() => {
                    loadNetworkModeData();
                }, 2000);
            })
            .catch(error => {
                const message = `${modeName}切换失败: ` + error.message;
                showToast(message, 'error');
                setTimeout(() => {
                    loadNetworkModeData();
                }, 2000);
            });
        }
        
        function showToast(text, type = '') {
            const toast = document.getElementById('toast');
            const toastText = document.getElementById('toast-text');
            toastText.textContent = text;
            
            if (type === 'error') {
                toast.className = 'toast error';
            } else if (type === 'info') {
                toast.className = 'toast info';
            } else {
                toast.className = 'toast';
            }
            
            toast.classList.add('show');
            if (toast.timeoutId) {
                clearTimeout(toast.timeoutId);
            }
            if (type !== 'info') {
                toast.timeoutId = setTimeout(() => {
                    toast.classList.remove('show');
                }, 3000);
            }
        }

        // ================= 实时网速折线图模块 =================
        function fmtRate(bps) {
            return `${((Number(bps) || 0) / 8000000).toFixed(3)} MB/s`;
        }

        function fmtAxisRate(bps) {
            bps = Number(bps) || 0;
            if (bps <= 0) return '0.000 MB/s';
            const mb = Number((bps / 8000000).toFixed(3));
            return mb + ' MB/s';
        }

        function niceRateMax(bps) {
            bps = Number(bps) || 0;
            const MIN_BPS = 400000; // 最低刻度 0.05 MB/s (400,000 bps)
            if (bps <= MIN_BPS) return MIN_BPS;
            const mb = bps / 8000000;
            const power = 10 ** Math.floor(Math.log10(mb));
            const ratio = mb / power;
            const niceMb = (ratio <= 1 ? 1 : ratio <= 2 ? 2 : ratio <= 5 ? 5 : 10) * power;
            return Math.round(niceMb * 8000000);
        }

        let speedChartInstance = null;

        function initSpeedChart() {
            const proxyContainer = document.getElementById('proxy-chart-container');
            const directContainer = document.getElementById('direct-chart-container');
            const proxyRateBadge = document.getElementById('rate-proxy-text');
            const directRateBadge = document.getElementById('rate-direct-text');
            const proxyDownText = document.getElementById('proxy-down-text');
            const proxyUpText = document.getElementById('proxy-up-text');
            const directDownText = document.getElementById('direct-down-text');
            const directUpText = document.getElementById('direct-up-text');
            const proxyHint = document.getElementById('proxy-samples-hint');
            const directHint = document.getElementById('direct-samples-hint');
            const proxyStatusHint = document.getElementById('proxy-status-hint');

            function buildChart(container, gradDownId, gradUpId, downLineClass, upLineClass, downDotClass, upDotClass, colorDown, colorUp) {
                const svg = document.createElementNS('http://www.w3.org/2000/svg', 'svg');
                svg.setAttribute('viewBox', '0 0 600 110');
                svg.setAttribute('role', 'img');

                const defs = document.createElementNS(svg.namespaceURI, 'defs');
                defs.innerHTML = `
                    <linearGradient id="${gradDownId}" x1="0" y1="0" x2="0" y2="1">
                        <stop offset="0%" stop-color="${colorDown}" stop-opacity="0.22"/>
                        <stop offset="100%" stop-color="${colorDown}" stop-opacity="0"/>
                    </linearGradient>
                    <linearGradient id="${gradUpId}" x1="0" y1="0" x2="0" y2="1">
                        <stop offset="0%" stop-color="${colorUp}" stop-opacity="0.18"/>
                        <stop offset="100%" stop-color="${colorUp}" stop-opacity="0"/>
                    </linearGradient>
                `;
                svg.append(defs);

                const axisLabels = [];
                for (const y of [10, 52, 95]) {
                    const grid = document.createElementNS(svg.namespaceURI, 'line');
                    const label = document.createElementNS(svg.namespaceURI, 'text');
                    grid.setAttribute('x1', '74');
                    grid.setAttribute('x2', '592');
                    grid.setAttribute('y1', String(y));
                    grid.setAttribute('y2', String(y));
                    grid.setAttribute('class', 'sim-speed-grid');

                    label.setAttribute('x', '68');
                    label.setAttribute('y', String(y + 4));
                    label.setAttribute('text-anchor', 'end');
                    label.setAttribute('class', 'sim-speed-axis');
                    svg.append(grid, label);
                    axisLabels.push(label);
                }

                // Area paths
                const pathDown = document.createElementNS(svg.namespaceURI, 'path');
                pathDown.setAttribute('fill', `url(#${gradDownId})`);
                const pathUp = document.createElementNS(svg.namespaceURI, 'path');
                pathUp.setAttribute('fill', `url(#${gradUpId})`);
                svg.append(pathDown, pathUp);

                // Smooth Curve Path Generator
                function getCurvePath(pts, k = 0.18, clampMaxY = 95, clampMinY = 8) {
                    if (!pts || !pts.length) return '';
                    if (pts.length === 1) return `M ${pts[0].x.toFixed(1)},${pts[0].y.toFixed(1)}`;
                    if (pts.length === 2) return `M ${pts[0].x.toFixed(1)},${pts[0].y.toFixed(1)} L ${pts[1].x.toFixed(1)},${pts[1].y.toFixed(1)}`;
                    let d = `M ${pts[0].x.toFixed(1)},${pts[0].y.toFixed(1)}`;
                    for (let i = 0; i < pts.length - 1; i++) {
                        const p0 = pts[Math.max(0, i - 1)];
                        const p1 = pts[i];
                        const p2 = pts[i + 1];
                        const p3 = pts[Math.min(pts.length - 1, i + 2)];

                        let cp1x = p1.x + (p2.x - p0.x) * k;
                        let cp1y = p1.y + (p2.y - p0.y) * k;
                        let cp2x = p2.x - (p3.x - p1.x) * k;
                        let cp2y = p2.y - (p3.y - p1.y) * k;

                        if (clampMaxY !== null) {
                            cp1y = Math.min(clampMaxY, cp1y);
                            cp2y = Math.min(clampMaxY, cp2y);
                        }
                        if (clampMinY !== null) {
                            cp1y = Math.max(clampMinY, cp1y);
                            cp2y = Math.max(clampMinY, cp2y);
                        }

                        d += ` C ${cp1x.toFixed(1)},${cp1y.toFixed(1)} ${cp2x.toFixed(1)},${cp2y.toFixed(1)} ${p2.x.toFixed(1)},${p2.y.toFixed(1)}`;
                    }
                    return d;
                }

                // Smooth Lines
                const lineDown = document.createElementNS(svg.namespaceURI, 'path');
                lineDown.setAttribute('class', downLineClass);
                lineDown.setAttribute('fill', 'none');
                const lineUp = document.createElementNS(svg.namespaceURI, 'path');
                lineUp.setAttribute('class', upLineClass);
                lineUp.setAttribute('fill', 'none');
                svg.append(lineDown, lineUp);

                // End Dots
                const dotDown = document.createElementNS(svg.namespaceURI, 'circle');
                dotDown.setAttribute('r', '3.5');
                dotDown.setAttribute('class', downDotClass);
                const dotUp = document.createElementNS(svg.namespaceURI, 'circle');
                dotUp.setAttribute('r', '3.5');
                dotUp.setAttribute('class', upDotClass);
                svg.append(dotDown, dotUp);

                // Guideline and hover dots
                const guideLine = document.createElementNS(svg.namespaceURI, 'line');
                guideLine.setAttribute('y1', '8');
                guideLine.setAttribute('y2', '95');
                guideLine.setAttribute('stroke', '#94a3b8');
                guideLine.setAttribute('stroke-width', '1');
                guideLine.setAttribute('stroke-dasharray', '3,3');
                guideLine.style.display = 'none';
                guideLine.style.pointerEvents = 'none';

                const hoverDotDown = document.createElementNS(svg.namespaceURI, 'circle');
                hoverDotDown.setAttribute('r', '4.5');
                hoverDotDown.setAttribute('fill', colorDown);
                hoverDotDown.setAttribute('stroke', '#ffffff');
                hoverDotDown.setAttribute('stroke-width', '2');
                hoverDotDown.style.display = 'none';
                hoverDotDown.style.pointerEvents = 'none';

                const hoverDotUp = document.createElementNS(svg.namespaceURI, 'circle');
                hoverDotUp.setAttribute('r', '4.5');
                hoverDotUp.setAttribute('fill', colorUp);
                hoverDotUp.setAttribute('stroke', '#ffffff');
                hoverDotUp.setAttribute('stroke-width', '2');
                hoverDotUp.style.display = 'none';
                hoverDotUp.style.pointerEvents = 'none';

                svg.append(guideLine, hoverDotDown, hoverDotUp);

                // Large Hit Area overlay
                const hitRect = document.createElementNS(svg.namespaceURI, 'rect');
                hitRect.setAttribute('x', '0');
                hitRect.setAttribute('y', '0');
                hitRect.setAttribute('width', '600');
                hitRect.setAttribute('height', '110');
                hitRect.setAttribute('fill', 'transparent');
                hitRect.setAttribute('pointer-events', 'all');
                hitRect.style.cursor = 'crosshair';
                svg.append(hitRect);

                const tooltip = document.createElement('div');
                tooltip.className = 'chart-tooltip';

                container.innerHTML = '';
                container.append(svg, tooltip);

                let curSamplesCache = [], getDownFn = null, getUpFn = null, curPtsDown = [], curPtsUp = [];

                function showHover(clientX) {
                    if (!curPtsDown.length || !curSamplesCache.length) return;
                    const rect = svg.getBoundingClientRect();
                    const relX = Math.max(0, Math.min(1, (clientX - rect.left) / rect.width));
                    const svgX = relX * 600;

                    let closestIdx = 0, minDist = Infinity;
                    curPtsDown.forEach((p, i) => {
                        const d = Math.abs(p.x - svgX);
                        if (d < minDist) {
                            minDist = d;
                            closestIdx = i;
                        }
                    });

                    const pDown = curPtsDown[closestIdx];
                    const pUp = curPtsUp[closestIdx];
                    const s = curSamplesCache[closestIdx];

                    guideLine.setAttribute('x1', pDown.x.toFixed(1));
                    guideLine.setAttribute('x2', pDown.x.toFixed(1));
                    guideLine.style.display = '';

                    hoverDotDown.setAttribute('cx', pDown.x.toFixed(1));
                    hoverDotDown.setAttribute('cy', pDown.y.toFixed(1));
                    hoverDotDown.style.display = '';

                    hoverDotUp.setAttribute('cx', pUp.x.toFixed(1));
                    hoverDotUp.setAttribute('cy', pUp.y.toFixed(1));
                    hoverDotUp.style.display = '';

                    const timeStr = s.at ? new Date(s.at).toLocaleTimeString() : '';
                    const dVal = getDownFn ? fmtRate(getDownFn(s)) : '';
                    const uVal = getUpFn ? fmtRate(getUpFn(s)) : '';

                    tooltip.innerHTML = `
                        <div style="color:#94a3b8;font-size:10px;font-family:monospace;margin-bottom:2px;">${timeStr}</div>
                        <div style="display:flex;gap:8px;font-weight:600;">
                            <span style="color:${colorDown};">↓ ${dVal}</span>
                            <span style="color:${colorUp};">↑ ${uVal}</span>
                        </div>
                    `;
                    tooltip.style.display = 'block';
                    const pixelX = (pDown.x / 600) * rect.width;
                    tooltip.style.left = pixelX + 'px';
                }

                function hideHover() {
                    guideLine.style.display = 'none';
                    hoverDotDown.style.display = 'none';
                    hoverDotUp.style.display = 'none';
                    tooltip.style.display = 'none';
                }

                hitRect.onpointermove = e => showHover(e.clientX);
                hitRect.onpointerdown = e => showHover(e.clientX);
                hitRect.onpointerleave = hideHover;
                hitRect.ontouchstart = e => { if (e.touches.length) showHover(e.touches[0].clientX); };
                hitRect.ontouchmove = e => { if (e.touches.length) showHover(e.touches[0].clientX); };

                return function update(samples, getDown, getUp, isNew) {
                    curSamplesCache = samples;
                    getDownFn = getDown;
                    getUpFn = getUp;

                    const maxVal = Math.max(0, ...samples.flatMap(s => [Number(getDown(s)) || 0, Number(getUp(s)) || 0]));
                    const scale = niceRateMax(maxVal);

                    if (axisLabels.length >= 3) {
                        axisLabels[0].textContent = fmtAxisRate(scale);
                        axisLabels[1].textContent = fmtAxisRate(scale / 2);
                        axisLabels[2].textContent = '0.000 MB/s';
                    }

                    const getX = i => samples.length === 1 ? 74 : 74 + i * 518 / (samples.length - 1);
                    const getY = val => 95 - (Number(val) || 0) * 85 / scale;

                    curPtsDown = samples.map((s, i) => ({ x: getX(i), y: getY(getDown(s)) }));
                    curPtsUp = samples.map((s, i) => ({ x: getX(i), y: getY(getUp(s)) }));

                    const curveDown = getCurvePath(curPtsDown, 0.18, 95, 8);
                    const curveUp = getCurvePath(curPtsUp, 0.18, 95, 8);

                    pathDown.setAttribute('d', curveDown ? `${curveDown} L ${curPtsDown[curPtsDown.length - 1].x.toFixed(1)},95 L ${curPtsDown[0].x.toFixed(1)},95 Z` : '');
                    lineDown.setAttribute('d', curveDown);
                    dotDown.setAttribute('cx', curPtsDown[curPtsDown.length - 1].x.toFixed(1));
                    dotDown.setAttribute('cy', curPtsDown[curPtsDown.length - 1].y.toFixed(1));

                    pathUp.setAttribute('d', curveUp ? `${curveUp} L ${curPtsUp[curPtsUp.length - 1].x.toFixed(1)},95 L ${curPtsUp[0].x.toFixed(1)},95 Z` : '');
                    lineUp.setAttribute('d', curveUp);
                    dotUp.setAttribute('cx', curPtsUp[curPtsUp.length - 1].x.toFixed(1));
                    dotUp.setAttribute('cy', curPtsUp[curPtsUp.length - 1].y.toFixed(1));

                    if (isNew) {
                        for (const el of [lineDown, lineUp, pathDown, pathUp]) {
                            el.classList.remove('speed-slide');
                            void el.clientWidth;
                            el.classList.add('speed-slide');
                        }
                        for (const dot of [dotDown, dotUp]) {
                            dot.classList.remove('speed-dot-enter');
                            void dot.clientWidth;
                            dot.classList.add('speed-dot-enter');
                        }
                    }
                };
            }

            const updateProxy = buildChart(
                proxyContainer,
                'proxyGradDown', 'proxyGradUp',
                'speed-line-proxy', 'speed-line-proxy-up',
                'speed-dot-proxy', 'speed-dot-proxy-up',
                '#8b5cf6', '#f59e0b'
            );

            const updateDirect = buildChart(
                directContainer,
                'directGradDown', 'directGradUp',
                'speed-line-direct', 'speed-line-direct-up',
                'speed-dot-direct', 'speed-dot-direct-up',
                '#2563eb', '#10b981'
            );

            const rateProxyDown = document.getElementById('rate-proxy-down');
            const rateProxyUp = document.getElementById('rate-proxy-up');
            const rateDirectDown = document.getElementById('rate-direct-down');
            const rateDirectUp = document.getElementById('rate-direct-up');

            let lastSampleCount = 0;
            let lastSampleAt = null;

            function renderAll(samples, proxyEnabled) {
                if (!samples || samples.length === 0) {
                    proxyHint.textContent = '';
                    directHint.textContent = '';
                    return;
                }
                const last = samples[samples.length - 1];
                const isNew = samples.length > 1 && (samples.length > lastSampleCount || (last.at && last.at !== lastSampleAt));
                lastSampleCount = samples.length;
                lastSampleAt = last.at;

                updateProxy(samples, s => s.proxy_down_bps, s => s.proxy_up_bps, isNew);
                updateDirect(samples, s => s.direct_down_bps, s => s.direct_up_bps, isNew);

                const totalEl = document.getElementById('sim-speed-total');
                if (totalEl) totalEl.textContent = `整体: ↓ ${fmtRate(last.total_down_bps)}　↑ ${fmtRate(last.total_up_bps)}`;

                const pDown = fmtRate(last.proxy_down_bps);
                const pUp = fmtRate(last.proxy_up_bps);
                const dDown = fmtRate(last.direct_down_bps);
                const dUp = fmtRate(last.direct_up_bps);

                // Update badges
                if (proxyEnabled) {
                    if (proxyRateBadge) proxyRateBadge.textContent = `↓ ${pDown}　↑ ${pUp}`;
                    if (rateProxyDown) rateProxyDown.textContent = pDown;
                    if (rateProxyUp) rateProxyUp.textContent = pUp;
                    if (proxyStatusHint) proxyStatusHint.textContent = '代理通道运行中';
                } else {
                    if (proxyRateBadge) proxyRateBadge.textContent = '未启用代理通道';
                    if (rateProxyDown) rateProxyDown.textContent = '未开启';
                    if (rateProxyUp) rateProxyUp.textContent = '未开启';
                    if (proxyStatusHint) proxyStatusHint.textContent = '未启用透明代理';
                }
                if (directRateBadge) directRateBadge.textContent = `↓ ${dDown}　↑ ${dUp}`;
                if (rateDirectDown) rateDirectDown.textContent = dDown;
                if (rateDirectUp) rateDirectUp.textContent = dUp;

                if (proxyDownText) proxyDownText.textContent = pDown;
                if (proxyUpText) proxyUpText.textContent = pUp;
                if (directDownText) directDownText.textContent = dDown;
                if (directUpText) directUpText.textContent = dUp;

                proxyHint.textContent = '';
                directHint.textContent = '';
            }

            async function fetchSpeed() {
                try {
                    const res = await fetch('/air-api/network/speed', { cache: 'no-store' });
                    if (!res.ok) return;
                    const data = await res.json();
                    if (data.ok && data.samples) {
                        renderAll(data.samples, !!data.proxy_enabled);
                    }
                } catch (e) {
                    // Ignore poll network errors
                }
            }

            fetchSpeed();
            setInterval(fetchSpeed, 2000);
        }
  document.addEventListener = _ael; _wrap = false;
})();
