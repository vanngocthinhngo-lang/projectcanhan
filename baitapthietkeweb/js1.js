document.getElementById("userIcon").addEventListener("click", function () {
    let trans = document.getElementById("pageTransition");
    trans.classList.add("active");

    setTimeout(() => {
        window.location.href = "index1.html";
    }, 250);
});
