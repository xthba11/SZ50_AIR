/* SZ50 AIR Smart Battery Protection & Charging Rule Script */
(function() {
    'use strict';

    let pollTimer = null;
    let isSaving = false;

    function formatDuration(seconds) {
        if (!seconds || !Number.isFinite(Number(seconds)) || Number(seconds) <= 0) return '—';
        const sec = Number(seconds);
        const hrs = Math.floor(sec / 3600);
        const mins = Math.round((sec % 3600) / 60);
        if (hrs > 0) {
            return mins > 0 ? `约 ${hrs} 小时 ${mins} 分钟` : `约 ${hrs} 小时`;
        }
        return mins > 0 ? `约 ${mins} 分钟` : '即将完成';
    }

    function initChargeUI() {
        const mount = document.getElementById('air-charge-mount');
        if (!mount) return false;
        if (document.getElementById('air-charge-card')) return true;


        const card = document.createElement('div');
        card.id = 'air-charge-card';
        card.className = 'air-charge-card';
        card.innerHTML = `
            <div class="air-charge-header">
                <div class="air-charge-title-wrap">
                    <div class="air-charge-icon-wrap">⚡</div>
                    <div>
                        <h3>智能电池保护与充电规则</h3>
                    </div>
                </div>
                <div id="air-charge-badge" class="air-charge-badge disabled">
                    <span class="air-charge-badge-dot"></span>
                    <span id="air-charge-badge-text">保护已停用</span>
                </div>
            </div>

            <div class="air-charge-stats-grid">
                <div class="air-charge-stat-item">
                    <div class="air-charge-stat-label">当前电池电量</div>
                    <div class="air-charge-stat-val">
                        <span id="air-charge-cap">--</span>
                        <span class="air-charge-stat-unit">%</span>
                    </div>
                    <div class="air-charge-bar-wrap">
                        <div id="air-charge-bar" class="air-charge-bar-fill" style="width: 0%"></div>
                    </div>
                </div>
                <div class="air-charge-stat-item">
                    <div class="air-charge-stat-label">电源与充电状态</div>
                    <div class="air-charge-stat-val">
                        <span id="air-charge-status" style="font-size: 16px;">读取中…</span>
                    </div>
                    <div id="air-charge-substatus" style="font-size: 11px; color: #64748b; margin-top: 8px;">
                        正在同步硬件控制器
                    </div>
                </div>
                <div class="air-charge-stat-item">
                    <div class="air-charge-stat-label">实时电池电压</div>
                    <div class="air-charge-stat-val">
                        <span id="air-charge-volt">--</span>
                        <span class="air-charge-stat-unit">V</span>
                    </div>
                    <div id="air-charge-subvolt" style="font-size: 11px; color: #64748b; margin-top: 8px;">
                        额定区间 3.400 ~ 4.400 V
                    </div>
                </div>
                <div class="air-charge-stat-item">
                    <div class="air-charge-stat-label">实时电池电流</div>
                    <div class="air-charge-stat-val">
                        <span id="air-charge-curr">--</span>
                        <span class="air-charge-stat-unit">mA</span>
                    </div>
                    <div id="air-charge-subcurr" style="font-size: 11px; color: #64748b; margin-top: 8px;">
                        输入充电 / 输出放电
                    </div>
                </div>
                <div class="air-charge-stat-item">
                    <div class="air-charge-stat-label" id="air-charge-est-label">预计充放电时间</div>
                    <div class="air-charge-stat-val">
                        <span id="air-charge-est" style="font-size: 16px; font-weight: 700; color: #059669;">--</span>
                    </div>
                    <div id="air-charge-subest" style="font-size: 11px; color: #64748b; margin-top: 8px;">
                        预计充满 / 电池续航时长
                    </div>
                </div>
            </div>

            <div class="air-charge-form-box">
                <div class="air-charge-field-row" style="background:#f8fafc;padding:12px 14px;border-radius:10px;margin-bottom:14px;border:1px solid #e2e8f0;">
                    <div class="air-charge-field-info">
                        <h4 style="font-size:14px;color:#0f172a;display:flex;align-items:center;gap:6px;">
                            <span>🔋 硬件充电开关</span>
                            <span id="air-charge-master-tag" style="font-size:11px;padding:2px 8px;border-radius:6px;background:#e0f2fe;color:#0369a1;font-weight:600;">充电开启中</span>
                        </h4>
                        <p>手动控制充电通道供电。关闭后将完全切断外部电源向电池充电，由电池独立供电</p>
                    </div>
                    <div>
                        <label class="air-charge-switch">
                            <input type="checkbox" id="air-charge-master-toggle" checked>
                            <span class="air-charge-slider"></span>
                        </label>
                    </div>
                </div>

                <div class="air-charge-field-row">
                    <div class="air-charge-field-info">
                        <h4>启用智能保护规则</h4>
                        <p>自动在达到电量上限时切断充电，降至下限时自动恢复充电</p>
                    </div>
                    <div>
                        <label class="air-charge-switch">
                            <input type="checkbox" id="air-charge-toggle">
                            <span class="air-charge-slider"></span>
                        </label>
                    </div>
                </div>

                <div class="air-charge-field-row">
                    <div class="air-charge-field-info">
                        <h4>停止充电电量阈值 (上限)</h4>
                        <p>达到此电量时自动断开充电，推荐 80% 防止锂电池高压饱和老化</p>
                    </div>
                    <div class="air-charge-input-wrap">
                        <input type="number" id="air-charge-stop" class="air-charge-input" min="10" max="100" step="5" value="80">
                        <span class="air-charge-input-unit">%</span>
                    </div>
                </div>

                <div class="air-charge-field-row">
                    <div class="air-charge-field-info">
                        <h4>恢复充电电量阈值 (下限)</h4>
                        <p>电量消耗至此数值时自动恢复充电，推荐 20% 避免深度亏电</p>
                    </div>
                    <div class="air-charge-input-wrap">
                        <input type="number" id="air-charge-start" class="air-charge-input" min="5" max="95" step="5" value="20">
                        <span class="air-charge-input-unit">%</span>
                    </div>
                </div>
            </div>

            <div class="air-charge-action-row">
                <div id="air-charge-msg" class="air-charge-msg">
                    <span>就绪</span>
                </div>
                <button type="button" id="air-charge-btn-save" class="air-charge-btn-save">保存充电规则</button>
            </div>

            <div class="air-charge-tip">
                <strong>💡 电池寿命保护建议：</strong>
                锂电池长期处于 100% 高压满电或低压过放状态均会加速电极材料衰减。设定 <strong>20% 开始充电</strong> 与 <strong>80% 停止充电</strong> 的回滞区间，不仅能有效防止发热和电池鼓包，还可显著延长锂电池循环使用寿命。
            </div>
        `;

        mount.appendChild(card);

        // Bind events
        document.getElementById('air-charge-btn-save').addEventListener('click', saveChargeRule);
        const masterToggle = document.getElementById('air-charge-master-toggle');
        if (masterToggle) {
            masterToggle.addEventListener('change', async function() {
                const wantOn = masterToggle.checked;
                masterToggle.disabled = true;
                const msgEl = document.getElementById('air-charge-msg');
                if (msgEl) msgEl.textContent = wantOn ? '正在开启硬件充电...' : '正在切断硬件充电...';
                try {
                    const res = await fetch('/air-api/charge', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/json' },
                        body: JSON.stringify({ charging_enabled: wantOn })
                    });
                    if (!res.ok) throw new Error('控制失败: ' + res.status);
                    const data = await res.json();
                    updateView(data);
                    if (msgEl) msgEl.innerHTML = `<span style="color:#059669;font-weight:600;">✓ 硬件充电${wantOn ? '已开启' : '已切断'}</span>`;
                } catch (err) {
                    masterToggle.checked = !wantOn;
                    if (msgEl) msgEl.innerHTML = `<span style="color:#e11d48">❌ 控制失败: ${err.message}</span>`;
                } finally {
                    masterToggle.disabled = false;
                }
            });
        }

        // Initial fetch
        fetchChargeStatus();

        if (!pollTimer) {
            pollTimer = setInterval(fetchChargeStatus, 5000);
        }

        return true;
    }

    function updateView(data) {
        if (!data) return;

        const badge = document.getElementById('air-charge-badge');
        const badgeText = document.getElementById('air-charge-badge-text');
        const capEl = document.getElementById('air-charge-cap');
        const barEl = document.getElementById('air-charge-bar');
        const statusEl = document.getElementById('air-charge-status');
        const substatusEl = document.getElementById('air-charge-substatus');
        const toggleEl = document.getElementById('air-charge-toggle');
        const masterToggle = document.getElementById('air-charge-master-toggle');
        const masterTag = document.getElementById('air-charge-master-tag');
        const stopEl = document.getElementById('air-charge-stop');
        const startEl = document.getElementById('air-charge-start');
        const msgEl = document.getElementById('air-charge-msg');

        if (masterToggle && document.activeElement !== masterToggle && !isSaving) {
            masterToggle.checked = (data.charging_enabled !== false);
        }
        if (masterTag) {
            const isChargingOn = (data.charging_enabled !== false);
            masterTag.textContent = isChargingOn ? '充电开启中' : '已切断充电';
            masterTag.style.background = isChargingOn ? '#e0f2fe' : '#fee2e2';
            masterTag.style.color = isChargingOn ? '#0369a1' : '#b91c1c';
        }

        if (toggleEl && document.activeElement !== toggleEl && !isSaving) {
            toggleEl.checked = !!data.enabled;
        }

        if (badge && badgeText) {
            if (data.enabled) {
                badge.className = 'air-charge-badge active';
                badgeText.textContent = data.charging_stopped ? '保护已切断充电' : '保护运行中';
            } else {
                badge.className = 'air-charge-badge disabled';
                badgeText.textContent = '保护已停用';
            }
        }

        const cap = Number(data.capacity) || 0;
        if (capEl) capEl.textContent = cap;
        if (barEl) {
            barEl.style.width = Math.min(100, Math.max(0, cap)) + '%';
            if (cap <= 20) {
                barEl.style.background = '#f59e0b';
            } else if (cap >= 85) {
                barEl.style.background = '#8b5cf6';
            } else {
                barEl.style.background = '#10b981';
            }
        }

        if (statusEl) {
            let st = data.status || 'Unknown';
            if (st === 'Charging') st = '正在充电 (Charging)';
            else if (st === 'Discharging') st = '放电中 (Discharging)';
            else if (st === 'Not charging') st = '未充电 (Not charging)';
            else if (st === 'Full') st = '已充满 (Full)';
            statusEl.textContent = st;
        }

        if (substatusEl) {
            if (data.charging_stopped) {
                substatusEl.innerHTML = '<span style="color:#e11d48;font-weight:600;">⚡ 硬件充电已断开（保护生效）</span>';
            } else {
                substatusEl.innerHTML = '<span style="color:#059669;">⚡ 硬件充电通道开启中</span>';
            }
        }

        const voltEl = document.getElementById('air-charge-volt');
        const currEl = document.getElementById('air-charge-curr');
        const subcurrEl = document.getElementById('air-charge-subcurr');
        if (voltEl) {
            if (typeof data.voltage_v === 'number' && data.voltage_v > 0) {
                voltEl.textContent = data.voltage_v.toFixed(3);
            } else {
                voltEl.textContent = '--';
            }
        }
        if (currEl) {
            if (typeof data.current_ma === 'number') {
                const c = data.current_ma;
                currEl.textContent = (c > 0 ? '+' : '') + c;
                if (subcurrEl) {
                    if (c > 0) {
                        subcurrEl.innerHTML = '<span style="color:#059669;font-weight:600;">⚡ 充电中（+输入）</span>';
                    } else if (c < 0) {
                        subcurrEl.innerHTML = '<span style="color:#d97706;font-weight:600;">🔋 放电中（-输出）</span>';
                    } else {
                        subcurrEl.innerHTML = '<span>⚡ 静态待机（0 mA）</span>';
                    }
                }
            } else {
                currEl.textContent = '--';
            }
        }

        const estEl = document.getElementById('air-charge-est');
        const estLabelEl = document.getElementById('air-charge-est-label');
        const subestEl = document.getElementById('air-charge-subest');
        if (estEl) {
            const st = data.status || '';
            const cMa = typeof data.current_ma === 'number' ? Math.abs(data.current_ma) : 0;
            if (st === 'Charging') {
                if (estLabelEl) estLabelEl.textContent = '预计充满剩余时间';
                estEl.style.color = '#059669';
                if (typeof data.time_to_full_sec === 'number' && data.time_to_full_sec > 0) {
                    estEl.textContent = formatDuration(data.time_to_full_sec);
                    if (subestEl) subestEl.textContent = '按硬件实时充电速率计算';
                } else if (cMa > 50 && cap < 100) {
                    const fullCap = 3650; // 典型电池 3650mAh
                    const remainCap = fullCap * (1 - cap / 100);
                    const sec = Math.max(60, (remainCap / cMa) * 3600);
                    estEl.textContent = formatDuration(sec);
                    if (subestEl) subestEl.textContent = '按当前实时充电电流测算';
                } else if (cap >= 100) {
                    estEl.textContent = '即将充满';
                    if (subestEl) subestEl.textContent = '已达满电区间';
                } else {
                    estEl.textContent = '正在估算…';
                    if (subestEl) subestEl.textContent = '等待电流稳定';
                }
            } else if (st === 'Full') {
                if (estLabelEl) estLabelEl.textContent = '电池供电状态';
                estEl.style.color = '#10b981';
                estEl.textContent = '已充满 (持续供电)';
                if (subestEl) subestEl.textContent = '拔掉电源预计续航约 7.5 小时';
            } else {
                // 放电、未充电或断开充电
                if (estLabelEl) estLabelEl.textContent = (st === 'Discharging' ? '预计电池可用续航' : '预计续航 (未充电)');
                estEl.style.color = '#2563eb';
                if (cMa > 50 && cap > 0) {
                    const fullCap = 3650;
                    const curCap = fullCap * (cap / 100);
                    const sec = (curCap / cMa) * 3600;
                    estEl.textContent = formatDuration(sec);
                    if (subestEl) subestEl.textContent = '按当前放电功耗测算';
                } else if (cap > 0) {
                    const totalSec = 7.5 * 3600;
                    const sec = (cap / 100) * totalSec;
                    estEl.textContent = formatDuration(sec);
                    if (subestEl) subestEl.textContent = '按随身Wi-Fi典型功耗估算';
                } else {
                    estEl.textContent = '正在估算…';
                    if (subestEl) subestEl.textContent = '等待电池状态刷新';
                }
            }
        }

        if (stopEl && document.activeElement !== stopEl && !isSaving) {
            stopEl.value = data.stop_percent || 80;
        }
        if (startEl && document.activeElement !== startEl && !isSaving) {
            startEl.value = data.start_percent || 20;
        }

        if (msgEl && !isSaving && data.message) {
            msgEl.textContent = data.message;
        }
    }

    async function fetchChargeStatus() {
        try {
            const res = await fetch('/air-api/charge', { cache: 'no-store' });
            if (!res.ok) return;
            const data = await res.json();
            updateView(data);
        } catch (e) {
            // Ignore temporary fetch error
        }
    }

    async function saveChargeRule() {
        const toggleEl = document.getElementById('air-charge-toggle');
        const stopEl = document.getElementById('air-charge-stop');
        const startEl = document.getElementById('air-charge-start');
        const msgEl = document.getElementById('air-charge-msg');
        const btnSave = document.getElementById('air-charge-btn-save');

        const enabled = toggleEl ? toggleEl.checked : false;
        let startVal = parseInt(startEl.value, 10);
        let stopVal = parseInt(stopEl.value, 10);

        if (isNaN(startVal) || startVal < 5) startVal = 20;
        if (isNaN(stopVal) || stopVal > 100) stopVal = 80;

        if (startVal >= stopVal) {
            if (msgEl) {
                msgEl.innerHTML = '<span style="color:#e11d48">❌ 开始充电百分比必须小于停止充电百分比</span>';
            }
            return;
        }

        isSaving = true;
        if (btnSave) {
            btnSave.disabled = true;
            btnSave.textContent = '保存中…';
        }
        if (msgEl) {
            msgEl.textContent = '正在下发规则到后台服务…';
        }

        const masterToggle = document.getElementById('air-charge-master-toggle');
        const chargingEnabled = masterToggle ? masterToggle.checked : true;

        try {
            const res = await fetch('/air-api/charge', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({
                    charging_enabled: chargingEnabled,
                    enabled: enabled,
                    start_percent: startVal,
                    stop_percent: stopVal
                })
            });

            if (!res.ok) {
                throw new Error('服务器响应异常: ' + res.status);
            }

            const data = await res.json();
            updateView(data);

            if (msgEl) {
                msgEl.innerHTML = '<span style="color:#059669;font-weight:600;">✓ 充电规则保存成功并已生效！</span>';
            }
        } catch (err) {
            if (msgEl) {
                msgEl.innerHTML = `<span style="color:#e11d48">❌ 保存失败: ${err.message}</span>`;
            }
        } finally {
            isSaving = false;
            if (btnSave) {
                btnSave.disabled = false;
                btnSave.textContent = '保存充电规则';
            }
        }
    }

    // Observe tab switches
    function setupObserver() {
        if (initChargeUI()) return;

        const observer = new MutationObserver(function() {
            if (initChargeUI()) {
                // Done
            }
        });

        observer.observe(document.body, {
            childList: true,
            subtree: true
        });
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', setupObserver);
    } else {
        setupObserver();
    }
})();
