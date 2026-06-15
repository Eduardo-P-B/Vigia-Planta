const form = document.querySelector("#cadastro-planta-form");


document.querySelector("#cadastro-planta-form").addEventListener("submit", async(e) => {
    e.preventDefault();

    const dados = Object.fromEntries(new FormData(e.target));
    dados.nivelUmidade = 100;
    dados.nivelLuz = 100;
    dados.imagem = null;

    if (!dados.imagem){
        dados.imagem = "plantaPadrao.png";
    }

    console.log(dados);

    const salvarSucesso = await window.api.salvarPlanta(dados);
    if  (salvarSucesso) {
        window.close();
    }

    listaPlantas.push(dados);

    desenharTela(listaPlantas);


});
