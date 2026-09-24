/* One system response supplies the overview, temperatures and battery details. */
(function(){
 const set=(id,value)=>{const el=document.getElementById(id);if(el)el.textContent=value;};
 const numeric=value=>value!==null&&value!==undefined&&value!==''&&Number.isFinite(Number(value));
 const number=(value,divisor,unit,digits=0)=>numeric(value)?(Number(value)/divisor).toFixed(digits)+unit:'--';
 const names={Charging:'充电中',Discharging:'放电中',Full:'已充满','Not charging':'未充电',Unknown:'未知',Good:'良好',Overheat:'过热',Dead:'失效',Overvoltage:'过压',Cold:'过冷',Normal:'正常',High:'高',Low:'低',Critical:'极低','Li-ion':'锂离子'};
 const label=value=>value===null||value===undefined||value===''?'--':names[String(value).trim()]||String(value);
 const binary=(value,yes,no)=>value===1||value==='1'?yes:value===0||value==='0'?no:'--';
 function row(body,title,value){const tr=document.createElement('tr');for(const text of [title,value]){const td=document.createElement('td');td.textContent=text;tr.appendChild(td);}body.appendChild(tr);}

 function formatDuration(seconds){
  if(!numeric(seconds)||seconds<=0)return '—';
  const hrs=Math.floor(seconds/3600);
  const mins=Math.round((seconds%3600)/60);
  if(hrs>0){
   return mins>0?`约 ${hrs} 小时 ${mins} 分钟`:`约 ${hrs} 小时`;
  }
  return mins>0?`约 ${mins} 分钟`:'即将完成';
 }

 window.airRenderSystem=function(data){
  const s=data||{};
  const cap=numeric(s.POWER_SUPPLY_CAPACITY)?Math.min(100,Math.max(0,Number(s.POWER_SUPPLY_CAPACITY))):null;
  const status=String(s.POWER_SUPPLY_STATUS||'').trim();
  set('batteryLevel',cap!==null?cap+'%':'--');
  set('chargeStatus',label(s.POWER_SUPPLY_STATUS));
  const visual=document.getElementById('battery-visual'),core=document.getElementById('battery-core');
  if(visual&&core){
   if(cap!==null){
    core.style.width=Math.max(6,cap)+'%';
    visual.classList.remove('is-charging','is-discharging','is-full','is-low');
    if(status==='Charging')visual.classList.add('is-charging');
    else if(status==='Discharging')visual.classList.add('is-discharging');
    else if(status==='Full')visual.classList.add('is-full');
    if(cap<=20)visual.classList.add('is-low');
    visual.setAttribute('title',`电量: ${cap}% · ${label(status)}`);
   }else{
    core.style.width='0%';
    visual.className='battery-visual';
   }
  }
  set('battery-temp',number(s.POWER_SUPPLY_TEMP,10,' °C',1));
  set('battery-health',label(s.POWER_SUPPLY_HEALTH));
  set('battery-voltage',number(s.POWER_SUPPLY_VOLTAGE_NOW,1000000,' V',3));
  set('currentNow',number(s.POWER_SUPPLY_CURRENT_NOW,1000,' mA'));
  set('battery-presence',binary(s.POWER_SUPPLY_PRESENT,'已检测','未检测')+' / '+binary(s.POWER_SUPPLY_ONLINE,'在线','离线'));
  const temps=Array.isArray(s.CPU_TEMP)?s.CPU_TEMP:[];
  set('temperature',number(temps[0],1000,' °C',1));

   // --- 充放电剩余时间预估 ---
   const estimateBanner=document.getElementById('battery-estimate-banner');
   const estimateIcon=document.getElementById('battery-estimate-icon');
   const estimateLabel=document.getElementById('battery-estimate-label');
   const estimateVal=document.getElementById('battery-estimate-val');
   if(estimateBanner&&estimateLabel&&estimateVal){
    estimateBanner.classList.remove('is-charging','is-discharging','is-full');
    if(status==='Charging'){
     estimateBanner.classList.add('is-charging');
     if(estimateIcon)estimateIcon.textContent='⚡';
     estimateLabel.textContent='预计充满剩余时间';
     const tFull=s.POWER_SUPPLY_TIME_TO_FULL_NOW;
     if(numeric(tFull)&&Number(tFull)>0){
      estimateVal.textContent=formatDuration(Number(tFull));
     }else{
      // 备用计算：(满充容量 - 当前电荷量) / 充电电流
      const chFull=Number(s.POWER_SUPPLY_CHARGE_FULL||s.POWER_SUPPLY_CHARGE_FULL_DESIGN);
      const chCur=Number(s.POWER_SUPPLY_CHARGE_COUNTER);
      const iNow=Math.abs(Number(s.POWER_SUPPLY_CURRENT_AVG||s.POWER_SUPPLY_CURRENT_NOW));
      if(chFull>0&&chCur>=0&&iNow>50000){
       const sec=Math.max(60,((chFull-chCur)/iNow)*3600);
       estimateVal.textContent=formatDuration(sec);
      }else{
       estimateVal.textContent='正在估算…';
      }
     }
    }else if(status==='Full'){
     estimateBanner.classList.add('is-full');
     if(estimateIcon)estimateIcon.textContent='✅';
     estimateLabel.textContent='电池供电状态';
     estimateVal.textContent='已充满 · 预计可用续航 约 7.5 小时';
    }else{
     // 未充电、放电中或外接供电但未充电状态，统一给出电池可用续航估算
     estimateBanner.classList.add('is-discharging');
     if(estimateIcon)estimateIcon.textContent='🔋';
     const isDisch = (status==='Discharging'||s.POWER_SUPPLY_ONLINE===0||s.POWER_SUPPLY_ONLINE==='0');
     estimateLabel.textContent=isDisch?'预计电池可用续航':'预计电池续航 (未充电)';
     const chCur=Number(s.POWER_SUPPLY_CHARGE_COUNTER);
     const iNow=Math.abs(Number(s.POWER_SUPPLY_CURRENT_AVG||s.POWER_SUPPLY_CURRENT_NOW));
     if(chCur>0&&iNow>50000){
      const sec=((chCur)/iNow)*3600;
      estimateVal.textContent=formatDuration(sec);
     }else if(cap!==null&&cap>0){
      // 粗略估算：SZ50 AIR 典型满电可用时长约 7.5 小时
      const totalSec=7.5*3600;
      const sec=(cap/100)*totalSec;
      estimateVal.textContent=formatDuration(sec);
     }else{
      estimateVal.textContent='正在估算…';
     }
    }
   }

  // --- 旁边新建卡片：渲染详细参数 ---
  const details=document.getElementById('battery-details');
  if(details){
   details.replaceChildren();
   const ttf=numeric(s.POWER_SUPPLY_TIME_TO_FULL_NOW)&&Number(s.POWER_SUPPLY_TIME_TO_FULL_NOW)>0?
    formatDuration(Number(s.POWER_SUPPLY_TIME_TO_FULL_NOW)):'--';
   for(const [title,key,divisor,unit,digits] of [
    ['平均电压','VOLTAGE_AVG',1000000,' V',3],
    ['平均电流','CURRENT_AVG',1000,' mA',0],
    ['当前电荷量','CHARGE_COUNTER',1000,' mAh',0],
    ['满充容量','CHARGE_FULL',1000,' mAh',0],
    ['设计容量','CHARGE_FULL_DESIGN',1000,' mAh',0],
    ['循环次数','CYCLE_COUNT',1,' 次',0],
    ['恒定充电电流','CONSTANT_CHARGE_CURRENT',1000,' mA',0],
    ['输入电流限制','INPUT_CURRENT_LIMIT',1000,' mA',0],
    ['充电控制限制','CHARGE_CONTROL_LIMIT',1000,' mA',0],
    ['最大电流','CURRENT_MAX',1000,' mA',0],
    ['最大电压','VOLTAGE_MAX',1000000,' V',3],
    ['设计最大电压','VOLTAGE_MAX_DESIGN',1000000,' V',3]
   ])row(details,title,number(s['POWER_SUPPLY_'+key],divisor,unit,digits));
   row(details,'预计充满剩余时间',ttf);
   row(details,'容量等级',label(s.POWER_SUPPLY_CAPACITY_LEVEL));
   row(details,'电池类型',label(s.POWER_SUPPLY_TECHNOLOGY));
  }
 };
 window.airSystemFailed=function(){window.airRenderSystem({});};
})();
