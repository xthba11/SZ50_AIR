package main

import (
	"crypto/sha256"
	"crypto/subtle"
	"html"
	"io"
	"net/http"
	"strings"
	"time"
)

// 后台自建登录页：取代浏览器原生的 Basic 认证弹框。
//
// 原流程是「401 + WWW-Authenticate: Basic」→ 浏览器弹出自己的登录框，而那个框的
// 外观与文案完全由浏览器决定，密码输错时只能再弹一次、给不出任何提示。
// 现在改成：未认证的浏览器访问跳到本页，页面里直接提示「用户名或密码错误」。
//
// 兼容性上做了三层保留：
//  1. Basic 认证路径不动 —— API / curl / 脚本客户端照旧用 401 挑战；
//  2. 浏览器里缓存着的旧 Basic 凭据仍然被接受（成功的分支没变），
//     所以老用户不会因为这次改动被挡在门外；
//  3. 会话 cookie 机制不变（8 小时、HMAC 签名、跨端口共享）。

const loginPath = "/air-login"
const logoutPath = "/air-logout"

// noBasicCookieName 是「主动退出过」的标记，用来压住 Basic 兼容分支。
//
// 为什么要它：会话 cookie 被清掉后，浏览器里缓存的 Basic 凭据仍会让它自动通过认证
// （凭据是浏览器存的状态，服务端删不掉）。没有这个标记，用户点「退出登录」后刷新一下
// 就会被静默登录回去 —— 看着像退出没生效。带上它以后，这台浏览器在标记有效期内
// 只认登录页签发的新会话，不再接受缓存的 Basic 凭据；其它设备/脚本客户端没有这个
// cookie，完全不受影响。
const noBasicCookieName = "SZ50_NO_BASIC"

