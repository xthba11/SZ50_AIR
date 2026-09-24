(function(){
 const container=document.getElementById('signal-trends');if(!container)return;
 const fields=[['rsrp','强度 RSRP','dBm','#2563eb'],['rsrq','质量 RSRQ','dB','#0d9488'],['sinr','信噪比 SINR','dB','#7c3aed']];
 const rows=fields.map(([key,label,unit,color])=>{const r=AirTrend.row(label,color);r.row.dataset.metric=key;container.append(r.row);return {...r,key,unit,color};});
 const status=document.getElementById('signal-history-status');let busy=false;
 async function update(){if(busy)return;busy=true;const controller=new AbortController(),timer=setTimeout(()=>controller.abort(),10000);try{const response=await fetch('/air-api/monitor',{cache:'no-store',signal:controller.signal});if(!response.ok)throw new Error('信号读取失败');const data=await response.json(),samples=(data.samples||[]).slice(-30),latest=samples[samples.length-1],stale=!latest||Date.now()-Date.parse(latest.at)>45000;
 for(const r of rows){const value=latest?.signal?.[r.key];r.value.textContent=!stale&&AirTrend.valid(value)?value.toFixed(1)+' '+r.unit:'—';AirTrend.draw(r.svg,samples,s=>s.signal?.[r.key],{color:r.color,span:6,identity:s=>s.signal?.cell});}status.textContent=stale?'等待采样':latest.signal_error||'';status.hidden=!status.textContent;
 }catch(error){for(const r of rows)r.value.textContent='—';status.textContent='信号读取失败';status.hidden=false;}finally{clearTimeout(timer);busy=false;}}
 update();setInterval(()=>{if(!document.hidden)update();},5000);document.addEventListener('visibilitychange',()=>{if(!document.hidden)update();});
})();
