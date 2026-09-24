var airFrameLru=[];var airPageJs={devices:"air-devices.js?v=2.21",proxyweb:"air-proxy.js?v=1.2",chargeweb:"air-charge.js?v=2.16",clashui:"air-system.js?v=1.5",clashweb:"air-page-sim.js?v=1.1",usbmodeweb:"air-page-wifi.js?v=1.2",tfcweb:"air-page-liuliang.js?v=1.2"};
const airSections={monitor:['状态监测','资源状态与温度历史'],devices:['连接设备','在线状态、IP 与设备备注'],dashboard:['网络概览','连接状态与设备信息'],proxyweb:['代理设置','透明代理与节点管理'],chargeweb:['电池设置','智能充电规则与电池健康'],clashweb:['网络与 SIM','管理网络模式与 SIM 卡槽'],usbmodeweb:['Wi-Fi 设置','管理无线连接与热点配置'],tfcweb:['流量管理','查看流量使用与统计配置'],atweb:['AT 控制台','设备参数与 AT 调试工具'],terminalweb:['网页终端','在浏览器中使用设备终端'],atcommand:['快捷调试','输入 AT 命令并查看设备响应'],clashui:['系统设置','设备运行与系统管理']};
function toggleSidebar(){const open=document.getElementById('sidebar').classList.toggle('active');document.getElementById('overlay').classList.toggle('active',open);document.getElementById('menu-toggle').setAttribute('aria-expanded',String(open))}
function showSection(name){if(!airSections[name])name='dashboard';Object.keys(airSections).forEach(key=>{const sec=document.getElementById(key+'-section');sec.hidden=key!==name;if(key===name){sec.classList.remove('section-enter');void sec.offsetWidth;sec.classList.add('section-enter');}});const section=document.getElementById(name+'-section');const frame=section.querySelector('iframe[data-src]');if(frame&&frame.dataset.loadedVersion!=='2.14'){const source=new URL(frame.dataset.src,window.location.href);if(frame.dataset.target.startsWith('/')||frame.dataset.target==='8080')source.searchParams.set('ui','2.14');frame.src=source.href;frame.dataset.loadedVersion='2.14';}if(frame){const li=airFrameLru.indexOf(frame);if(li>=0)airFrameLru.splice(li,1);airFrameLru.push(frame);while(airFrameLru.length>3){const oldest=airFrameLru[0];if(oldest===frame){break;}airFrameLru.shift();if(!oldest.closest('.section-hidden')&&oldest.offsetParent===null){try{oldest.removeAttribute('src');oldest.dataset.loadedVersion='';}catch(e){}}}}document.querySelectorAll('.nav-menu a').forEach(link=>{const selected=link.dataset.section===name;link.classList.toggle('active',selected);if(selected)link.setAttribute('aria-current','page');else link.removeAttribute('aria-current')});if(window['airStart_'+name]){try{window['airStart_'+name]();}catch(e){}}var _pj=airPageJs[name];if(_pj&&!window['__airPj_'+name]){window['__airPj_'+name]=1;(function(src){setTimeout(function(){var sc=document.createElement("script");sc.src="/"+src;document.body.appendChild(sc);},180);})(_pj);}const loc=document.getElementById('page-location');loc.textContent=airSections[name][0];loc.classList.remove('location-enter');void loc.offsetWidth;loc.classList.add('location-enter');document.title=airSections[name][0]+' · SZ50 AIR';try{localStorage.setItem('currentSection',name)}catch(e){}document.getElementById('sidebar').classList.remove('active');document.getElementById('overlay').classList.remove('active');document.getElementById('menu-toggle').setAttribute('aria-expanded','false');window.scrollTo({top:0,behavior:"smooth"});setTimeout(function(){try{window.dispatchEvent(new Event("resize"));}catch(e){}},140);setTimeout(function(){try{window.dispatchEvent(new Event("resize"));}catch(e){}},600);}
let airUpdatedAt=0;
window.airDataUpdated=function(){airUpdatedAt=Date.now();const status=document.getElementById('data-freshness');status.textContent='已更新';status.className='freshness is-current'};
window.airDataFailed=function(){const status=document.getElementById('data-freshness');status.textContent='连接暂不可用';status.className='freshness is-stale'};
document.addEventListener('DOMContentLoaded',()=>{document.querySelectorAll('[data-section]').forEach(button=>button.addEventListener('click',event=>{event.preventDefault();showSection(button.dataset.section)}));document.getElementById('menu-toggle').addEventListener('click',toggleSidebar);document.getElementById('overlay').addEventListener('click',toggleSidebar);document.getElementById('refresh-page').addEventListener('click',()=>location.reload());document.getElementById('reveal-password').addEventListener('click',function(){const shown=document.getElementById('wifiPassword').classList.toggle('revealed');this.textContent=shown?'隐藏':'显示';this.setAttribute('aria-pressed',String(shown))});let saved='dashboard';try{saved=localStorage.getItem('currentSection')||saved}catch(e){}const requested=new URLSearchParams(location.search).get('page');if(requested&&airSections[requested])saved=requested;showSection(saved);document.addEventListener('keydown',event=>{if(event.key==='Escape'&&document.getElementById('sidebar').classList.contains('active'))toggleSidebar()});setInterval(()=>{if(airUpdatedAt&&Date.now()-airUpdatedAt>15000){const status=document.getElementById('data-freshness');status.textContent='等待响应';status.className='freshness is-stale'}},5000)});

