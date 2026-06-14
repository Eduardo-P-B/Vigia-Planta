const { app, BrowserWindow, ipcMain, Menu, Tray } = require('electron');
const path = require('path');
const db = require('../../dados.json');
let janela;
let janelaModal;
let tray = null;

const criarJanela = () => {
    janela = new BrowserWindow({
        width: 800,
        height: 600,
        frame: true,
        fullscreen: false,
        webPreferences: {
            preload: path.join(__dirname, 'preload.js')
        },
    });
    janela.loadFile('../renderer/home.html');
    // Abre o painel lateral do desenvolvedor
    janela.webContents.openDevTools();
};

app.whenReady().then(() => {
    criarJanela();
    ipcMain.on('abrir-modal-sucesso', () => {
        janelaModal = new BrowserWindow({
            width: 400,
            height: 200,
            parent: janela,
            modal: true,
            frame: false,
            webPreferences: {
                preload: path.join(__dirname, 'preload.js')
            },
        });
        janelaModal.loadFile('../renderer/sucessoCadastro.html')
    });


    ipcMain.on('fechar', () => {
        app.quit(); // Comando poderoso do Node/Electron para matar o processo
    });

    ipcMain.handle('pedir-plantas', () => {
        return db;
    });

    ipcMain.on('fechar-modal-sucesso', () => {
        if (janelaModal) {
            janelaModal.close();
        }
    });

    ipcMain.handle('salvar', (e, dados) => {
        // 1. Salva no banco de dados em memória (array)
        db.push(dados);

        // 2. ROTA 2! Devolve a confirmação de sucesso
        // (O Modal HTML vai receber e acionar o window.close())
        return true;
    });

    const templateDoMenu = [
        {
            label: 'Ações do Sistema',
            submenu: [
                { label: 'Mostrar Aviso', click: () => console.log("Aviso Clicado!") },
                { type: 'separator' },
                { label: 'Sair Imediatamente', role: 'quit', accelerator: 'CmdOrCtrl+Q' }
            ]
        }
    ];

    // 2. Transforma a receita em um Menu de verdade
    const menuReal = Menu.buildFromTemplate(templateDoMenu);

    // 3. Aplica o menu à nossa aplicação inteira!
    Menu.setApplicationMenu(menuReal);

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
                // Se a janela estiver escondida, mostre de novo!
                janela.show();
            }
        },
        { type: 'separator' },
        {
            label: 'Encerrar', click: () => {
                app.isQuitting = true; // Define uma flag para fechar de vez
                app.quit();
            }
        }

    ]);

    // 3. Intercepte o fechamento da janela
    janela.on('close', (event) => {
        if (!app.isQuitting) {
            event.preventDefault(); // Impede o fechamento real
            janela.hide();      // Apenas esconde a janela
        }
    });

    // Gruda esse menu no clique com o botão direito do ícone!
    tray.setContextMenu(menuDoTray);

});