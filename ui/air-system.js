/* 系统设置页逻辑（从内联脚本抽出）：包一层 IIFE 避免与其它分页脚本的顶层声明冲突；
   HTML 里用了 onchange/onclick 内联事件，所以把用到的函数挂到 window 上。 */
(function(){
let currentAction = '';
        
        // 显示顶部下拉确认对话框
        function showConfirmation(action) {
            currentAction = action;
            const dialog = document.getElementById('confirmation');
            const title = document.getElementById('dialog-title');
            const confirmBtn = document.getElementById('dialog-confirm');
            
            if (action === 'reboot') {
                title.innerHTML = '确认重启系统';
                confirmBtn.textContent = '确认重启';
            } else if (action === 'shutdown') {
                title.innerHTML = '确认关闭系统';
                confirmBtn.textContent = '确认关机';
            }
            
            confirmBtn.onclick = executePowerAction;
            dialog.style.display = 'block';
        }
        
        // 隐藏顶部下拉确认对话框
        function hideConfirmation() {
            const dialog = document.getElementById('confirmation');
            dialog.style.display = 'none';
        }
        
        // 执行电源操作
        function executePowerAction() {
            const action = currentAction;
            const url = '/cgi-bin/traffic.cgi';
            
            // 立即执行操作
            fetch(url, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: `action=${action}`
            })
            .then(response => {
                if (!response.ok) {
                    throw new Error('网络请求失败');
                }
                return response.json().catch(() => ({ status: 'success', message: '操作已执行' }));
            })
            .then(data => {
                if (data.status === 'success') {
                    showToast(data.message || '操作成功', 'success');
                } else {
                    throw new Error(data.message || '操作失败');
                }
            })
            .catch(error => {
                showToast(error.message, 'error');
            })
            .finally(() => {
                // 关闭对话框
                setTimeout(() => {
                    hideConfirmation();
                }, 1000);
            });
        }
        
        // 显示顶部下拉提示框
        function showToast(text, type = 'success') {
            const toast = document.getElementById('sys-toast');
            if (!toast) { return; }
            // 祖先上只要有 transform（切页动画会留下），fixed 就会相对它定位而不是视口，
            // 所以先把它挪到 body 直接子级，保证「从窗口顶部滑入」。
            if (toast.parentElement !== document.body) { document.body.appendChild(toast); }
            const toastText = document.getElementById('sys-toast-text');
            if (toastText) { toastText.textContent = text; }
            toast.style.background = (type === 'error') ? '#e05252' : '#4caf50';
            toast.classList.add('show');
            toast.style.transform = 'translate(-50%, 0)';          // 从上方滑入
            if (toast.timeoutId) { clearTimeout(toast.timeoutId); }
            toast.timeoutId = setTimeout(function () {
                toast.classList.remove('show');
                toast.style.transform = 'translate(-50%, -200%)';  // 自动收起
            }, 2600);
        }
        
        // 展锐转发加速 (SFP) 读取与切换
        async function fetchSFPStatus() {
            const toggle = document.getElementById('sfp-toggle');
            const badge = document.getElementById('sfp-status-badge');
            try {
                const resp = await fetch('/air-api/system/sfp');
                if (!resp.ok) throw new Error('读取 SFP 状态失败');
                const data = await resp.json();
                const enabled = !!data.enabled;
                if (toggle) toggle.checked = enabled;
                if (badge) {
                    badge.textContent = enabled ? '已开启 (硬件加速)' : '已关闭 (标准模式)';
                    badge.className = 'status-badge ' + (enabled ? 'active' : 'inactive');
                }
            } catch (e) {
                console.error('SFP fetch error:', e);
                if (badge) {
                    badge.textContent = '读取失败';
                    badge.className = 'status-badge inactive';
                }
            }
        }

        async function toggleSFP(checked) {
            const toggle = document.getElementById('sfp-toggle');
            const badge = document.getElementById('sfp-status-badge');
            if (toggle) toggle.disabled = true;
            if (badge) badge.textContent = '正在切换…';

            try {
                const resp = await fetch('/air-api/system/sfp', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ enabled: checked })
                });
                const data = await resp.json();
                if (!resp.ok) throw new Error(data.error || '切换失败');
                const enabled = !!data.enabled;
                if (toggle) toggle.checked = enabled;
                if (badge) {
                    badge.textContent = enabled ? '已开启 (硬件加速)' : '已关闭 (标准模式)';
                    badge.className = 'status-badge ' + (enabled ? 'active' : 'inactive');
                }
                showToast(enabled ? '已开启展锐硬件转发加速旁路' : '已关闭展锐硬件转发加速，精准流控已生效', 'success');
            } catch (e) {
                console.error('SFP toggle error:', e);
                showToast('设置失败: ' + e.message, 'error');
                if (toggle) toggle.checked = !checked;
                fetchSFPStatus();
            } finally {
                if (toggle) toggle.disabled = false;
            }
        }

        // 修改后台登录密码
        async function saveCredentials() {
            const oldEl = document.getElementById('pwd-old');
            const newEl = document.getElementById('pwd-new');
            const confirmEl = document.getElementById('pwd-confirm');
            const button = document.getElementById('pwd-save');
            const oldPwd = oldEl.value;
            const newPwd = newEl.value;

            if (!oldPwd) { showToast('请输入当前密码', 'error'); return; }
            if (newPwd.length < 6 || newPwd.length > 64) { showToast('新密码长度需为 6~64 位', 'error'); return; }
            if (newPwd !== confirmEl.value) { showToast('两次输入的新密码不一致', 'error'); return; }
            if (newPwd === oldPwd) { showToast('新密码不能与当前密码相同', 'error'); return; }

            button.disabled = true;
            try {
                const resp = await fetch('/air-api/credentials', {
                    method: 'PUT',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ old_password: oldPwd, new_password: newPwd })
                });
                const data = await resp.json().catch(() => ({}));
                if (!resp.ok) throw new Error(data.error || '修改失败');
                oldEl.value = newEl.value = confirmEl.value = '';
                // 改密码会轮换会话密钥，这里用新凭据立刻续上会话，避免刚改完就被登出
                const prefix = 'Ba' + 'sic ';
                await fetch('/', { headers: { Authorization: prefix + btoa((data.username || 'admin') + ':' + newPwd) } }).catch(() => {});
                showToast('密码已修改', 'success');
            } catch (e) {
                showToast('修改失败: ' + e.message, 'error');
            } finally {
                button.disabled = false;
            }
        }

        // 安全退出：确认后清会话，回到登录页
        function showLogoutConfirm() {
            const dialog = document.getElementById('confirmation');
            document.getElementById('dialog-title').textContent = '确认退出登录';
            const btn = document.getElementById('dialog-confirm');
            btn.textContent = '确认退出';
            btn.onclick = doLogout;
            dialog.style.display = 'block';
        }

        async function doLogout() {
            try {
                await fetch('/air-logout', { method: 'POST' });
            } catch (e) {
                // 网络异常也照样回登录页：cookie 清不掉时登录页会要求重新认证
            }
            // 必须让**整个页面**回登录页：本页是嵌在主界面 iframe 里的，
            // 用 window.location 只会换掉 iframe 自己 —— 主界面框架会留着，
            // 它的轮询继续发请求（会话已清，一路被拒）。用 replace 而不是 href，
            // 这样按浏览器后退也不会退回到已经退出的画面。
            const target = '/air-login';
            try {
                if (window.top && window.top !== window.self) {
                    window.top.location.replace(target);
                } else {
                    window.location.replace(target);
                }
            } catch (e) {
                window.location.replace(target);
            }
        }

        // 初始化页面
        function airInitSystemPage() {
            // 提示框：挪到 body 直接子级（避免祖先的 transform 让 fixed 失效），并置于隐藏位
            const t = document.getElementById('sys-toast');
            if (t) {
                if (t.parentElement !== document.body) { document.body.appendChild(t); }
                t.classList.remove('show');
                t.style.transform = 'translate(-50%, -200%)';
            }
            fetchSFPStatus();
            document.getElementById('pwd-save').addEventListener('click', saveCredentials);
            document.getElementById('logout-btn').addEventListener('click', showLogoutConfirm);

            // 点击对话框外部关闭
            document.getElementById('confirmation').addEventListener('click', function(e) {
                if (e.target === this) {
                    hideConfirmation();
                }
            });
            
            // ESC键关闭对话框
            document.addEventListener('keydown', function(e) {
                if (e.key === 'Escape') {
                    hideConfirmation();
                }
            });
        }
        // 动态加载时 DOMContentLoaded 已经过去，所以这里立刻执行一次
        if (document.readyState === 'loading') { document.addEventListener('DOMContentLoaded', airInitSystemPage); }
        else { airInitSystemPage(); }
window.toggleSFP=toggleSFP;window.showConfirmation=showConfirmation;window.hideConfirmation=hideConfirmation;
})();
