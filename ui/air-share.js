'use strict';
function wifiQRPayload(data){
 if(data.wifi_enabled!=='on'||typeof data.wifi_ssid!=='string'||!data.wifi_ssid||data.wifi_ssid==='unknown')throw new Error('热点尚未开启，或名称暂不可用');
 const encryption=String(data.wifi_encryption||'').toLowerCase(),open=encryption==='none';if(!open&&!['wpa','wpa2'].includes(encryption))throw new Error('暂不支持当前加密方式的二维码');
 if(!open&&(typeof data.wifi_key!=='string'||!data.wifi_key||data.wifi_key==='unknown'))throw new Error('热点密码暂不可用');
 const escape=value=>value.replace(/[\\;,:\"]/g,'\\$&');
 return `WIFI:T:${open?'nopass':'WPA'};S:${escape(data.wifi_ssid)};${open?'':`P:${escape(data.wifi_key)};`};`;
}
(function(){
 const button=document.getElementById('share-wifi');if(!button)return;
 const dialog=document.createElement('dialog');dialog.className='share-dialog';dialog.setAttribute('aria-labelledby','share-title');
 const title=document.createElement('h2');title.id='share-title';title.textContent='分享 Wi-Fi';const status=document.createElement('p');status.setAttribute('role','status');const code=document.createElement('div');code.className='qr-code';const hint=document.createElement('p');hint.textContent='含热点密码 · 2 分钟后关闭';const close=document.createElement('button');close.type='button';close.textContent='关闭';dialog.append(title,status,code,hint,close);document.body.append(dialog);
 let controller,expiry,generation=0;
 function clear(){generation++;if(controller)controller.abort();clearTimeout(expiry);code.replaceChildren();status.textContent='';button.disabled=false;}
 close.addEventListener('click',()=>{clear();dialog.close();});dialog.addEventListener('close',clear);dialog.addEventListener('cancel',clear);document.addEventListener('visibilitychange',()=>{if(document.hidden&&dialog.open)dialog.close();});
 button.addEventListener('click',async()=>{clear();const requestGeneration=generation;dialog.showModal();button.disabled=true;status.textContent='正在读取热点…';controller=new AbortController();const timer=setTimeout(()=>controller.abort(),10000);try{const response=await fetch('/cgi-bin/traffic.cgi?action=get_wifi',{cache:'no-store',signal:controller.signal});if(!response.ok)throw new Error('读取热点失败，请刷新后重试');const data=await response.json();if(!dialog.open||requestGeneration!==generation)return;const qr=qrcode(0,'M');qr.addData(wifiQRPayload(data),'Byte');qr.make();code.innerHTML=qr.createSvgTag({cellSize:4,margin:16,scalable:true});code.querySelector('svg').setAttribute('aria-label','Wi-Fi 连接二维码');status.textContent=data.wifi_ssid;expiry=setTimeout(()=>dialog.close(),120000);}catch(error){if(dialog.open&&requestGeneration===generation)status.textContent=error.name==='AbortError'?'读取超时，请关闭后重试':error.message;}finally{clearTimeout(timer);}});
})();
