/* wifi 页逻辑（从原内联脚本抽出）
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
        let currentData = {}; // 初始化数据对象
        let refreshIntervalId; // 所有数据的刷新定时器
        let settingsInitialized = false; // 标记设置区域是否已初始化

        // 信道选项（5G 支持全信道包括 52-64：36, 40, 44, 48, 52, 56, 60, 64, 149, 153, 157, 161, 165）
        const channels24G = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13];
        const channels5G = [36, 40, 44, 48, 52, 56, 60, 64, 149, 153, 157, 161, 165];
        
        function airWifiInit() {
            startRealTimeRefresh();
            setupPasswordToggle();
            setupToggleEvents();
        }
        if (document.readyState === 'loading') { window.addEventListener('load', airWifiInit); } else { airWifiInit(); }
        
        // 实时刷新所有数据
        function startRealTimeRefresh() {
            // 立即加载一次数据
            loadWifiData();
            
            // 设置定时器，每2秒刷新一次所有数据
            refreshIntervalId = setInterval(() => {
                loadWifiData();
            }, 2000);
        }
        
        
        function showModeStatus(text, state) {
            const el = document.getElementById('mode-status');
            if (!el) return;
            el.textContent = text ? '[' + text + ']' : '';
            el.style.color = state === 'success' ? '#15803d' : state === 'error' ? '#dc2626' : state === 'pending' ? '#ca8a04' : '#64748b';
        }
        function showChannelStatus(text, state) {
            const el = document.getElementById('channel-status');
            if (!el) return;
            el.textContent = text ? '[' + text + ']' : '';
            el.style.color = state === 'success' ? '#15803d' : state === 'error' ? '#dc2626' : state === 'pending' ? '#ca8a04' : '#64748b';
        }

        // 设置开关事件
        function setupToggleEvents() {
            // WiFi开关事件
            const wifiToggle = document.getElementById('toggle-wifi');
            const wifiInput = wifiToggle.querySelector('input');
            let wifiBusy = false;

            wifiToggle.addEventListener('click', function(e) {
                e.preventDefault();
                e.stopPropagation();
                if (wifiBusy) return;

                const currentlyOn = wifiInput.checked;
                // 仅从开到关时提示安全警告；从关到开直接开启无需确认
                if (currentlyOn) {
                    if (!window.confirm("确定要关闭 Wi-Fi 吗？关闭后将无法通过 Wi-Fi 访问后台（需通过 USB 网络共享或重启设备恢复）。确定继续？")) {
                        return; // 用户点击取消：什么都不做，开关保持开启状态
                    }
                }

                wifiBusy = true;
                wifiInput.disabled = true;
                wifiToggle.style.opacity = '0.5';

                const targetState = !currentlyOn;
                fetch('/air-api/wifi/power', {
                    method: 'POST',
                    headers: {'Content-Type': 'application/json'},
                    body: JSON.stringify({ enable: targetState })
                })
                .then(response => {
                    if (!response.ok) throw new Error('操作失败');
                    return response.json();
                })
                .then(data => {
                    showToast(data.message || (targetState ? 'Wi-Fi 热点已开启' : 'Wi-Fi 热点已关闭'));
                    wifiInput.checked = targetState;
                    const wifiStatusText = document.getElementById('wifi-status-text-setting');
                    const wifiIcon = document.getElementById('wifi-icon');
                    if (targetState) {
                        if (wifiStatusText) wifiStatusText.textContent = "已启用";
                        if (wifiIcon) wifiIcon.className = "wifi-icon";
                    } else {
                        if (wifiStatusText) wifiStatusText.textContent = "已禁用";
                        if (wifiIcon) wifiIcon.className = "wifi-icon off";
                    }
                })
                .catch(error => {
                    wifiInput.checked = currentlyOn;
                    showToast('操作失败: ' + error.message, 'error');
                })
                .finally(() => {
                    wifiBusy = false;
                    wifiInput.disabled = false;
                    wifiToggle.style.opacity = '1';
                });
            });
            
            // 频段切换开关事件（2.4G <-> 5G 联动自动切换最优信道）
            const modeToggle = document.getElementById('switch-mode');
            const modeInput = modeToggle.querySelector('input');
            let modeBusy = false;

            modeToggle.addEventListener('click', async function(e) {
                e.preventDefault();
                e.stopPropagation();
                if (modeBusy) return;

                const isCurrently5G = modeInput.checked;
                const targetMode = isCurrently5G ? "2.4G" : "5G";
                
                // 自动选择新频段的最优信道，不再保留旧频段信道
                let targetChannel = (targetMode === "5G") ? 44 : 6;
                if (window.radarData) {
                    if (targetMode === "5G" && window.radarData.best_channel_5g) {
                        targetChannel = window.radarData.best_channel_5g;
                    } else if (targetMode === "2.4G" && window.radarData.best_channel_24g) {
                        targetChannel = window.radarData.best_channel_24g;
                    }
                }

                if (!window.confirm(`切换 Wi-Fi 频段至 ${targetMode}（将自动匹配信道 ${targetChannel}）会断开当前连接并重启热点。确定继续？`)) {
                    return;
                }

                modeBusy = true;
                modeInput.disabled = true;
                modeToggle.style.opacity = '0.5';

                showModeStatus(`正在切换至 ${targetMode}（信道 ${targetChannel}）…`, 'pending');
                showToast(`正在切换至 ${targetMode} 频段（信道 ${targetChannel}）…`);

                try {
                    // 1. 同步通知固件 CGI 切换频段模式
                    await fetch('/cgi-bin/traffic.cgi', {
                        method: 'POST',
                        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                        body: `action=switch_wifi_mode&target_mode=${targetMode}`
                    }).catch(() => {});

                    // 2. 调用 /air-api/wifi/channel 直接写入 softap.ini 与 Connman 驱动硬件真切换
                    const resp = await fetch('/air-api/wifi/channel', {
                        method: 'POST',
                        headers: {'Content-Type': 'application/json'},
                        body: JSON.stringify({ channel: targetChannel, mode: targetMode })
                    });
                    const resJson = await resp.json().catch(() => ({}));
                    if (!resp.ok) throw new Error(resJson.error || '信道切换失败');

                    modeInput.checked = (targetMode === "5G");
                    const modeContainerSetting = document.getElementById('wifi-mode-setting');
                    if (modeContainerSetting) {
                        if (targetMode === "2.4G") {
                            modeContainerSetting.innerHTML = '<span class="mode-active-setting">2.4G</span><span class="mode-inactive-setting">/5G</span>';
                        } else {
                            modeContainerSetting.innerHTML = '<span class="mode-inactive-setting">2.4G</span><span class="mode-active-setting">/5G</span>';
                        }
                    }

                    // 动态更新信道下拉框选项并选中目标信道
                    const channelSelect = document.getElementById('channel-select');
                    if (channelSelect) {
                        delete channelSelect.dataset.initialized;
                        generateChannelSelect(targetMode, targetChannel);
                        channelSelect.value = targetChannel;
                        markChannelPending(targetChannel);
                    }

                    showModeStatus('已生效', 'success');
                    if (typeof showChannelStatus === 'function') {
                        showChannelStatus(`已同步切换至信道 ${targetChannel}`, 'success');
                    }
                    showToast(`频段已切换至 ${targetMode}，信道已自动切为 ${targetChannel}`);

                    // 重新探测雷达刷新界面
                    if (typeof window.fetchRadarData === 'function') {
                        setTimeout(() => window.fetchRadarData(true), 2500);
                    }
                    setTimeout(() => {
                        settingsInitialized = false;
                    }, 3000);
                } catch (error) {
                    const message = '切换失败: ' + error.message;
                    showModeStatus(message, 'error');
                    showToast(message, 'error');
                } finally {
                    modeBusy = false;
                    modeInput.disabled = false;
                    modeToggle.style.opacity = '1';
                }
            });
        }
        
        // 设置密码自动显示/隐藏功能
        function setupPasswordToggle() {
            // 设置区域的密码输入框：聚焦时显示密码，失焦时隐藏
            const passwordInput = document.getElementById('password-input');
            
            passwordInput.addEventListener('focus', function() {
                this.type = 'text';
            });
            
            passwordInput.addEventListener('blur', function() {
                this.type = 'password';
            });
        }
        
        // 加载WiFi数据
        function loadWifiData() {
            Promise.all([
                fetch('/cgi-bin/traffic.cgi?action=get_wifi').then(r => r.ok ? r.json() : {}).catch(() => ({})),
                fetch('/air-api/wifi/power').then(r => r.ok ? r.json() : {}).catch(() => ({}))
            ]).then(([data, pwr]) => {
                if (pwr && typeof pwr.enabled === 'boolean') {
                    data.wifi_enabled = pwr.enabled ? 'on' : 'off';
                }
                // 信道/频段以网关实测的射频真值为准：原厂 CGI 的 wifi_channel 与 connman 属性都是滞后值，
                // 切换信道后它们不会跟着变（实测一直返回旧值），拿它们渲染会让下拉框与实际射频不符。
                if (pwr && typeof pwr.channel === 'number' && pwr.channel > 0) {
                    data.wifi_channel = String(pwr.channel);
                }
                if (pwr && pwr.mode && pwr.mode !== 'unknown') {
                    data.wifi_mode = pwr.mode;
                }
                currentData = { ...currentData, ...data };
                    
                    // 更新WiFi状态显示（上半部分）
                    const wifiStatusTextSetting = document.getElementById('wifi-status-text-setting');
                    const wifiIcon = document.getElementById('wifi-icon');
                    const wifiToggle = document.getElementById('toggle-wifi').querySelector('input');
                    
                    if (data.wifi_enabled === "on") {

                        wifiStatusTextSetting.textContent = "已启用";
                        if (wifiIcon) wifiIcon.className = "wifi-icon";
                        wifiToggle.checked = true;
                    } else {

                        wifiStatusTextSetting.textContent = "已禁用";
                        if (wifiIcon) wifiIcon.className = "wifi-icon off";
                        wifiToggle.checked = false;
                    }
                    
                    // 更新频段模式显示
                    const modeContainerSetting = document.getElementById('wifi-mode-setting');
                    const modeToggle = document.getElementById('switch-mode').querySelector('input');
                    
                    if (data.wifi_mode === "2.4G") {

                        modeContainerSetting.innerHTML = '<span class="mode-active-setting">2.4G</span><span class="mode-inactive-setting">/5G</span>';
                        modeToggle.checked = false;
                    } else if (data.wifi_mode === "5G") {

                        modeContainerSetting.innerHTML = '<span class="mode-inactive-setting">2.4G</span><span class="mode-active-setting">/5G</span>';
                        modeToggle.checked = true;
                    } else {

                        modeContainerSetting.innerHTML = '<span class="mode-inactive-setting">2.4G</span><span class="mode-inactive-setting">/5G</span>';
                    }
                    
                    // 处理设置区域（下半部分）
                    // 只在首次加载或用户没有正在编辑时才更新设置区域
                    if (!settingsInitialized || !isUserEditingSettings()) {
                        updateSettingsArea(data);
                        if (!settingsInitialized) {
                            settingsInitialized = true; // 设置区域初始化完成
                        }
                    }
                    
                    // 更新实时状态显示
                    document.getElementById('settings-error').hidden=true;
                })
                .catch(error => {
                    console.error('加载WiFi数据失败:', error);
                    document.getElementById('settings-error').hidden=false;
                });
        }
        
        // 检查用户是否正在编辑设置区域
        function isUserEditingSettings() {
            const ssidInput = document.getElementById('ssid-input');
            const passwordInput = document.getElementById('password-input');
            
            // 如果任何输入框处于聚焦状态，说明用户正在编辑
            return ssidInput === document.activeElement || 
                   passwordInput === document.activeElement;
        }
        
        // 更新设置区域内容
        function updateSettingsArea(data) {
            // 更新SSID输入框
            const ssidInput = document.getElementById('ssid-input');
            if (data.wifi_ssid && ssidInput.value !== data.wifi_ssid) {
                ssidInput.value = data.wifi_ssid;
            }
            
            // 更新密码输入框（仅在为空时更新，避免覆盖用户输入）
            const passwordInput = document.getElementById('password-input');
            if ((!passwordInput.value || passwordInput.value === '') && 
                data.wifi_key && data.wifi_key !== 'unknown') {
                passwordInput.value = data.wifi_key;
            }
            
            // 更新信道选择器
            generateChannelSelect(data.wifi_mode, data.wifi_channel);
        }
        
        // 生成信道选择器选项，并让选中值与射频实际信道保持同步
        function generateChannelSelect(currentMode, currentChannel) {
            const channelSelect = document.getElementById('channel-select');
            if (!channelSelect) return;
            const targetChannel = parseInt(currentChannel, 10) || 0;
            const mode = currentMode === "2.4G" ? "2.4G" : "5G";

            // 频段变化或首次加载时重建选项列表
            if (channelSelect.dataset.currentMode !== mode || !channelSelect.dataset.initialized) {
                channelSelect.innerHTML = ''; // 清空现有选项
                const channelsToShow = mode === "2.4G" ? channels24G : channels5G;

                channelsToShow.forEach(channel => {
                    const option = document.createElement('option');
                    option.value = channel;
                    option.textContent = channel;
                    if (targetChannel === channel) {
                        option.selected = true;
                    }
                    channelSelect.appendChild(option);
                });

                channelSelect.dataset.currentMode = mode;
                channelSelect.dataset.initialized = true;
            }

            // 关键修复：原先只在重建选项时才更新选中值，导致切换信道后下拉框一直显示旧信道。
            if (channelSelect === document.activeElement) return; // 用户正在操作下拉框，不打扰

            const pendingUntil = parseInt(channelSelect.dataset.pendingUntil || '0', 10);
            const pendingChannel = parseInt(channelSelect.dataset.pendingChannel || '0', 10);
            if (pendingUntil > Date.now()) {
                // 刚提交过切换：等射频重载完成（最多 20 秒），或真实信道已经追上目标值
                if (targetChannel !== pendingChannel) return;
            } else if (pendingUntil > 0) {
                delete channelSelect.dataset.pendingUntil;
                delete channelSelect.dataset.pendingChannel;
            }

            if (targetChannel > 0 && parseInt(channelSelect.value, 10) !== targetChannel) {
                const hasTarget = Array.prototype.some.call(channelSelect.options, o => parseInt(o.value, 10) === targetChannel);
                if (hasTarget) channelSelect.value = String(targetChannel);
            }
        }

        // 提交切换后的保护期：热点重载期间不让 2 秒轮询把下拉框拉回旧信道
        function markChannelPending(channel) {
            const channelSelect = document.getElementById('channel-select');
            if (!channelSelect || !channel) return;
            channelSelect.dataset.pendingChannel = String(channel);
            channelSelect.dataset.pendingUntil = String(Date.now() + 20000);
            if (parseInt(channelSelect.value, 10) !== parseInt(channel, 10)) {
                const hasTarget = Array.prototype.some.call(channelSelect.options, o => parseInt(o.value, 10) === parseInt(channel, 10));
                if (hasTarget) channelSelect.value = String(channel);
            }
        }
        window.markChannelPending = markChannelPending;
        
        // 应用信道设置
        document.getElementById('apply-channel').addEventListener('click', function() {
            const channelSelect = document.getElementById('channel-select');
            const selectedChannel = parseInt(channelSelect.value, 10);
            
            if (!selectedChannel) {
                showToast('请选择信道', 'error');
                return;
            }
            
            if (!window.confirm(`切换 Wi-Fi 信道至 ${selectedChannel} 会短暂断开当前连接。继续？`)) {
                return;
            }
            
            const mode = selectedChannel <= 14 ? '2.4G' : '5G';
            markChannelPending(selectedChannel);
            showChannelStatus('正在切换信道，断线后请重新连接', 'pending');
            showToast(`正在切换至信道 ${selectedChannel}，热点重启中…`);
            const btn = this;
            btn.disabled = true;
            
            fetch('/air-api/wifi/channel', {
                method: 'POST',
                headers: {'Content-Type': 'application/json'},
                body: JSON.stringify({ channel: selectedChannel, mode: mode })
            })
            .then(response => {
                if (!response.ok) throw new Error('信道设置失败');
                return response.json();
            })
            .then(data => {
                showChannelStatus('已生效', 'success');
                showToast(data.message || '信道设置成功，正在重连…');
            })
            .catch(error => {
                const message = '信道设置失败: ' + error.message;
                showChannelStatus(message, 'error');
                showToast(message, 'error');
            })
            .finally(() => {
                btn.disabled = false;
            });
        });
        
        // 应用WiFi设置
        document.getElementById('apply-settings').addEventListener('click', function() {
            const ssid = document.getElementById('ssid-input').value.trim();
            const password = document.getElementById('password-input').value;
            
            if (!ssid) {
                showToast('请输入网络名称', 'error');
                return;
            }
            
            if (password && password.length < 8) {
                showToast('密码长度至少8位', 'error');
                return;
            }
            
            fetch('/cgi-bin/traffic.cgi', {
                method: 'POST',
                headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                body: `action=update_wifi_settings&ssid=${encodeURIComponent(ssid)}&key=${encodeURIComponent(password)}`
            })
            .then(response => {
                if (!response.ok) throw new Error('设置失败');
                return response.json();
            })
            .then(data => {
                showToast(data.message || 'WiFi设置已更新');
                // 不需要手动刷新，实时更新会自动处理
            })
            .catch(error => {
                const message = '设置失败: ' + error.message;
                showToast(message, 'error');
            });
        });
        
        // 显示提示消息
        function showToast(text, type = '') {
            const toast = document.getElementById('wifi-toast');
            const toastText = document.getElementById('wifi-toast-text');
            
            toastText.textContent = text;
            toast.className = type === 'error' ? 'toast error' : 'toast';
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
