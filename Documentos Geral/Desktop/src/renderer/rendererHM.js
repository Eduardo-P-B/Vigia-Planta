const botao = document.querySelector("#sair-btn");
botao.addEventListener("click", () => {
    window.api.sairApp();
});