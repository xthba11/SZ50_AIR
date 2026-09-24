/* Let the main page own spacing and scrolling while retaining page isolation. */
(function(){
 window.addEventListener('message',function(event){
  const data=event.data;
  if(!data||data.type!=='air-page-height'||!Number.isFinite(data.height)||data.height<0||data.height>30000)return;
  for(const frame of document.querySelectorAll('iframe')){
   if(frame.contentWindow===event.source){
    frame.dataset.autoHeight='true';
    frame.style.setProperty('height',Math.max(50,data.height)+'px','important');
    frame.style.setProperty('overflow','hidden','important');
    frame.setAttribute('scrolling','no');
    break;
   }
  }
 });
 if(window.self===window.top)return;
 function start(){
  const style=document.createElement('style');
  style.textContent='html{overflow-y:visible!important;overflow-x:hidden!important}html,body.air-inner{margin:0!important;padding:0!important;min-height:0!important;height:auto!important;background:transparent!important;overflow-y:visible!important;overflow-x:hidden!important}body.air-inner.air-speedtest-body{background:transparent!important;padding:12px!important;overflow:hidden!important}html:has(body.air-speedtest-body){overflow:hidden!important}body.air-inner{display:flow-root!important}body.air-inner .container,body.air-inner .devices-shell,body.air-inner .monitor-shell,body.air-inner .proxy-shell,body.air-inner .air-system-shell,body.air-inner .charge-shell,body.air-inner .liuliang-shell,body.air-inner[data-page="at"] #app{max-width:none!important;width:100%!important;margin:0!important;padding:0!important;box-sizing:border-box!important}.air-page-header,.devices-hero,.proxy-hero{display:none!important}body.air-inner .power-buttons{margin-top:0}body.air-inner[data-page="at"] .el-tabs--border-card{border:0;box-shadow:none;background:transparent}body.air-inner[data-page="at"] .el-tabs--border-card>.el-tabs__header{background:transparent}body.air-inner[data-page="at"] .demo-tabs>.el-tabs__content{padding:20px 0}';
  document.head.appendChild(style);
  let target;try{target=new URL(document.referrer).origin;}catch(e){}
  if(!target)target='*';
  let pending=false,last=0;
  function report(){pending=false;let height=Math.ceil(document.body.getBoundingClientRect().height)+2;const dialog=document.querySelector('.confirmation');if(dialog&&getComputedStyle(dialog).display!=='none')height=Math.max(height,640);if(height!==last){last=height;parent.postMessage({type:'air-page-height',height},target);}}
  const queue=()=>{if(!pending){pending=true;requestAnimationFrame(report);}};
  new ResizeObserver(queue).observe(document.body);
  new MutationObserver(queue).observe(document.body,{subtree:true,childList:true,attributes:true,attributeFilter:['class','style','open']});
  window.addEventListener('resize',queue);window.addEventListener('load',queue);queue();
  // 鼠标在 iframe 内移动时，主界面收不到 mousemove（事件不会跨文档），
  // 于是把坐标换算成主界面坐标系后转过去，粒子才能继续跟随。
  let mousePending=false,lastMouse=null;
  function flushMouse(){
   mousePending=false;
   if(!lastMouse)return;
   let x=lastMouse.x,y=lastMouse.y,gone=lastMouse.gone;
   try{if(window.frameElement){const r=window.frameElement.getBoundingClientRect();x+=r.left;y+=r.top;}}catch(e){}
   parent.postMessage({type:'air-mouse',x:gone?-9999:x,y:gone?-9999:y},target);
  }
  window.addEventListener('mousemove',function(e){
   lastMouse={x:e.clientX,y:e.clientY,gone:false};
   if(mousePending)return;
   mousePending=true;requestAnimationFrame(flushMouse);
  },{passive:true});
  document.addEventListener('mouseleave',function(){
   lastMouse={x:0,y:0,gone:true};
   if(mousePending)return;
   mousePending=true;requestAnimationFrame(flushMouse);
  });
  window.addEventListener('pointerdown',function(e){
   let x=e.clientX,y=e.clientY;
   try{if(window.frameElement){const r=window.frameElement.getBoundingClientRect();x+=r.left;y+=r.top;}}catch(err){}
   parent.postMessage({type:'air-click',x:x,y:y},target);
  },{passive:true});
 }
 if(document.readyState==='loading')document.addEventListener('DOMContentLoaded',start);else start();
})();
