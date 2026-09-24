(function(){
'use strict';
const list=document.getElementById('devices'),statusLine=document.getElementById('status'),refreshButton=document.getElementById('refresh');
let busy=false,dirty=false,holdUntil=0,lastData=null,trafficByMac={},globalProxyEnabled=false;
const cardMap=new Map();
function el(tag,text,cls){const n=document.createElement(tag);if(text!==undefined)n.textContent=text;if(cls)n.className=cls;return n;}
function duration(seconds){if(seconds===null||seconds===undefined)return '未知';return `${Math.floor(seconds/3600)} 小时 ${Math.floor(seconds%3600/60)} 分`;}
function fmtBytes(n){n=Number(n)||0;if(n<=0)return '0 B';const u=['B','KB','MB','GB','TB'];let i=0,v=n;while(v>=1024&&i<u.length-1){v/=1024;i++;}return `${v>=100||i===0?v.toFixed(0):v.toFixed(1)} ${u[i]}`;}
function fmtRate(bps){const b=(Number(bps)||0)/8;if(b<=0)return '0 B/s';if(b<1024)return Math.round(b)+' B/s';if(b<1048576)return (b/1024).toFixed(1)+' KB/s';return (b/1048576).toFixed(2)+' MB/s';}
function fmtAxisRate(bps){bps=Number(bps)||0;if(bps<=0)return '0 B/s';const mb=bps/8000000;if(mb>=1)return (mb>=10?mb.toFixed(1):mb.toFixed(2))+' MB/s';if(mb>=0.01)return Number(mb.toFixed(3))+' MB/s';return ((bps/8)/1024).toFixed(1)+' KB/s';}
function niceRateMax(bps){bps=Number(bps)||0;const MIN_BPS=400000;if(bps<=MIN_BPS)return MIN_BPS;const mb=bps/8000000,power=10**Math.floor(Math.log10(mb)),ratio=mb/power;const niceMb=(ratio<=1?1:ratio<=2?2:ratio<=5?5:10)*power;return Math.round(niceMb*8000000);}
function speedChart(samples){
 const panel=el('section',undefined,'speed-panel'),head=el('div',undefined,'speed-head');
 const rateText=el('div',undefined,'speed-rate-badges');
 head.append(el('strong','实时网速'),rateText);
 panel.append(head);
 const svg=document.createElementNS('http://www.w3.org/2000/svg','svg');
 svg.setAttribute('viewBox','0 0 600 146');svg.setAttribute('preserveAspectRatio','xMidYMid meet');svg.setAttribute('role','img');svg.setAttribute('aria-label','最近30次直连与代理上下行网速');
 const defs=document.createElementNS(svg.namespaceURI,'defs');
 defs.innerHTML='<linearGradient id="downDirectGrad" x1="0" y1="0" x2="0" y2="1"><stop offset="0%" stop-color="#2563eb" stop-opacity="0.14"/><stop offset="100%" stop-color="#2563eb" stop-opacity="0"/></linearGradient><linearGradient id="upDirectGrad" x1="0" y1="0" x2="0" y2="1"><stop offset="0%" stop-color="#10b981" stop-opacity="0.14"/><stop offset="100%" stop-color="#10b981" stop-opacity="0"/></linearGradient>';
 svg.append(defs);
 const axisLabels=[];
 for(const y of [14,72,130]){
  const grid=document.createElementNS(svg.namespaceURI,'line'),label=document.createElementNS(svg.namespaceURI,'text');
  grid.setAttribute('x1','74');grid.setAttribute('x2','592');grid.setAttribute('y1',String(y));grid.setAttribute('y2',String(y));
  grid.setAttribute('class','speed-grid');
  label.setAttribute('x','68');label.setAttribute('y',String(y+4));label.setAttribute('text-anchor','end');label.setAttribute('class','speed-axis');
  svg.append(grid,label);axisLabels.push(label);
 }
 const pathDirectDown=document.createElementNS(svg.namespaceURI,'path');pathDirectDown.setAttribute('class','speed-area-down');pathDirectDown.setAttribute('fill','url(#downDirectGrad)');
 const pathDirectUp=document.createElementNS(svg.namespaceURI,'path');pathDirectUp.setAttribute('class','speed-area-up');pathDirectUp.setAttribute('fill','url(#upDirectGrad)');
 svg.append(pathDirectDown,pathDirectUp);

 const lineDirectDown=document.createElementNS(svg.namespaceURI,'path');lineDirectDown.setAttribute('class','speed-line-direct-down');lineDirectDown.setAttribute('fill','none');
 const lineProxyDown=document.createElementNS(svg.namespaceURI,'path');lineProxyDown.setAttribute('class','speed-line-proxy-down');lineProxyDown.setAttribute('fill','none');
 const lineDirectUp=document.createElementNS(svg.namespaceURI,'path');lineDirectUp.setAttribute('class','speed-line-direct-up');lineDirectUp.setAttribute('fill','none');
 const lineProxyUp=document.createElementNS(svg.namespaceURI,'path');lineProxyUp.setAttribute('class','speed-line-proxy-up');lineProxyUp.setAttribute('fill','none');
 svg.append(lineDirectDown,lineProxyDown,lineDirectUp,lineProxyUp);

 function getCurvePath(pts, k = 0.18, clampMaxY = 130, clampMinY = 14) {
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

 const dotDirectDown=document.createElementNS(svg.namespaceURI,'circle');dotDirectDown.setAttribute('r','3');dotDirectDown.setAttribute('class','speed-dot dot-direct-down');
 const dotProxyDown=document.createElementNS(svg.namespaceURI,'circle');dotProxyDown.setAttribute('r','3');dotProxyDown.setAttribute('class','speed-dot dot-proxy-down');
 const dotDirectUp=document.createElementNS(svg.namespaceURI,'circle');dotDirectUp.setAttribute('r','3');dotDirectUp.setAttribute('class','speed-dot dot-direct-up');
 const dotProxyUp=document.createElementNS(svg.namespaceURI,'circle');dotProxyUp.setAttribute('r','3');dotProxyUp.setAttribute('class','speed-dot dot-proxy-up');
 svg.append(dotDirectDown,dotProxyDown,dotDirectUp,dotProxyUp);

 const guideLine=document.createElementNS(svg.namespaceURI,'line');
 guideLine.setAttribute('y1','14');guideLine.setAttribute('y2','130');guideLine.setAttribute('stroke','#94a3b8');guideLine.setAttribute('stroke-width','1');guideLine.setAttribute('stroke-dasharray','3 3');
 guideLine.style.display='none';guideLine.style.pointerEvents='none';

 const hoverDDown=document.createElementNS(svg.namespaceURI,'circle');hoverDDown.setAttribute('r','4.5');hoverDDown.setAttribute('fill','#2563eb');hoverDDown.setAttribute('stroke','#fff');hoverDDown.setAttribute('stroke-width','2');hoverDDown.style.display='none';hoverDDown.style.pointerEvents='none';
 const hoverPDown=document.createElementNS(svg.namespaceURI,'circle');hoverPDown.setAttribute('r','4.5');hoverPDown.setAttribute('fill','#8b5cf6');hoverPDown.setAttribute('stroke','#fff');hoverPDown.setAttribute('stroke-width','2');hoverPDown.style.display='none';hoverPDown.style.pointerEvents='none';
 const hoverDUp=document.createElementNS(svg.namespaceURI,'circle');hoverDUp.setAttribute('r','4.5');hoverDUp.setAttribute('fill','#10b981');hoverDUp.setAttribute('stroke','#fff');hoverDUp.setAttribute('stroke-width','2');hoverDUp.style.display='none';hoverDUp.style.pointerEvents='none';
 const hoverPUp=document.createElementNS(svg.namespaceURI,'circle');hoverPUp.setAttribute('r','4.5');hoverPUp.setAttribute('fill','#f59e0b');hoverPUp.setAttribute('stroke','#fff');hoverPUp.setAttribute('stroke-width','2');hoverPUp.style.display='none';hoverPUp.style.pointerEvents='none';
 svg.append(guideLine,hoverDDown,hoverPDown,hoverDUp,hoverPUp);

 const hitRect=document.createElementNS(svg.namespaceURI,'rect');
 hitRect.setAttribute('x','0');hitRect.setAttribute('y','0');hitRect.setAttribute('width','600');hitRect.setAttribute('height','146');hitRect.setAttribute('fill','transparent');hitRect.setAttribute('pointer-events','all');hitRect.style.cursor='crosshair';
 svg.append(hitRect);

 const tooltip=el('div',undefined,'speed-tooltip');
 panel.append(svg,tooltip);

 const legend=el('div',undefined,'speed-legend');
 legend.innerHTML='<span class="legend-item"><span class="legend-bar bar-direct-down"></span>直连下载</span><span class="legend-item"><span class="legend-bar bar-proxy-down"></span>代理下载</span><span class="legend-item"><span class="legend-bar bar-direct-up"></span>直连上传</span><span class="legend-item"><span class="legend-bar bar-proxy-up"></span>代理上传</span><small class="legend-hint"></small>';
 const legendSmall=legend.querySelector('.legend-hint');
 panel.append(legend);

 let lastSampleCount=0,lastSampleAt=null,cachedSamples=[],cachedPts=[];

 function showHover(clientX){
  if(!cachedSamples.length||!cachedPts.length)return;
  const rect=svg.getBoundingClientRect();
  const relX=Math.max(0,Math.min(1,(clientX-rect.left)/rect.width));
  const svgX=relX*600;

  let closestIdx=0,minDist=Infinity;
  cachedPts.forEach((p,i)=>{
   const d=Math.abs(p.dDown.x-svgX);
   if(d<minDist){minDist=d;closestIdx=i;}
  });

  const pt=cachedPts[closestIdx];
  const s=cachedSamples[closestIdx];

  guideLine.setAttribute('x1',pt.dDown.x.toFixed(1));
  guideLine.setAttribute('x2',pt.dDown.x.toFixed(1));
  guideLine.style.display='';

  hoverDDown.setAttribute('cx',pt.dDown.x.toFixed(1));hoverDDown.setAttribute('cy',pt.dDown.y.toFixed(1));hoverDDown.style.display='';
  hoverPDown.setAttribute('cx',pt.pDown.x.toFixed(1));hoverPDown.setAttribute('cy',pt.pDown.y.toFixed(1));hoverPDown.style.display='';
  hoverDUp.setAttribute('cx',pt.dUp.x.toFixed(1));hoverDUp.setAttribute('cy',pt.dUp.y.toFixed(1));hoverDUp.style.display='';
  hoverPUp.setAttribute('cx',pt.pUp.x.toFixed(1));hoverPUp.setAttribute('cy',pt.pUp.y.toFixed(1));hoverPUp.style.display='';

  const timeStr=s.at?new Date(s.at).toLocaleTimeString():'';
  const dDownStr=fmtRate(s.direct_down_bps!==undefined?s.direct_down_bps:(s.down_bps||0));
  const dUpStr=fmtRate(s.direct_up_bps!==undefined?s.direct_up_bps:(s.up_bps||0));
  const pDownStr=fmtRate(s.proxy_down_bps||0);
  const pUpStr=fmtRate(s.proxy_up_bps||0);

  tooltip.innerHTML=`
   <div style="color:#94a3b8;font-size:10px;font-family:monospace;margin-bottom:2px;">${timeStr}</div>
   <div style="display:flex;gap:10px;font-size:11px;font-weight:600;">
    <span>直连: <b style="color:#38bdf8;">↓${dDownStr}</b> <b style="color:#34d399;">↑${dUpStr}</b></span>
    <span>代理: <b style="color:#c084fc;">↓${pDownStr}</b> <b style="color:#fbbf24;">↑${pUpStr}</b></span>
   </div>
  `;
  tooltip.style.display='block';
  const pixelX=(pt.dDown.x/600)*rect.width;
  const clampX=Math.max(110,Math.min(rect.width-110,pixelX));
  tooltip.style.left=clampX+'px';
 }

 function hideHover(){
  guideLine.style.display='none';
  hoverDDown.style.display='none';
  hoverPDown.style.display='none';
  hoverDUp.style.display='none';
  hoverPUp.style.display='none';
  tooltip.style.display='none';
 }

 hitRect.onpointermove=e=>showHover(e.clientX);
 hitRect.onpointerdown=e=>showHover(e.clientX);
 hitRect.onpointerleave=hideHover;
 hitRect.ontouchstart=e=>{if(e.touches.length)showHover(e.touches[0].clientX);};
 hitRect.ontouchmove=e=>{if(e.touches.length)showHover(e.touches[0].clientX);};

 function update(curSamples){
  cachedSamples=curSamples;
  const last=curSamples[curSamples.length-1]||{};
  const isNewSample=curSamples.length>1&&(curSamples.length>lastSampleCount||(last.at&&last.at!==lastSampleAt));
  lastSampleCount=curSamples.length;
  lastSampleAt=last.at;

  const dDown=last.direct_down_bps!==undefined?last.direct_down_bps:(last.down_bps||0);
  const pDown=last.proxy_down_bps||0;
  const dUp=last.direct_up_bps!==undefined?last.direct_up_bps:(last.up_bps||0);
  const pUp=last.proxy_up_bps||0;

  rateText.innerHTML=`<div class="rate-badge-group"><span class="rate-badge rate-direct" title="直连上下行"><span class="badge-tag">直连</span> <span class="rate-val val-blue">↓${fmtRate(dDown)}</span> <span class="rate-val val-green">↑${fmtRate(dUp)}</span></span><span class="rate-badge rate-proxy" title="代理上下行"><span class="badge-tag">代理</span> <span class="rate-val val-purple">↓${fmtRate(pDown)}</span> <span class="rate-val val-orange">↑${fmtRate(pUp)}</span></span></div>`;

  const scale=niceRateMax(Math.max(0,...curSamples.flatMap(s=>[s.direct_down_bps!==undefined?s.direct_down_bps:(s.down_bps||0),s.proxy_down_bps||0,s.direct_up_bps!==undefined?s.direct_up_bps:(s.up_bps||0),s.proxy_up_bps||0])));
  if(axisLabels.length>=3){
   axisLabels[0].textContent=fmtAxisRate(scale);
   axisLabels[1].textContent=fmtAxisRate(scale/2);
   axisLabels[2].textContent=fmtAxisRate(0);
  }
  if(curSamples.length>0){
   const getX=i=>curSamples.length===1?74:74+i*518/(curSamples.length-1);
   const getY=val=>130-(Number(val)||0)*116/scale;

   const ptsDDown=curSamples.map((s,i)=>({x:getX(i),y:getY(s.direct_down_bps!==undefined?s.direct_down_bps:(s.down_bps||0))}));
   const ptsPDown=curSamples.map((s,i)=>({x:getX(i),y:getY(s.proxy_down_bps||0)}));
   const ptsDUp=curSamples.map((s,i)=>({x:getX(i),y:getY(s.direct_up_bps!==undefined?s.direct_up_bps:(s.up_bps||0))}));
   const ptsPUp=curSamples.map((s,i)=>({x:getX(i),y:getY(s.proxy_up_bps||0)}));

   cachedPts=curSamples.map((s,i)=>({dDown:ptsDDown[i],pDown:ptsPDown[i],dUp:ptsDUp[i],pUp:ptsPUp[i]}));

   const curveDDown=getCurvePath(ptsDDown,0.18,130,14);
   const curvePDown=getCurvePath(ptsPDown,0.18,130,14);
   const curveDUp=getCurvePath(ptsDUp,0.18,130,14);
   const curvePUp=getCurvePath(ptsPUp,0.18,130,14);

   pathDirectDown.setAttribute('d',curveDDown?`${curveDDown} L ${ptsDDown[ptsDDown.length-1].x.toFixed(1)},130 L ${ptsDDown[0].x.toFixed(1)},130 Z`:'');
   pathDirectDown.style.display='';
   pathDirectUp.setAttribute('d',curveDUp?`${curveDUp} L ${ptsDUp[ptsDUp.length-1].x.toFixed(1)},130 L ${ptsDUp[0].x.toFixed(1)},130 Z`:'');
   pathDirectUp.style.display='';

   lineDirectDown.setAttribute('d',curveDDown);
   lineProxyDown.setAttribute('d',curvePDown);
   lineDirectUp.setAttribute('d',curveDUp);
   lineProxyUp.setAttribute('d',curvePUp);

   const lastDDown=ptsDDown[ptsDDown.length-1];
   const lastPDown=ptsPDown[ptsPDown.length-1];
   const lastDUp=ptsDUp[ptsDUp.length-1];
   const lastPUp=ptsPUp[ptsPUp.length-1];

   dotDirectDown.setAttribute('cx',lastDDown.x.toFixed(1));dotDirectDown.setAttribute('cy',lastDDown.y.toFixed(1));dotDirectDown.style.display='';
   dotProxyDown.setAttribute('cx',lastPDown.x.toFixed(1));dotProxyDown.setAttribute('cy',lastPDown.y.toFixed(1));dotProxyDown.style.display='';
   dotDirectUp.setAttribute('cx',lastDUp.x.toFixed(1));dotDirectUp.setAttribute('cy',lastDUp.y.toFixed(1));dotDirectUp.style.display='';
   dotProxyUp.setAttribute('cx',lastPUp.x.toFixed(1));dotProxyUp.setAttribute('cy',lastPUp.y.toFixed(1));dotProxyUp.style.display='';

   if(isNewSample){
    for(const el of [lineDirectDown,lineProxyDown,lineDirectUp,lineProxyUp,pathDirectDown,pathDirectUp]){
     el.classList.remove('speed-slide');
     void el.clientWidth;
     el.classList.add('speed-slide');
    }
    for(const dot of [dotDirectDown,dotProxyDown,dotDirectUp,dotProxyUp]){
     dot.classList.remove('speed-dot-enter');
     void dot.clientWidth;
     dot.classList.add('speed-dot-enter');
    }
   }
   legendSmall.textContent=`${curSamples.length}/30 点 · 每 2 秒`;
  }else{
   pathDirectDown.style.display='none';
   pathDirectUp.style.display='none';
   lineDirectDown.setAttribute('d','');
   lineProxyDown.setAttribute('d','');
   lineDirectUp.setAttribute('d','');
   lineProxyUp.setAttribute('d','');
   dotDirectDown.style.display='none';
   dotProxyDown.style.display='none';
   dotDirectUp.style.display='none';
   dotProxyUp.style.display='none';
   legendSmall.textContent='正在采集首个样本';
  }
 }
 update(samples);
 return {panel,update};
}
async function request(path,options){const controller=new AbortController(),timer=setTimeout(()=>controller.abort(),12000);try{const response=await fetch(path,{...options,signal:controller.signal,cache:'no-store'});if(!response.ok)throw new Error(response.status===401?'登录已过期，请刷新管理页面重新登录':`请求失败（${response.status}）`);return await response.json();}finally{clearTimeout(timer);}}
function field(title,value,placeholder){const label=el('label',title),input=el('input');input.type='number';input.min='0';input.step='1';input.inputMode='numeric';input.value=value?String(value):'';input.placeholder=placeholder;label.append(input);return {label,input};}
function detail(title,value){const box=el('div',undefined,'detail-item');box.append(el('span',title),el('strong',value));return box;}
function markClean(fields){for(const f of fields)delete f.dataset.dirty;dirty=Boolean(list.querySelector('[data-dirty]'));}
function limitPanel(d,t){
 const panel=el('section',undefined,'limits-panel'),heading=el('div',undefined,'limits-heading');heading.append(el('strong','速率与配额'),el('span','0 或留空表示不限'));panel.append(heading);
 const form=el('form',undefined,'device-limits'),down=field('下行限速 · MB/s',t.limit_down_kbps?Number(t.limit_down_kbps)/8000:0,'不限'),up=field('上行限速 · MB/s',t.limit_up_kbps?Number(t.limit_up_kbps)/8000:0,'不限'),quota=field('流量配额 · MB',t.quota_mb,'不限'),save=el('button','保存设置','save-button'),reset=el('button','清零流量','quiet-button'),out=el('output','', 'form-output');down.input.step=up.input.step='0.001';save.type='submit';reset.type='button';out.setAttribute('aria-live','polite');const fields=[down.input,up.input,quota.input];form.append(down.label,up.label,quota.label,save,reset,out);
 const collect=()=>({limit_down_kbps:Math.max(0,Math.round((Number(down.input.value)||0)*8000)),limit_up_kbps:Math.max(0,Math.round((Number(up.input.value)||0)*8000)),quota_mb:Math.max(0,Math.floor(Number(quota.input.value)||0))});
 fields.forEach(f=>f.addEventListener('input',()=>{dirty=true;f.dataset.dirty='true';}));
 form.addEventListener('submit',async event=>{event.preventDefault();save.disabled=true;out.textContent='正在应用…';try{const values=collect();await request('/air-api/traffic',{method:'PUT',headers:{'Content-Type':'application/json'},body:JSON.stringify({mac:d.mac,...values})});Object.assign(t,values);if(values.quota_mb===0)t.blocked=false;markClean(fields);out.textContent='设置已生效';holdUntil=Date.now()+3000;}catch(error){out.textContent=error.message||'保存失败，请重试';}finally{save.disabled=false;}});
 reset.addEventListener('click',async()=>{reset.disabled=true;out.textContent='正在清零…';try{await request('/air-api/traffic',{method:'PUT',headers:{'Content-Type':'application/json'},body:JSON.stringify({mac:d.mac,reset:true})});t.down_bytes=0;t.up_bytes=0;t.proxy_down_bytes=0;t.proxy_up_bytes=0;t.blocked=false;out.textContent='流量已清零';holdUntil=Date.now()+3000;render(lastData);}catch(error){out.textContent=error.message||'清零失败';}finally{reset.disabled=false;}});
 panel.append(form);return {panel,fields};
}
function noteForm(d){
 const form=el('form',undefined,'device-note'),label=el('label','设备备注'),input=el('input'),actions=el('div',undefined,'note-actions'),save=el('button','保存备注'),output=el('output');
 input.id='note-'+d.mac.replaceAll(':','');label.htmlFor=input.id;input.value=d.note||'';input.maxLength=64;input.placeholder='例如：客厅电视';label.append(input);save.type='submit';actions.append(save);output.setAttribute('aria-live','polite');input.addEventListener('input',()=>{dirty=true;input.dataset.dirty='true';});
 let kick=null,remove=null;
 function updateOnline(online){
  if(online){
   if(remove){remove.remove();remove=null;}
   if(!kick){
    kick=el('button','强制下线','kick-button');kick.type='button';
    kick.addEventListener('click',async()=>{
     if(!confirm(`确定让“${d.note||d.mac}”立即断开 Wi-Fi？保存过密码的设备可能自动重连。`))return;
     kick.disabled=true;kick.textContent='正在下线…';
     try{await request('/air-api/devices/kick',{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({mac:d.mac})});d.online=false;d.connected_seconds=null;d.addresses=[];holdUntil=Date.now()+3000;statusLine.textContent=`${d.note||d.mac} 已强制下线；设备可能自动重连。`;render(lastData);}
     catch(error){output.textContent=error.message||'下线失败，请重试';kick.disabled=false;kick.textContent='强制下线';}
    });
    actions.append(kick);
   }
  }else{
   if(kick){kick.remove();kick=null;}
   if(!remove){
    remove=el('button','删除记录','delete-button');remove.type='button';
    remove.addEventListener('click',async()=>{
     if(!confirm(`删除“${d.note||d.mac}”的历史记录、累计流量和全部限速设置？此操作无法撤销。`))return;
     remove.disabled=true;output.textContent='正在删除…';
     try{const body=JSON.stringify({mac:d.mac}),options={method:'DELETE',headers:{'Content-Type':'application/json'},body};await request('/air-api/traffic',options);await request('/air-api/devices',options);delete trafficByMac[d.mac];lastData.devices=lastData.devices.filter(item=>item.mac!==d.mac);dirty=false;render(lastData);}
     catch(error){output.textContent=error.message||'删除失败，请重试';remove.disabled=false;}
    });
    actions.append(remove);
   }
  }
 }
 updateOnline(d.online);
 form.append(label,actions,output);
 form.addEventListener('submit',async event=>{event.preventDefault();save.disabled=true;output.textContent='正在保存…';try{await request('/air-api/devices',{method:'PUT',headers:{'Content-Type':'application/json'},body:JSON.stringify({mac:d.mac,note:input.value})});d.note=input.value.trim();form.closest('.device-card').querySelector('h2').textContent=d.note||'未备注设备';markClean([input]);output.textContent='备注已保存';}catch(error){output.textContent=error.message||'保存失败';}finally{save.disabled=false;}});
 return {form,input,updateOnline};
}
function blockedNotice(d,t){
 const box=el('div',undefined,'blocked-note'),copy=el('span','该设备已达到流量配额，当前处于低速停用状态。'),button=el('button','恢复使用','restore-button');
 button.type='button'; button.addEventListener('click',async()=>{button.disabled=true;button.textContent='正在恢复…';try{await request('/air-api/traffic',{method:'PUT',headers:{'Content-Type':'application/json'},body:JSON.stringify({mac:d.mac,unblock:true})});t.down_bytes=0;t.up_bytes=0;t.proxy_down_bytes=0;t.proxy_up_bytes=0;t.blocked=false;render(lastData);}catch(error){copy.textContent=error.message||'恢复失败，请重试';button.disabled=false;button.textContent='恢复使用';}});box.append(copy,button);return box;
}
function createCard(d,t,stale){
 const card=el('article',undefined,'device-card'+(t.blocked?' is-blocked':''));
 card.dataset.mac=d.mac;
 const head=el('header',undefined,'device-head'),title=el('div',undefined,'device-title');
 const h2=el('h2',d.note||'未备注设备');
 title.append(h2,el('p',d.mac,'device-identity'));

 const headActions=el('div',undefined,'device-head-actions');
 const proxyCtrl=el('div',undefined,'device-proxy-ctrl'+(globalProxyEnabled?'':' is-disabled'));
 const proxyLabel=el('span','代理','device-proxy-txt');
 const proxySwitch=el('label',undefined,'device-proxy-switch');
 const proxyInput=el('input');
 proxyInput.type='checkbox';
 proxyInput.className='device-proxy-input';
 proxyInput.checked=t.proxy_enabled!==false;
 proxyInput.disabled=!globalProxyEnabled;
 const proxySlider=el('span',undefined,'device-proxy-slider');
 proxySwitch.append(proxyInput,proxySlider);
 proxySwitch.title=globalProxyEnabled?(proxyInput.checked?'点击关闭此设备代理通道（切换为原生直连）':'点击开启此设备代理通道'):'总代理未开启，需先在“代理设置”页面开启总代理';
 proxyCtrl.append(proxyLabel,proxySwitch);

 proxyInput.addEventListener('change',async()=>{
  if(!globalProxyEnabled)return;
  proxyInput.disabled=true;
  holdUntil=Date.now()+3000;
  const targetState=proxyInput.checked;
  try{
   await request('/air-api/traffic',{
    method:'PUT',
    headers:{'Content-Type':'application/json'},
    body:JSON.stringify({mac:d.mac,proxy_enabled:targetState})
   });
   t.proxy_enabled=targetState;
   proxySwitch.title=targetState?'点击关闭此设备代理通道（切换为原生直连）':'点击开启此设备代理通道';
   statusLine.textContent=`${d.note||d.mac} 代理通道已${targetState?'开启':'关闭（直连）'}`;
  }catch(e){
   proxyInput.checked=!targetState;
   statusLine.textContent=`修改代理失败: ${e.message}`;
  }finally{
   proxyInput.disabled=!globalProxyEnabled;
  }
 });

 const state=t.blocked?'已停用':stale?'状态未知':d.online?'在线':'离线';
 const chip=el('span',state,'status-chip '+(t.blocked?'blocked':(!d.online||stale)?'offline':''));
 headActions.append(proxyCtrl,chip);
 head.append(title,headActions);
 card.append(head);

 const traffic=el('section',undefined,'traffic-panel-compact');
 const statDown=el('div',undefined,'traffic-col traffic-col-down');
 const downHead=el('div',undefined,'traffic-col-head');
 const downLabel=el('span','累计下载','traffic-col-title');
 const downStrong=el('strong',fmtBytes(t.down_bytes),'traffic-col-total');
 downHead.append(downLabel,downStrong);

 const directDownBytes=Math.max(0,(t.down_bytes||0)-(t.proxy_down_bytes||0));
 const downSub=el('div',undefined,'traffic-col-sub');
 const directDownWrap=el('span',undefined,'sub-stat stat-direct-down');
 directDownWrap.title='直连下载流量';
 const directDownVal=el('strong',fmtBytes(directDownBytes));
 directDownWrap.append(el('span','直连: '),directDownVal);

 const proxyDownWrap=el('span',undefined,'sub-stat stat-proxy-down');
 proxyDownWrap.title='代理下载流量';
 const proxyDownStrong=el('strong',fmtBytes(t.proxy_down_bytes||0));
 proxyDownWrap.append(el('span','代理: '),proxyDownStrong);
 downSub.append(directDownWrap,proxyDownWrap);
 statDown.append(downHead,downSub);

 const statUp=el('div',undefined,'traffic-col traffic-col-up');
 const upHead=el('div',undefined,'traffic-col-head');
 const upLabel=el('span','累计上传','traffic-col-title');
 const upStrong=el('strong',fmtBytes(t.up_bytes),'traffic-col-total');
 upHead.append(upLabel,upStrong);

 const directUpBytes=Math.max(0,(t.up_bytes||0)-(t.proxy_up_bytes||0));
 const upSub=el('div',undefined,'traffic-col-sub');
 const directUpWrap=el('span',undefined,'sub-stat stat-direct-up');
 directUpWrap.title='直连上传流量';
 const directUpVal=el('strong',fmtBytes(directUpBytes));
 directUpWrap.append(el('span','直连: '),directUpVal);

 const proxyUpWrap=el('span',undefined,'sub-stat stat-proxy-up');
 proxyUpWrap.title='代理上传流量';
 const proxyUpStrong=el('strong',fmtBytes(t.proxy_up_bytes||0));
 proxyUpWrap.append(el('span','代理: '),proxyUpStrong);
 upSub.append(directUpWrap,proxyUpWrap);
 statUp.append(upHead,upSub);

 traffic.append(statDown,statUp);
 card.append(traffic);
 const chart=speedChart(t.samples||[]);
 card.append(chart.panel);
 const details=el('div',undefined,'device-details');
 const ipDetail=detail('IPv4 地址',t.ip||'暂不可用');
 const durDetail=detail('在线时长',d.online&&!stale?duration(d.connected_seconds):'—');
 const lastDetail=detail('最后在线',new Date(d.last_seen).toLocaleString());
 details.append(ipDetail,durDetail,lastDetail);
 card.append(details);
 let blockedBox=null;
 if(t.blocked){blockedBox=blockedNotice(d,t);card.append(blockedBox);}
 let limitCtrl=null,trackWarn=null;
 if(t.ip){limitCtrl=limitPanel(d,t);card.append(limitCtrl.panel);}
 else{trackWarn=el('p','暂无可用 IPv4 地址，当前无法统计或限速。','track-warning');card.append(trackWarn);}
 const noteCtrl=noteForm(d);
 card.append(noteCtrl.form);

 function update(curD,curT,curStale){
  if(!noteCtrl.input.dataset.dirty&&document.activeElement!==noteCtrl.input){
   h2.textContent=curD.note||'未备注设备';
   noteCtrl.input.value=curD.note||'';
  }
  const state=curT.blocked?'已停用':curStale?'状态未知':curD.online?'在线':'离线';
  chip.textContent=state;
  chip.className='status-chip '+(curT.blocked?'blocked':(!curD.online||curStale)?'offline':'');
  card.classList.toggle('is-blocked',Boolean(curT.blocked));

  proxyInput.disabled=!globalProxyEnabled;
  proxyInput.checked=curT.proxy_enabled!==false;
  proxyCtrl.classList.toggle('is-disabled',!globalProxyEnabled);
  proxySwitch.title=globalProxyEnabled?(proxyInput.checked?'点击关闭此设备代理通道（切换为原生直连）':'点击开启此设备代理通道'):'总代理未开启，需先在“代理设置”页面开启总代理';

  const curDirectDown=Math.max(0,(curT.down_bytes||0)-(curT.proxy_down_bytes||0));
  const curDirectUp=Math.max(0,(curT.up_bytes||0)-(curT.proxy_up_bytes||0));
  downStrong.textContent=fmtBytes(curT.down_bytes);
  directDownVal.textContent=fmtBytes(curDirectDown);
  proxyDownStrong.textContent=fmtBytes(curT.proxy_down_bytes||0);
  upStrong.textContent=fmtBytes(curT.up_bytes);
  directUpVal.textContent=fmtBytes(curDirectUp);
  proxyUpStrong.textContent=fmtBytes(curT.proxy_up_bytes||0);
  chart.update(curT.samples||[]);
  ipDetail.querySelector('strong').textContent=curT.ip||'暂不可用';
  durDetail.querySelector('strong').textContent=curD.online&&!curStale?duration(curD.connected_seconds):'—';
  lastDetail.querySelector('strong').textContent=new Date(curD.last_seen).toLocaleString();
  if(curT.blocked&&!blockedBox){
   blockedBox=blockedNotice(curD,curT);
   card.insertBefore(blockedBox,limitCtrl?limitCtrl.panel:trackWarn);
  }else if(!curT.blocked&&blockedBox){
   blockedBox.remove();blockedBox=null;
  }
  if(curT.ip&&!limitCtrl){
   if(trackWarn){trackWarn.remove();trackWarn=null;}
   limitCtrl=limitPanel(curD,curT);
   card.insertBefore(limitCtrl.panel,noteCtrl.form);
  }else if(!curT.ip&&!trackWarn){
   if(limitCtrl){limitCtrl.panel.remove();limitCtrl=null;}
   trackWarn=el('p','暂无可用 IPv4 地址，当前无法统计或限速。','track-warning');
   card.insertBefore(trackWarn,noteCtrl.form);
  }
  noteCtrl.updateOnline(curD.online);
 }
 return {card,update};
}
function render(data){
 lastData=data;
 const stale=Boolean(data.error)||!data.sampled_at||Date.now()-Date.parse(data.sampled_at)>45000,online=data.devices.filter(d=>d.online).length;
 const proxySummary=globalProxyEnabled?'<span class="summary-proxy-tag on">总代理已开</span>':'<span class="summary-proxy-tag off">总代理已关</span>';
 document.getElementById('summary').innerHTML=stale?'状态暂不可用':`${online} 台在线 · ${data.devices.length} 台已记录 · ${proxySummary}`;
 statusLine.textContent=stale?(data.error||'等待首次采样'):'更新于 '+new Date(data.sampled_at).toLocaleTimeString();
 statusLine.classList.toggle('error',stale||data.storage_warning);
 if(!data.devices.length){
  cardMap.clear();
  list.replaceChildren(el('p',stale?'等待设备数据…':'暂未发现已关联的 Wi-Fi 设备。','empty-state'));
  return;
 }
 const empty=list.querySelector('.empty-state');if(empty)empty.remove();
 const currentMacs=new Set(data.devices.map(d=>d.mac));
 for(const [mac,ctrl] of cardMap){
  if(!currentMacs.has(mac)){ctrl.card.remove();cardMap.delete(mac);}
 }
 data.devices.forEach((d,index)=>{
  const t=trafficByMac[d.mac]||{};
  let ctrl=cardMap.get(d.mac);
  if(!ctrl){
   ctrl=createCard(d,t,stale);
   cardMap.set(d.mac,ctrl);
  }else{
   ctrl.update(d,t,stale);
  }
  if(list.children[index]!==ctrl.card){
   list.insertBefore(ctrl.card,list.children[index]||null);
  }
 });
}
async function load(){
 if(busy||dirty||Date.now()<holdUntil||list.contains(document.activeElement))return;
 busy=true;refreshButton.disabled=true;
 try{
  const [deviceData,trafficData,proxyData]=await Promise.all([
    request('/air-api/devices'),
    request('/air-api/traffic'),
    request('/air-api/proxy').catch(()=>({enabled:false}))
  ]);
  globalProxyEnabled=Boolean(proxyData&&proxyData.enabled);
  trafficByMac={};
  for(const c of trafficData.clients||[])trafficByMac[c.mac]=c;
  if(trafficData.error)deviceData.error=trafficData.error;
  if(trafficData.sampled_at&&(!deviceData.sampled_at||Date.parse(trafficData.sampled_at)<Date.parse(deviceData.sampled_at)))deviceData.sampled_at=trafficData.sampled_at;
  render(deviceData);
 }catch(error){
  if(lastData)render({...lastData,error:'连接暂不可用，保留上次记录'});
  else{cardMap.clear();list.replaceChildren(el('p','读取失败，请稍后重试。','empty-state'));}
  statusLine.textContent=error.message||'读取失败';
  statusLine.classList.add('error');
  document.getElementById('summary').textContent='连接暂不可用';
 }finally{
  busy=false;refreshButton.disabled=false;
 }
}
refreshButton.addEventListener('click',()=>{if(dirty){statusLine.textContent='请先保存已修改的内容，再刷新。';return;}load();});
load();
setInterval(()=>{const _s=document.getElementById('devices-section');if((!_s||!_s.hidden)&&!document.hidden)load();},2000);
document.addEventListener('visibilitychange',()=>{if(!document.hidden)load();});
})();
