const { app, BrowserWindow, ipcMain, Menu, Tray, dialog } = require('electron');
const path = require('path');
const fs = require('fs');
const caminhoDB = path.join(__dirname, '../../dados.json');
let db = JSON.parse(
    fs.readFileSync(caminhoDB, 'utf-8')
);
let janela;
let janelaModal;
let tray = null;

const criarJanela = () => {
    janela = new BrowserWindow({
        width: 1920,
        height: 1080,
        frame: false,
        fullscreen: true,
        webPreferences: {
            preload: path.join(__dirname, 'preload.js')
        },
    });
    janela.loadFile('../renderer/home.html');
    // Abre o painel lateral do desenvolvedor
    janela.webContents.openDevTools();
};

// Mover a função para fora do app.whenReady()
const criarMenuPrincipal = (janelaDialog) => {
    const templateDoMenu = [
        {
            label: 'Ações do Sistema',
            submenu: [
                { label: 'Sair Imediatamente', role: 'quit', accelerator: 'CmdOrCtrl+Q' }
            ],
        },
    ];

    // 2. Transforma a receita em um Menu de verdade
    const menuReal = Menu.buildFromTemplate(templateDoMenu);

    // 3. Aplica o menu à nossa aplicação inteira!
    Menu.setApplicationMenu(menuReal);
};

function salvarDB() {
    fs.writeFileSync(
        caminhoDB,
        JSON.stringify(db, null, 2),
        'utf-8'
    );
}

app.whenReady().then(() => {
    criarJanela();

    ipcMain.on('abrir-modal-cadastro', () => {
        janelaModal = new BrowserWindow({
            width: 800,
            height: 540,
            parent: janela,
            modal: true,
            frame: false,
            resizable: false,
            transparent: true,
            backgroundColor: '#00000000',
            webPreferences: {
                preload: path.join(__dirname, 'preload.js')
            },
        });
        janelaModal.loadFile('../renderer/cadastroPlanta.html')
    });

    ipcMain.on('fechar', () => {
        app.quit();
    });

    ipcMain.handle('pedir-plantas', () => {
        return db;
    });

    ipcMain.on('fechar-modal-cadastro', () => {
        if (janelaModal) {
            janelaModal.close();
        }
    });

    ipcMain.handle('salvar', (e, dados) => {

        const maiorId = db.length > 0
            ? Math.max(...db.map(planta => planta.id))
            : 0;

        const novaPlanta = {
            id: maiorId + 1,
            ...dados
        };

        db.push(novaPlanta);

        salvarDB();

        janela.webContents.send('atualizar-tela');

        return true;

    });

    // CHAME a função aqui!
    criarMenuPrincipal(janela);

    // O caminho da imagem que você baixou
    const iconeCaminho = path.join(__dirname, 'images/icone.png');

    // Cria o ícone no cantinho do relógio
    tray = new Tray(iconeCaminho);

    // Define a mensagem que aparece ao passar o mouse por cima
    tray.setToolTip('Vigia PLanta');

    const menuDoTray = Menu.buildFromTemplate([
        {
            label: 'Abrir Painel',
            click: () => {
                janela.show();
            }
        },
        { type: 'separator' },
        {
            label: 'Encerrar', click: () => {
                app.isQuitting = true;
                app.quit();
            }
        }
    ]);

    // Intercepte o fechamento da janela
    janela.on('close', (event) => {
        if (!app.isQuitting) {
            event.preventDefault();
            janela.hide();
        }
    });

    tray.setContextMenu(menuDoTray);
});

ipcMain.handle('deletar-planta', async (e, id) => {
    const planta = db.find(p => p.id === id);
    const respostaDeletar = await dialog.showMessageBox({
        type: 'warning',
        title: 'Remover Planta',
        message: `Tem certeza que deseja excluir "${planta.nome}"?`,
        buttons: ['Sim, remover', 'Cancelar'],
        defaultId: 1,
        cancelId: 1
    });

    // 1. Mostra o diálogo de confirmação
    // 2. Decide com base no índice do botão clicado
    if (respostaDeletar.response === 0) {
        const indice = db.findIndex(p => p.id === id);
        if (indice !== -1) {
            db.splice(indice, 1);
            salvarDB();
        }
    }
    return db;
});

ipcMain.on('sair-app', async () => {
    const respostaDeletar = await dialog.showMessageBox({
        type: 'warning',
        title: 'Fechar app',
        message: `Quer mesmo sair?`,
        buttons: ['Sim, sair', 'Encerrar Sessão'],
        defaultId: 1,
        cancelId: 1
    });
    if (respostaDeletar.response === 0) {
        app.isQuitting = true;
        app.quit(app.isQuitting);
    }
});