const loginPageHTML = `<!DOCTYPE html>
<html lang="zh-CN">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>登录 · SZ50 后台</title>
<style>
    :root {
        --primary: #2563eb;
        --primary-hover: #1d4ed8;
        --border-radius: 10px;
        --transition: all 0.25s ease;
    }

    * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
        font-family: 'Segoe UI', 'Microsoft YaHei', sans-serif;
    }

    body {
        min-height: 100vh;
        display: flex;
        align-items: center;
        justify-content: center;
        background: #eef2f8;
        padding: 20px;
        overflow-x: hidden;
    }

    /* ---------- 背景：跟随鼠标的粒子星座（纯前端渲染，不占设备资源） ---------- */
    #bg {
        position: fixed;
        inset: 0;
        z-index: 0;
        display: block;
    }

    /* 四周很淡的冷色晕染，避免纯色平面显得死 */
    .wash {
        position: fixed;
        inset: 0;
        z-index: 1;
        pointer-events: none;
        background:
            radial-gradient(60% 50% at 12% 8%, rgba(120, 160, 255, .14) 0%, rgba(120, 160, 255, 0) 70%),
            radial-gradient(55% 45% at 92% 88%, rgba(180, 140, 255, .12) 0%, rgba(180, 140, 255, 0) 70%);
    }

    /* 卡片浮在动态背景之上 */
    .login-card {
        position: relative;
        z-index: 2;
        width: 100%;
        max-width: 360px;
        background: linear-gradient(160deg, rgba(255, 255, 255, .82), rgba(255, 255, 255, .6));
        backdrop-filter: blur(24px) saturate(185%);
        -webkit-backdrop-filter: blur(24px) saturate(185%);
        border: 1px solid rgba(255, 255, 255, .9);
        border-radius: 18px;
        padding: 32px 28px 28px;
        box-shadow: 0 20px 50px rgba(35, 48, 74, .14), inset 0 1px 0 rgba(255, 255, 255, .95), inset 0 0 0 1px rgba(255, 255, 255, .3);
    }

    /* 玻璃边缘光：渐变描边，只画边不盖内容 */
    .login-card::before {
        content: "";
        position: absolute;
        inset: 0;
        border-radius: inherit;
        padding: 1px;
        background: linear-gradient(140deg, rgba(255, 255, 255, .98), rgba(255, 255, 255, .12) 42%, rgba(255, 255, 255, .78));
        -webkit-mask: linear-gradient(#000 0 0) content-box, linear-gradient(#000 0 0);
        -webkit-mask-composite: xor;
        mask: linear-gradient(#000 0 0) content-box, linear-gradient(#000 0 0);
        mask-composite: exclude;
        pointer-events: none;
    }

    /* 进场：卡片浮起 */
    .login-card { animation: airLoginIn .6s cubic-bezier(.22, 1, .36, 1) both; }
    @keyframes airLoginIn {
        from { opacity: 0; transform: translateY(18px) scale(.982); }
        to { opacity: 1; transform: none; }
    }

    /* 离场：登录成功后的过渡（卡片上浮虚化 + 背景粒子加速 + 一层柔光纱） */
    body.leaving .login-card {
        transition: transform .6s cubic-bezier(.4, 0, .2, 1), opacity .55s ease, filter .55s ease;
        transform: translateY(-16px) scale(1.035);
        opacity: 0;
        filter: blur(9px);
    }
    body.leaving .login-head { transition: opacity .35s ease; opacity: 0; }
    body.leaving #bg { transition: opacity .6s ease; opacity: .4; }
    body.leaving .wash { transition: opacity .6s ease; opacity: 0; }
    body.leaving::after {
        content: "";
        position: fixed;
        inset: 0;
        z-index: 1;
        pointer-events: none;
        background: radial-gradient(60% 50% at 50% 50%, #ffffff 0%, #eef2f8 100%);
        opacity: 0;
        animation: airLeaveVeil .62s cubic-bezier(.4, 0, .2, 1) forwards;
    }
    @keyframes airLeaveVeil { to { opacity: .82; } }
    @media (prefers-reduced-motion: reduce) {
        .login-card { animation: none; }
        body.leaving .login-card { transform: none; filter: none; }
    }

    .login-head {
        text-align: center;
        margin-bottom: 24px;
    }

    .login-head .logo {
        width: 46px;
        height: 46px;
        margin: 0 auto 14px;
        display: flex;
        align-items: center;
        justify-content: center;
        background: #eff6ff;
        border-radius: 12px;
    }

    .login-head .logo svg {
        width: 24px;
        height: 24px;
        stroke: var(--primary);
        stroke-width: 1.8;
        fill: none;
        stroke-linecap: round;
        stroke-linejoin: round;
    }

    .login-head h1 {
        font-size: 19px;
        font-weight: 600;
        color: #1e293b;
        margin-bottom: 6px;
    }

    .login-head p {
        font-size: 13px;
        color: #64748b;
    }

    .login-error {
        display: flex;
        align-items: center;
        gap: 8px;
        background: #fef2f2;
        border: 1px solid #fecaca;
        color: #b91c1c;
        font-size: 13px;
        line-height: 1.4;
        padding: 10px 12px;
        border-radius: 8px;
        margin-bottom: 18px;
    }

    .login-error svg {
        width: 15px;
        height: 15px;
        flex-shrink: 0;
        stroke: #dc2626;
        stroke-width: 2;
        fill: none;
        stroke-linecap: round;
    }

    .field {
        margin-bottom: 16px;
    }

    .field label {
        display: block;
        font-size: 13px;
        font-weight: 500;
        color: #475569;
        margin-bottom: 7px;
    }

    .field input {
        width: 100%;
        padding: 12px 14px;
        border: 1px solid #cbd5e1;
        border-radius: 8px;
        font-size: 15px;
        color: #1e293b;
        background: #f8fafc;
        transition: var(--transition);
    }

    .field input:focus {
        outline: none;
        border-color: var(--primary);
        background: #ffffff;
        box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.12);
    }

    .login-submit {
        width: 100%;
        padding: 13px;
        margin-top: 4px;
        border: none;
        border-radius: 8px;
        background: var(--primary);
        color: #ffffff;
        font-size: 16px;
        font-weight: 600;
        cursor: pointer;
        transition: var(--transition);
    }

    .login-submit:hover {
        background: var(--primary-hover);
    }

    .login-submit:active {
        transform: scale(0.99);
    }
</style>
</head>
<body>
    <canvas id="bg"></canvas>
    <div class="wash"></div>
    <form class="login-card" method="post" action="/air-login" autocomplete="on">
        <div class="login-head">
            <div class="logo">
                <svg viewBox="0 0 24 24" aria-hidden="true">
                    <rect x="4" y="10.5" width="16" height="10" rx="2"></rect>
                    <path d="M8 10.5V7.5a4 4 0 0 1 8 0v3"></path>
                </svg>
            </div>
            <h1>SZ50 后台</h1>
            <p>请输入账号密码登录</p>
        </div>
        {{ERROR}}
        <input type="hidden" name="next" value="{{NEXT}}">
        <div class="field">
            <label for="username">用户名</label>
            <input id="username" name="username" type="text" value="{{USERNAME}}" autocomplete="username" autofocus required>
        </div>
        <div class="field">
            <label for="password">密码</label>
            <input id="password" name="password" type="password" autocomplete="current-password" required>
        </div>
        <button class="login-submit" type="submit">登录</button>
    </form>
    <script>
        // 密码错一次后用户名会保留，此时焦点直接落在密码框，省得再点一次
        (function () {
            var u = document.getElementById('username');
            var p = document.getElementById('password');
            if (u && p && u.value) { p.focus(); p.select(); }
        })();
    </script>
    <script>
        /* 登录提交改走 fetch：只有这样才能控制"跳转时机" ——
           成功时先播完离场动画再进后台（后台那边有对应的入场动画），失败则交回原生提交。 */
        (function () {
            var form = document.querySelector('form.login-card');
            if (!form || !window.fetch || !window.FormData) { return; }
            form.addEventListener('submit', function (e) {
                e.preventDefault();
                if (document.body.classList.contains('leaving')) { return; }
                fetch('/air-login', {
                    method: 'POST',
                    body: new URLSearchParams(new FormData(form)),
                    credentials: 'same-origin'
                }).then(function (r) {
                    if (r.redirected) {
                        document.body.classList.add('leaving');
                        if (window.__airBgBoost) { window.__airBgBoost(3.2, 1100); }
                        setTimeout(function () { window.location.href = r.url; }, 640);
                    } else {
                        form.submit();   // 密码错误等：交回原生提交，浏览器渲染返回的登录页
                    }
                })['catch'](function () { form.submit(); });
            });
        })();
    </script>
    <script src="/air-bg.js"></script>
</body>
</html>
`

