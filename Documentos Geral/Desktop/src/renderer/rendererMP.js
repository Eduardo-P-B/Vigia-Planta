const carregarTela = async () => {
    // 1. Liga para o Node e ESPERA o JSON chegar
    const listaPlantas = await window.api.pedirPlantas();

    // 2. Mapeia os dados para gerar colunas (col) com cards do Bootstrap
    const html = listaPlantas.map(plant => `

        <div class="plant-item">
            <div class="plant-preview">
                <img src="images/${plant.imagem}"">
            </div>
            <h4>${plant.nome}</h4>
            <p>Nível de Umidade:</p>
            <div class="progress-bar">
                <div class="water-progress" style="width: ${plant.nivelUmidade}%"></div>
            </div>
            <p>Nível de luz Solar</p>
            <div class="progress-bar">
                <div class="sun-progress" style="width: ${plant.nivelLuz}%"></div>
            </div>
        </div>
    `).join("");

    // 3. Joga na tela dentro de um contêiner de linha (row)
    document.querySelector("#conteudo").innerHTML = html;
};

// 4. Executa a função assim que o script carregar!
carregarTela();

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