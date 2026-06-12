const class11b2a = document.querySelector(".class11b2a");
const class11b2c = document.querySelector(".class11b2c");
const class11b2b = document.querySelector(".class11b2b");
let quantity = 1;
class11b2c.addEventListener("click", () =>{
    quantity++;
    class11b2b.innerText = quantity;
});
class11b2a.addEventListener("click", () =>{
    if(quantity >1){
        quantity --;
        class11b2b.innerText = quantity;
    }
});
const sizeButtons = document.querySelectorAll(".class11b1 button");
sizeButtons.forEach(btn => {
    btn.addEventListener("click", () => {
        sizeButtons.forEach(b => b.classList.remove("size-active"));
        btn.classList.add("size-active");
    });
});