const loginErrorHTML = `<div class="login-error"><svg viewBox="0 0 24 24" aria-hidden="true">` +
	`<circle cx="12" cy="12" r="9"></circle><path d="M12 8v5"></path><path d="M12 16h.01"></path></svg>` +
	`%s</div>`

// wantsHTML 判断是不是「浏览器在导航」：导航与 iframe 一定带 text/html，
// 而 fetch/XHR 默认是 */*、curl 也是 */*，WebSocket 握手则完全没有这个头。
// 用它可以做到「浏览器走登录页、API 走 401 挑战」两不打扰。
func wantsHTML(r *http.Request) bool {
	return strings.Contains(r.Header.Get("Accept"), "text/html")
}

// sanitizeNext 只允许站内相对路径，防止开放重定向。
func sanitizeNext(next string) string {
	if next == "" || !strings.HasPrefix(next, "/") ||
		strings.HasPrefix(next, "//") || strings.HasPrefix(next, "\\") ||
		strings.Contains(next, ":") || strings.Contains(next, "\\") {
		return "/"
	}
	if next == loginPath || strings.HasPrefix(next, loginPath+"?") {
		return "/"
	}
	return next
}

// clearCookie 让浏览器立即丢弃某个 cookie
func clearCookie(w http.ResponseWriter, name string) {
	http.SetCookie(w, &http.Cookie{
		Name:     name,
		Value:    "",
		Path:     "/",
		HttpOnly: true,
		SameSite: http.SameSiteStrictMode,
		MaxAge:   -1,
		Expires:  time.Unix(0, 0),
	})
}

