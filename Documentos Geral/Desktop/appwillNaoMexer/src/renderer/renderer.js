const carregarTela = async () => {
    // 1. Liga para o Node e ESPERA o JSON chegar
    const listaUsuarios = await window.api.pedirUsuarios();
    
    // 2. Mapeia os dados para gerar colunas (col) com cards do Bootstrap
    const html = listaUsuarios.map(user => `
        <div class="col">
            <div class="card shadow-sm border-0 border-start border-4 border-warning h-100">
                <div class="card-body">
                    <h5 class="card-title">${user.nome}</h5>
                    <p class="card-text text-muted">${user.cargo}</p>
                </div>
            </div>
        </div>
    `).join("");

    // 3. Joga na tela dentro de um contêiner de linha (row)
    document.querySelector("#conteudo").innerHTML = `<div class="row row-cols-1 row-cols-md-3 g-4">${html}</div>`;
};

// 4. Executa a função assim que o script carregar!
carregarTela();