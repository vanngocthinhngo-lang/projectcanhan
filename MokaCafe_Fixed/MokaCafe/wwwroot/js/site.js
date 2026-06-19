let modalSoLuong=1;
document.addEventListener('click',function(e){if(e.target.classList.contains('option-chip')){const g=e.target.dataset.group;document.querySelectorAll('[data-group="'+g+'"]').forEach(c=>c.classList.remove('active'));e.target.classList.add('active');}});
function doiSoLuong(d){modalSoLuong=Math.max(1,modalSoLuong+d);const el=document.getElementById('modalSoLuong');if(el)el.textContent=modalSoLuong;}
function themVaoGio(){
  const id=parseInt(document.getElementById('modalMonId')?.value||'0');if(!id)return;
  const sugar=document.querySelector('[data-group="sugar"].active')?.dataset.val||'50%';
  const ice=document.querySelector('[data-group="ice"].active')?.dataset.val||'Ít đá';
  const note=document.getElementById('modalGhiChu')?.value||'';
  const token=document.querySelector('input[name="__RequestVerificationToken"]')?.value||'';
  fetch('/Home/ThemGioHang',{method:'POST',headers:{'Content-Type':'application/json','RequestVerificationToken':token},body:JSON.stringify({maMon:id,soLuong:modalSoLuong,mucDuong:sugar,mucDa:ice,ghiChu:note})})
  .then(r=>r.json()).then(data=>{if(data.ok){const b=document.getElementById('cartCount');if(b)b.textContent=data.soLuong;const m=bootstrap.Modal.getInstance(document.getElementById('modalMon'));if(m)m.hide();showToast('🛒 Đã thêm vào giỏ hàng!');}}).catch(()=>{});
}
function showToast(msg){let t=document.getElementById('mokaToast');if(!t){t=document.createElement('div');t.id='mokaToast';t.style.cssText='position:fixed;bottom:24px;right:24px;background:#3D1C0A;color:#fff;padding:12px 22px;border-radius:12px;font-size:13px;font-weight:600;z-index:9999;transition:all .3s;opacity:0;transform:translateY(20px)';document.body.appendChild(t);}t.textContent=msg;setTimeout(()=>{t.style.opacity='1';t.style.transform='translateY(0)'},10);setTimeout(()=>{t.style.opacity='0';t.style.transform='translateY(20px)'},3000);}
document.addEventListener('DOMContentLoaded',()=>{
  const m=document.getElementById('modalMon');
  if(m)m.addEventListener('show.bs.modal',()=>{modalSoLuong=1;const s=document.getElementById('modalSoLuong');if(s)s.textContent='1';const n=document.getElementById('modalGhiChu');if(n)n.value='';document.querySelectorAll('[data-group="sugar"]').forEach(c=>c.classList.toggle('active',c.dataset.val==='50%'));document.querySelectorAll('[data-group="ice"]').forEach(c=>c.classList.toggle('active',c.dataset.val==='Ít đá'));});
  document.querySelectorAll('.pay-radio').forEach(r=>{r.addEventListener('change',()=>{document.querySelectorAll('.pay-method-card').forEach(c=>c.classList.remove('active'));r.closest('.pay-method-label')?.querySelector('.pay-method-card')?.classList.add('active');});});
  document.querySelector('.pay-radio:checked')?.closest('.pay-method-label')?.querySelector('.pay-method-card')?.classList.add('active');
});