// writeLoginPage 渲染登录页；username 回填（密码错一次后不必重输用户名，密码不回填）
func writeLoginPage(w http.ResponseWriter, next, username, errMsg string) {
	page := loginPageHTML
	if errMsg != "" {
		page = strings.Replace(page, "{{ERROR}}", sprintfHTML(loginErrorHTML, html.EscapeString(errMsg)), 1)
	} else {
		page = strings.Replace(page, "{{ERROR}}", "", 1)
	}
	page = strings.Replace(page, "{{NEXT}}", html.EscapeString(next), 1)
	page = strings.Replace(page, "{{USERNAME}}", html.EscapeString(username), 1)
	w.Header().Set("Content-Type", "text/html; charset=utf-8")
	w.WriteHeader(http.StatusOK)
	_, _ = io.WriteString(w, page)
}

// loginHandler 处理 GET（显示表单）与 POST（校验并签发会话 cookie）
func loginHandler(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodGet && r.Method != http.MethodPost {
		w.Header().Set("Allow", "GET, POST")
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}

	next := sanitizeNext(r.URL.Query().Get("next"))

	if r.Method == http.MethodPost {
		r.Body = http.MaxBytesReader(w, r.Body, 4096)
		if err := r.ParseForm(); err != nil {
			writeLoginPage(w, next, "", "提交内容过大或格式错误")
			return
		}
		username := r.PostFormValue("username")
		if fromForm := sanitizeNext(r.PostFormValue("next")); fromForm != "/" {
			next = fromForm
		}

		gotU := sha256.Sum256([]byte(username))
		gotP := sha256.Sum256([]byte(r.PostFormValue("password")))
		wantU, wantP := credHashes()
		match := subtle.ConstantTimeCompare(wantU[:], gotU[:]) & subtle.ConstantTimeCompare(wantP[:], gotP[:])

		if match == 1 {
			expires := time.Now().Add(sessionDuration)
			http.SetCookie(w, &http.Cookie{
				Name:     sessionName,
				Value:    sessionToken(expires),
				Path:     "/",
				HttpOnly: true,
				SameSite: http.SameSiteStrictMode,
				Expires:  expires,
				MaxAge:   int(sessionDuration / time.Second),
			})
			// 重新登录成功，撤掉「已退出」标记，Basic 兼容分支对这台浏览器恢复
			clearCookie(w, noBasicCookieName)
			http.Redirect(w, r, next, http.StatusFound)
			return
		}

		time.Sleep(150 * time.Millisecond) // 与认证失败同一条防爆破延迟
		writeLoginPage(w, next, username, "用户名或密码错误")
		return
	}

	// 已登录还来访问登录页：直接回首页，避免重复输入
	if validSession(r) {
		http.Redirect(w, r, "/", http.StatusFound)
		return
	}
	writeLoginPage(w, next, "", "")
}

// logoutHandler 处理「安全退出」：清掉会话 cookie，并标记这台浏览器在有效期内
// 不再吃缓存的 Basic 凭据（否则浏览器会把它自动登录回来）。
//
// 语义范围：只退出**当前这个浏览器**，同一账号在手机/其它浏览器上的会话不受影响。
// 会话是 HMAC 签名的无状态令牌并广播到所有端口，若需要「一次退出所有设备」，
// 得再轮换会话密钥（rotateSessionKey），那会把所有在线会话一并踢掉。
func logoutHandler(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		w.Header().Set("Allow", "POST")
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}
	clearCookie(w, sessionName)
	http.SetCookie(w, &http.Cookie{
		Name:     noBasicCookieName,
		Value:    "1",
		Path:     "/",
		HttpOnly: true,
		SameSite: http.SameSiteStrictMode,
		MaxAge:   int(sessionDuration / time.Second),
	})
	w.Header().Set("Cache-Control", "no-store")
	w.WriteHeader(http.StatusNoContent)
}

// sprintfHTML 只做一次 %s 替换（避免引入 fmt 的格式化歧义）
func sprintfHTML(format, arg string) string {
	return strings.Replace(format, "%s", arg, 1)
}
