'use strict';
const monitorStatus=document.getElementById('monitor-status');let samples=[],loading=false;const sensorKeys=new Set(),sensorRows=new Map();
const text=(id,value)=>{const el=document.getElementById(id);if(el)el.textContent=value;};
const available=AirTrend.valid;
const colors=['#2563eb','#0891b2','#0d9488','#7c3aed','#c026d3','#ea580c','#4f46e5','#ca8a04','#059669','#db2777','#64748b'];
// 温度监测点中文名（依据 sensor 命名 + 设备主板实物图；未确认含义的如实写"子系统"）
const SENSOR_ZH={'soc-thmzone':'主控芯片','cluster0-thmzone':'CPU 大核簇','apcpu0-thmzone':'应用核 0','apcpu1-thmzone':'应用核 1','nrcp-thmzone':'5G 协议协处理','ank0-thmzone':'基带子系统 0','ank1-thmzone':'基带子系统 1','pa-thmzone':'Wi-Fi 功放','pa5g-thmzone':'5G 功放','battery-thmzone':'电池温度','battery':'电池'};
function sensorLabel(key){
 const base=key.replace(/ \(thermal_zone\d+\)$/,'');
 const zh=SENSOR_ZH[base];
 return zh?zh+'\n'+base:base;   // 换行：中文一行，英文原名一行（不带括号）
}

let cpuChart=null,ramChart=null;
function initCardCharts(){
 const cpuBox=document.getElementById('cpu-chart');
 if(cpuBox&&!cpuChart)cpuChart=AirTrend.cardChart(cpuBox,{label:'CPU 使用率',color:'#2563eb',unit:'%',gradId:'cpuCardGrad'});
 const ramBox=document.getElementById('ram-chart');
 if(ramBox&&!ramChart)ramChart=AirTrend.cardChart(ramBox,{label:'内存使用率',color:'#0d9488',unit:'%',gradId:'ramCardGrad'});
}

function resource(v){return v?`${(v.available_bytes/1048576).toFixed(1)} / ${(v.total_bytes/1048576).toFixed(1)} MiB`:'—';}
function ramResource(v){
 if(!v||!v.total_bytes)return '—';
 const used=Math.max(0,v.total_bytes-v.available_bytes);
 const pct=((used/v.total_bytes)*100).toFixed(1);
 const totalMb=(v.total_bytes/1048576).toFixed(0);
 return `${pct}% / ${totalMb} MiB`;
}
function getRamUsagePercent(s){
 if(!s||!s.memory||!s.memory.total_bytes)return null;
 const used=s.memory.total_bytes-s.memory.available_bytes;
 return Math.max(0,Math.min(100,(used/s.memory.total_bytes)*100));
}


function drawTemperatures(stale=false){
 const latest=samples[samples.length-1];
 for(const s of samples)for(const key of Object.keys(s.temperatures||{}))sensorKeys.add(key);
 const keys=[...sensorKeys].sort((a,b)=>Number((a.match(/thermal_zone(\d+)/)||[])[1]||0)-Number((b.match(/thermal_zone(\d+)/)||[])[1]||0));
 const list=document.getElementById('temperature-trends');
 keys.forEach((key,i)=>{
  let row=sensorRows.get(key);
  if(!row){
   row=AirTrend.row(sensorLabel(key),colors[i%colors.length]);
   row.row.dataset.sensor=key;
   sensorRows.set(key,row);
   list.append(row.row);
  }
  const value=latest?.temperatures[key];
  row.value.textContent=!stale&&available(value)?value.toFixed(1)+' °C':'—';
  AirTrend.draw(row.svg,samples,s=>s.temperatures[key],{color:colors[i%colors.length],span:4});
 });
}


function render(data){
 samples=(data.samples||[]).slice(-30);
 if(!samples.length)throw new Error('等待采样');
 const s=samples[samples.length-1];
 if(Date.now()-Date.parse(s.at)>45000)throw new Error('数据已过期');

 text('cpu-value',available(s.cpu_percent)?s.cpu_percent.toFixed(1)+'%':'—');
 text('ram-value',ramResource(s.memory));
 text('disk-value',resource(s.storage));
 text('uptime-value',available(s.uptime_seconds)?`${Math.floor(s.uptime_seconds/86400)} 天 ${Math.floor(s.uptime_seconds%86400/3600)} 时 ${Math.floor(s.uptime_seconds%3600/60)} 分`:'—');

 monitorStatus.textContent=s.errors.length?s.errors.join('；'):new Date(s.at).toLocaleTimeString();
 monitorStatus.classList.toggle('error',s.errors.length>0);
 const alert=document.getElementById('battery-alert');
 alert.hidden=!(available(s.battery_percent)&&s.battery_percent<=20&&s.charging==='Discharging');
 alert.textContent=alert.hidden?'':`低电量：${s.battery_percent}%`;

 initCardCharts();
 if(cpuChart)cpuChart.update(samples,s=>available(s.cpu_percent)?s.cpu_percent:null);
 if(ramChart)ramChart.update(samples,s=>getRamUsagePercent(s));
 drawTemperatures();
}

async function refreshMonitor(){
 if(loading)return;
 loading=true;
 const button=document.getElementById('monitor-refresh');
 button.disabled=true;
 const controller=new AbortController(),timer=setTimeout(()=>controller.abort(),10000);
 try{
  const response=await fetch('/air-api/monitor',{cache:'no-store',signal:controller.signal});
  if(!response.ok)throw new Error(response.status===401?'请重新登录':`读取失败（${response.status}）`);
  render(await response.json());
 }catch(error){
  monitorStatus.textContent=error.name==='AbortError'?'读取超时':error.message||'读取失败';
  monitorStatus.classList.add('error');
  for(const id of ['cpu-value','ram-value','disk-value','uptime-value'])text(id,'—');
  document.getElementById('battery-alert').hidden=true;
  initCardCharts();
  if(cpuChart)cpuChart.update([],()=>null);
  if(ramChart)ramChart.update([],()=>null);
  drawTemperatures(true);
 }finally{
  clearTimeout(timer);
  button.disabled=false;
  loading=false;
 }
}

/* 按需启动：在主界面里由 showSection 调一次；独立页面（没有 monitor-section）自动启动。
   轮询时会判断本 section 是否可见 —— 切到别的分页就不再请求。 */
window.airStart_monitor=function(){
 if(window.__airMonitorStarted)return;
 window.__airMonitorStarted=true;
 const btn=document.getElementById('monitor-refresh');
 if(btn)btn.addEventListener('click',refreshMonitor);
 refreshMonitor();
 setInterval(function(){
  const sec=document.getElementById('monitor-section');
  if((!sec||!sec.hidden)&&!document.hidden)refreshMonitor();
 },5000);
 document.addEventListener('visibilitychange',function(){if(!document.hidden)refreshMonitor();});
};
if(!document.getElementById('monitor-section'))window.airStart_monitor();
