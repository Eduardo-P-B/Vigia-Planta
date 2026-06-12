let listaPlantas = [];

const form = document.querySelector("#cadastro-planta-form");

const desenharTela = (listaParaDesenhar) => {

    const html = listaParaDesenhar.map(plant => {

        let classeCard = "";

        if (plant.nivelUmidade <= 20 || plant.nivelLuz <= 20) {
            classeCard = "urgent";
        }
        else if (plant.nivelUmidade <= 40 || plant.nivelLuz <= 40) {
            classeCard = "warning";
        }

        return `
            <div class="plant-item ${classeCard}">
                <div class="plant-preview">
                    <img src="images/${plant.imagem}" alt="${plant.nome}">
                </div>

                <h4>${plant.nome}</h4>

                <p>Nível de Umidade:</p>
                <div class="progress-bar">
                    <div class="water-progress" style="width:${plant.nivelUmidade}%"></div>
                </div>

                <p>Nível de luz Solar:</p>
                <div class="progress-bar">
                    <div class="sun-progress" style="width:${plant.nivelLuz}%"></div>
                </div>

                <p>Localização: ${plant.localizacao || "Não informada"}</p>
            </div>
        `;
    }).join("");

    document.querySelector("#conteudo").innerHTML = html;
};

const iniciarApp = async () => {
    listaPlantas = await window.api.pedirPlantas();
    desenharTela(listaPlantas);
};

iniciarApp(); // Dá a partida no programa

const barraBusca = document.querySelector("#inputBusca");

barraBusca.addEventListener("input", () => {

    const textoDigitado = barraBusca.value.toLowerCase();

    const listaFiltrada = listaPlantas.filter(plant => {
        return (
            plant.nome.toLowerCase().includes(textoDigitado) ||
            plant.localizacao.toLowerCase().includes(textoDigitado)
        );
    });

    desenharTela(listaFiltrada);

});


form.addEventListener("submit", (e) => {
    e.preventDefault();

    const extrator = new FormData(form);
    const novaPlanta = Object.fromEntries(extrator);

    console.log(novaPlanta);

    novaPlanta.nivelUmidade = 100;
    novaPlanta.nivelLuz = 100;
    novaPlanta.imagem = "plantaPadrao.png";

    listaPlantas.push(novaPlanta);

    desenharTela(listaPlantas);

    form.reset();
});

const novaPlantaBtn = document.getElementById('nova-planta-btn');
const heroCard = document.getElementById('hero-card');
const cadCard = document.getElementById('cad-planta');
const voltarToHeroBtn = document.getElementById('voltar-home-btn');

let showHero = true;

const botao = document.querySelector("#sair-btn");
if (botao) {
    botao.addEventListener("click", () => {
        window.api.fecharApp();
    });
}

function toggleCad() {
    if (showHero === true) {
        heroCard.classList.add('hidden-card');
        cadCard.classList.remove('hidden-card');
        showHero = false;
    } else {
        cadCard.classList.add('hidden-card');
        heroCard.classList.remove('hidden-card');
        showHero = true;
    }
}

if (novaPlantaBtn) novaPlantaBtn.addEventListener('click', toggleCad);
if (voltarToHeroBtn) voltarToHeroBtn.addEventListener('click', toggleCad);