window.addEventListener('message',event=>{
 const data=event.data;
 if(!data||data.type!=='air-page-height'||!Number.isFinite(data.height)||data.height<0||data.height>30000)return;
 for(const frame of document.querySelectorAll('iframe[data-target]')){
  if(frame.contentWindow!==event.source||!frame.src||new URL(frame.src).origin!==event.origin)continue;
  frame.dataset.autoHeight='true';frame.style.height=Math.max(100,data.height)+'px';frame.setAttribute('scrolling','no');break;
 }
});
/* 主界面空闲后预加载各分页脚本：切页时无需等下载与初始化，手感更顺。各页自己的轮询已按 section 可见性收敛，不可见时不会发请求。 */
function airPreloadPages(){if(window.__airPreloading)return;window.__airPreloading=1;Object.keys(airPageJs).forEach(function(k){if(window["__airPj_"+k])return;window["__airPj_"+k]=1;var sc=document.createElement("script");sc.src="/"+airPageJs[k];sc.async=true;document.body.appendChild(sc);});}
if(document.readyState==="complete"){setTimeout(airPreloadPages,1200);}else{window.addEventListener("load",function(){setTimeout(airPreloadPages,1200);});}
/* 消息提示框（toast）统一挂到 body 直接子级。
   各页的 toast 原本在自己的 <section> 里，而 section 上挂着切页动画 airSectionEnter
   （animation-fill-mode:both），结束时浏览器仍按单位矩阵保留 transform ——
   只要祖先有任何 transform，里面的 position:fixed 就相对该祖先定位而不是视口，
   表现就是「提示框不居中」（实测 left 算成 670px 而不是视口的 50%=1280px）。
   关键帧改成 transform:none 也不够（仍被算作有 transform），只能把元素搬出那个祖先。 */
;(function(){
  function airHoistToasts(){
    var list=document.querySelectorAll('#toast,#wifi-toast,#liu-toast,.air-inner .toast');
    for(var i=0;i<list.length;i++){
      var el=list[i];
      if(el.parentElement&&el.parentElement!==document.body){document.body.appendChild(el);}
    }
  }
  window.airHoistToasts=airHoistToasts;
  if(document.readyState==='loading'){document.addEventListener('DOMContentLoaded',airHoistToasts);}
  else{airHoistToasts();}
  window.addEventListener('load',airHoistToasts);
  setTimeout(airHoistToasts,600);
  setTimeout(airHoistToasts,1600);
  document.addEventListener('click',function(){setTimeout(airHoistToasts,20);},true);
})();
