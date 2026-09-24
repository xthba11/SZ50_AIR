/* liuliang 页逻辑（从原内联脚本抽出）
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

        // 页面加载时初始化数据
        let refreshInterval = 30; // 30秒刷新间隔
        let refreshTimer;
        let currentData = {}; // 初始化数据对象
        let timerStartTime; // 记录定时器开始时间
        
        function airLiuInit() {
            timerStartTime = Date.now();
            startAutoRefresh();
            loadStats();
            loadDailyChart();
        }
        if (document.readyState === 'loading') { window.addEventListener('load', airLiuInit); } else { airLiuInit(); }
        
        // 自动刷新功能（每30秒静默自动更新，移除倒计时行）
        function startAutoRefresh() {
            clearInterval(refreshTimer);
            refreshTimer = setInterval(() => {
                if (!document.hidden) {
                    loadStats();
                    loadDailyChart();
                }
            }, 30000);
        }
        
        // 静默更新
        function showRefreshSuccess() {
        }
        
        // 从后端加载统计数据
        function loadStats() {
            fetch('/cgi-bin/traffic.cgi?action=get_stats')
                .then(response => {
                    if (!response.ok) {
                        throw new Error('网络请求失败: ' + response.status);
                    }
                    return response.json();
                })
                .then(data => {
                    currentData = { ...currentData, ...data };
                    
                    // 更新流量数据原始节点
                    const todayEl = document.getElementById('today-result');
                    const monthEl = document.getElementById('month-result');
                    if (todayEl) todayEl.textContent = data.today_result || '无数据';
                    if (monthEl) monthEl.textContent = data.month_result || '无数据';

                    const todayBadge = document.getElementById('today-total-badge');
                    const monthBadge = document.getElementById('month-total-badge');
                    if (todayBadge && todayBadge.textContent === '--' && data.today_result) {
                        const m = data.today_result.match(/总计\s*([0-9.]+\s*[A-Za-z]+)/);
                        todayBadge.textContent = m ? m[1] : data.today_result;
                    }
                    if (monthBadge && monthBadge.textContent === '--' && data.month_result) {
                        const m = data.month_result.match(/总计\s*([0-9.]+\s*[A-Za-z]+)/);
                        monthBadge.textContent = m ? m[1] : data.month_result;
                    }
                    
                    // 更新限制状态与滑块
                    const limitStatusEl = document.getElementById('limit-status');
                    const switchLimitEl = document.getElementById('switch-limit');
                    if (data.limit_enabled === "1") {
                        limitStatusEl.textContent = "已启用";
                        limitStatusEl.className = "status enabled";
                        switchLimitEl.checked = true;
                    } else {
                        limitStatusEl.textContent = "已禁用";
                        limitStatusEl.className = "status disabled";
                        switchLimitEl.checked = false;
                    }
                    
                    // 更新飞行模式状态与滑块
                    const flightStatusEl = document.getElementById('flight-status');
                    const switchFlightEl = document.getElementById('switch-flight');
                    const isFlight = (data.flight_status || "").includes("已启用");
                    flightStatusEl.textContent = isFlight ? "已启用" : "已禁用";
                    flightStatusEl.className = isFlight ? "status enabled" : "status disabled";
                    switchFlightEl.checked = isFlight;
                    
                    // 更新统计服务状态与滑块
                    const vnstatdStatusEl = document.getElementById('vnstatd-status');
                    const switchVnstatdEl = document.getElementById('switch-vnstatd');
                    const isVnstatdRunning = (data.vnstatd_status === "运行中");
                    if (isVnstatdRunning) {
                        vnstatdStatusEl.textContent = "运行中";
                        vnstatdStatusEl.className = "status enabled";
                        switchVnstatdEl.checked = true;
                    } else {
                        vnstatdStatusEl.textContent = "未运行";
                        vnstatdStatusEl.className = "status disabled";
                        switchVnstatdEl.checked = false;
                    }
                    
                    // 更新限制值输入框
                    if (data.current_limit) {
                        document.getElementById('limit-value').value = data.current_limit;
                    }
                    
                    // 显示比较结果
                    const compareAlert = document.getElementById('compare-alert');
                    if (data.compare_result) {
                        compareAlert.textContent = data.compare_result;
                        compareAlert.style.display = 'block';
                    } else {
                        compareAlert.style.display = 'none';
                    }
                })
                .catch(error => {
                    console.error('加载数据失败:', error);
                    const todayEl = document.getElementById('today-result');
                    const monthEl = document.getElementById('month-result');
                    if (todayEl) todayEl.textContent = '加载失败';
                    if (monthEl) monthEl.textContent = '加载失败';
                    showToast('刷新失败: ' + error.message, 'error');
                });
        }

        // 加载近30天图表与全机/直连/代理用量统计
        function loadDailyChart() {
            const chartBox = document.getElementById('daily-traffic-chart');
            const proxyChartBox = document.getElementById('daily-proxy-chart');
            const todayProxyEl = document.getElementById('today-proxy-result');
            const monthProxyEl = document.getElementById('month-proxy-result');

            fetch('/air-api/traffic/daily', { cache: 'no-store' })
                .then(res => res.json())
                .then(data => {
                    if (data.ok) {
                        const days = data.days || [];
                        const proxyDays = data.proxy_days || [];
                        const pToday = data.proxy_today || {};
                        const pMonth = data.proxy_month || {};

                        const pTodayRx = pToday.rx_bytes || 0;
                        const pTodayTx = pToday.tx_bytes || 0;
                        const pTodayTotal = pToday.total_bytes || (pTodayRx + pTodayTx);

                        const pMonthRx = pMonth.rx_bytes || 0;
                        const pMonthTx = pMonth.tx_bytes || 0;
                        const pMonthTotal = pMonth.total_bytes || (pMonthRx + pMonthTx);

                        // 获取今日日期与本月前缀
                        const todayStr = pToday.date || new Date().toISOString().substring(0, 10);
                        const monthPrefix = pMonth.date || todayStr.substring(0, 7);

                        // 从蜂窝统计中提取今日与当月
                        const cTodayItem = days.find(d => d.date === todayStr);
                        const cTodayRx = cTodayItem ? (cTodayItem.rx_bytes || 0) : 0;
                        const cTodayTx = cTodayItem ? (cTodayItem.tx_bytes || 0) : 0;
                        const cTodayTotal = cTodayItem ? (cTodayItem.total_bytes || (cTodayRx + cTodayTx)) : 0;

                        let cMonthRx = 0, cMonthTx = 0, cMonthTotal = 0;
                        days.forEach(d => {
                            if (d.date && d.date.startsWith(monthPrefix)) {
                                cMonthRx += (d.rx_bytes || 0);
                                cMonthTx += (d.tx_bytes || 0);
                                cMonthTotal += (d.total_bytes || ((d.rx_bytes || 0) + (d.tx_bytes || 0)));
                            }
                        });

                        // 直连统计 = 蜂窝总量 - 代理总量 (>= 0)
                        const dTodayRx = Math.max(0, cTodayRx - pTodayRx);
                        const dTodayTx = Math.max(0, cTodayTx - pTodayTx);
                        const dTodayTotal = dTodayRx + dTodayTx;

                        const dMonthRx = Math.max(0, cMonthRx - pMonthRx);
                        const dMonthTx = Math.max(0, cMonthTx - pMonthTx);
                        const dMonthTotal = dMonthRx + dMonthTx;

                        // 更新今日卡片
                        const todayBadge = document.getElementById('today-total-badge');
                        if (todayBadge) todayBadge.textContent = fmtBytesLocal(cTodayTotal > 0 ? cTodayTotal : (dTodayTotal + pTodayTotal));
                        const tDRx = document.getElementById('today-direct-rx'); if (tDRx) tDRx.textContent = fmtBytesLocal(dTodayRx);
                        const tDTx = document.getElementById('today-direct-tx'); if (tDTx) tDTx.textContent = fmtBytesLocal(dTodayTx);
                        const tDTotal = document.getElementById('today-direct-total'); if (tDTotal) tDTotal.textContent = fmtBytesLocal(dTodayTotal);
                        const tPRx = document.getElementById('today-proxy-rx'); if (tPRx) tPRx.textContent = fmtBytesLocal(pTodayRx);
                        const tPTx = document.getElementById('today-proxy-tx'); if (tPTx) tPTx.textContent = fmtBytesLocal(pTodayTx);
                        const tPTotal = document.getElementById('today-proxy-total'); if (tPTotal) tPTotal.textContent = fmtBytesLocal(pTodayTotal);

                        // 更新当月卡片
                        const monthBadge = document.getElementById('month-total-badge');
                        if (monthBadge) monthBadge.textContent = fmtBytesLocal(cMonthTotal > 0 ? cMonthTotal : (dMonthTotal + pMonthTotal));
                        const mDRx = document.getElementById('month-direct-rx'); if (mDRx) mDRx.textContent = fmtBytesLocal(dMonthRx);
                        const mDTx = document.getElementById('month-direct-tx'); if (mDTx) mDTx.textContent = fmtBytesLocal(dMonthTx);
                        const mDTotal = document.getElementById('month-direct-total'); if (mDTotal) mDTotal.textContent = fmtBytesLocal(dMonthTotal);
                        const mPRx = document.getElementById('month-proxy-rx'); if (mPRx) mPRx.textContent = fmtBytesLocal(pMonthRx);
                        const mPTx = document.getElementById('month-proxy-tx'); if (mPTx) mPTx.textContent = fmtBytesLocal(pMonthTx);
                        const mPTotal = document.getElementById('month-proxy-total'); if (mPTotal) mPTotal.textContent = fmtBytesLocal(pMonthTotal);

                        // 保持兼容旧节点文本
                        if (todayProxyEl) todayProxyEl.textContent = `下载: ${fmtBytesLocal(pTodayRx)} 上传: ${fmtBytesLocal(pTodayTx)} 总计: ${fmtBytesLocal(pTodayTotal)}`;
                        if (monthProxyEl) monthProxyEl.textContent = `下载: ${fmtBytesLocal(pMonthRx)} 上传: ${fmtBytesLocal(pMonthTx)} 总计: ${fmtBytesLocal(pMonthTotal)}`;

                        // 1. 蜂窝 30 天图表 (科技蓝/翠绿)
                        if (chartBox) {
                            if (days.length > 0) {
                                renderDailyChart(days, 'daily-traffic-chart', '#2563eb', '#10b981', '蜂窝');
                            } else {
                                chartBox.innerHTML = '<div class="chart-empty">暂无每日流量历史记录（vnStat 正在后台采集中）</div>';
                            }
                        }

                        // 2. 代理 30 天图表 (紫色/橙色)
                        if (proxyChartBox) {
                            if (proxyDays.length > 0) {
                                renderDailyChart(proxyDays, 'daily-proxy-chart', '#8b5cf6', '#f59e0b', '代理');
                            } else {
                                proxyChartBox.innerHTML = '<div class="chart-empty">暂无代理历史流量记录（产生代理流量后自动统计）</div>';
                            }
                        }
                    } else {
                        if (chartBox) chartBox.innerHTML = '<div class="chart-empty">暂无历史数据</div>';
                        if (proxyChartBox) proxyChartBox.innerHTML = '<div class="chart-empty">暂无代理历史记录</div>';
                    }
                })
                .catch(() => {
                    if (chartBox) chartBox.innerHTML = '<div class="chart-empty">流量历史图表加载中…</div>';
                    if (proxyChartBox) proxyChartBox.innerHTML = '<div class="chart-empty">代理历史图表加载中…</div>';
                });
        }

        function fmtBytesLocal(bytes) {
            const gb = bytes / (1024 * 1024 * 1024);
            if (gb >= 0.1) return gb.toFixed(2) + ' GiB';
            const mb = bytes / (1024 * 1024);
            return mb.toFixed(1) + ' MiB';
        }

        function renderDailyChart(days, containerId = 'daily-traffic-chart', rxColor = '#3b82f6', txColor = '#10b981', labelPrefix = '') {
            const container = document.getElementById(containerId);
            if (!container) return;
            if (!days || days.length === 0) {
                container.innerHTML = '<div class="chart-empty">暂无历史数据</div>';
                return;
            }

            // Find max daily total
            let maxTotal = 1024 * 1024 * 100; // 100MB minimum scale
            days.forEach(d => {
                if (d.total_bytes > maxTotal) maxTotal = d.total_bytes;
            });
            maxTotal = maxTotal * 1.15; // 15% headroom

            const svgHeight = 150;
            const svgWidth = 600;
            const padLeft = 65;
            const padRight = 15;
            const padTop = 15;
            const padBottom = 28;
            const plotWidth = svgWidth - padLeft - padRight;
            const plotHeight = svgHeight - padTop - padBottom;

            const barSlot = plotWidth / days.length;
            const barWidth = Math.max(6, Math.min(24, barSlot * 0.55));

            let svg = `<svg viewBox="0 0 ${svgWidth} ${svgHeight}" style="width:100%;height:auto;display:block;" role="img">`;
            
            // Grid lines & labels
            for (let i = 0; i <= 3; i++) {
                const y = padTop + (plotHeight / 3) * i;
                const val = maxTotal * (1 - i / 3);
                svg += `<line x1="${padLeft}" y1="${y}" x2="${svgWidth - padRight}" y2="${y}" stroke="#e2e8f0" stroke-dasharray="2,2"/>`;
                svg += `<text x="${padLeft - 6}" y="${y + 4}" text-anchor="end" font-size="10" fill="#94a3b8">${fmtBytesLocal(val)}</text>`;
            }

            const prefix = labelPrefix ? labelPrefix + ' ' : '';

            // Bars
            days.forEach((d, idx) => {
                const cx = padLeft + barSlot * idx + barSlot / 2;
                const rxH = (d.rx_bytes / maxTotal) * plotHeight;
                const txH = (d.tx_bytes / maxTotal) * plotHeight;
                const totalH = rxH + txH;

                const barX = cx - barWidth / 2;
                const rxY = padTop + plotHeight - rxH;
                const txY = rxY - txH;

                // Rx bar (download)
                if (rxH > 0) {
                    svg += `<rect x="${barX}" y="${rxY}" width="${barWidth}" height="${rxH}" fill="${rxColor}" rx="2">
                        <title>${d.date} ${prefix}下载: ${fmtBytesLocal(d.rx_bytes)}</title>
                    </rect>`;
                }
                // Tx bar (upload stacked on top)
                if (txH > 0) {
                    svg += `<rect x="${barX}" y="${txY}" width="${barWidth}" height="${txH}" fill="${txColor}" rx="2">
                        <title>${d.date} ${prefix}上传: ${fmtBytesLocal(d.tx_bytes)}</title>
                    </rect>`;
                }

                // Date label
                const shortDate = d.date.length >= 10 ? d.date.substring(5) : d.date;
                svg += `<text x="${cx}" y="${svgHeight - 8}" text-anchor="middle" font-size="10" fill="#64748b">${shortDate}</text>`;
            });

            svg += '</svg>';
            container.innerHTML = svg;
        }

        
        // 设置流量限制
        document.getElementById('set-limit').addEventListener('click', function() {
            const limitValue = document.getElementById('limit-value').value;
            
            if (isNaN(limitValue) || parseFloat(limitValue) <= 0) {
                showToast('请输入大于0的数字', 'error');
                return;
            }
            
            fetch('/cgi-bin/traffic.cgi', {
                method: 'POST',
                headers: { 
                    'Content-Type': 'application/x-www-form-urlencoded' 
                },
                body: `action=set_limit&limit=${encodeURIComponent(limitValue)}`
            })
            .then(response => response.json())
            .then(data => {
                showToast(data.message);
                setTimeout(loadStats, 1000);
            })
            .catch(error => {
                showToast('设置失败', 'error');
                console.error('Error:', error);
            });
        });
        
        // 切换流量限制状态
        document.getElementById('toggle-limit').addEventListener('click', function() {
            const btn = this;
            btn.disabled = true;
            showToast('切换中...', 'processing');
            
            fetch('/cgi-bin/traffic.cgi', {
                method: 'POST',
                headers: { 
                    'Content-Type': 'application/x-www-form-urlencoded' 
                },
                body: 'action=toggle_limit'
            })
            .then(response => response.json())
            .then(data => {
                showToast(data.message);
                setTimeout(() => {
                    loadStats();
                    btn.disabled = false;
                }, 1000);
            })
            .catch(error => {
                showToast('流量限制切换失败', 'error');
                console.error('Error:', error);
                btn.disabled = false;
            });
        });

        // 滑块开关联动流量限制
        document.getElementById('switch-limit').addEventListener('change', function() {
            document.getElementById('toggle-limit').click();
        });
        
        // 切换飞行模式
        document.getElementById('toggle-flight').addEventListener('click', function() {
            const btn = this;
            btn.disabled = true;
            showToast('切换中...', 'processing');
            
            fetch('/cgi-bin/traffic.cgi', {
                method: 'POST',
                headers: { 
                    'Content-Type': 'application/x-www-form-urlencoded' 
                },
                body: 'action=toggle_flight'
            })
            .then(response => response.json())
            .then(data => {
                showToast(data.message);
                setTimeout(() => {
                    loadStats();
                    btn.disabled = false;
                }, 4000);
            })
            .catch(error => {
                showToast('飞行模式切换失败', 'error');
                console.error('Error:', error);
                btn.disabled = false;
            });
        });

        // 滑块开关联动飞行模式
        document.getElementById('switch-flight').addEventListener('change', function() {
            document.getElementById('toggle-flight').click();
        });

        // 启停统计服务 (vnstatd)
        document.getElementById('switch-vnstatd').addEventListener('change', async function() {
            const sw = this;
            const wantEnable = sw.checked;
            sw.disabled = true;
            showToast(wantEnable ? '统计服务启动中...' : '统计服务停止中...', 'processing');
            
            try {
                const res = await fetch('/air-api/traffic/vnstatd', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ enabled: wantEnable })
                });
                const data = await res.json();
                if (data.ok) {
                    sw.checked = !!data.running;
                    const stEl = document.getElementById('vnstatd-status');
                    stEl.textContent = data.running ? '运行中' : '未运行';
                    stEl.className = 'status ' + (data.running ? 'enabled' : 'disabled');
                    showToast(data.message || (data.running ? '统计服务已启动' : '统计服务已停止'));
                } else {
                    throw new Error(data.error || '操作失败');
                }
            } catch (err) {
                sw.checked = !wantEnable;
                showToast('统计服务切换失败: ' + err.message, 'error');
            } finally {
                sw.disabled = false;
                setTimeout(loadStats, 1000);
            }
        });

        // 清空统计数据
        document.getElementById('clear-stats').addEventListener('click', function() {
            if (!confirm('确定要清空所有流量统计吗？此操作不可撤销！')) {
                return;
            }
            
            // 同时清空代理30天历史
            fetch('/air-api/traffic/daily', { method: 'DELETE' }).catch(() => {});

            fetch('/cgi-bin/traffic.cgi', {

                method: 'POST',
                headers: { 
                    'Content-Type': 'application/x-www-form-urlencoded' 
                },
                body: 'action=clear_stats'
            })
            .then(response => response.json())
            .then(data => {
                showToast(data.message);
                setTimeout(() => {
                    loadStats();
                    loadDailyChart();
                }, 1000);
            })
            .catch(error => {
                showToast('清空失败', 'error');
                console.error('Error:', error);
            });
        });
        
        /**
         * 显示全局提示框
         * @param {string} text - 提示文本
         * @param {string} type - 类型（空为成功，error为错误，info为信息，processing为处理中）
         */
        function showToast(text, type = '') {
            const toast = document.getElementById('liu-toast');
            const toastText = document.getElementById('liu-toast-text');
            
            toastText.textContent = text;
            toast.className = 'toast';
            if (type === 'error') {
                toast.classList.add('error');
            } else if (type === 'info') {
                toast.classList.add('info');
            } else if (type === 'processing') {
                toast.classList.add('processing');
            }
            toast.classList.add('show');
            
            if (toast.timeoutId) {
                clearTimeout(toast.timeoutId);
            }
            
            toast.timeoutId = setTimeout(() => {
                toast.classList.remove('show');
            }, 3000);
        }
  document.addEventListener = _ael; _wrap = false;
})();
