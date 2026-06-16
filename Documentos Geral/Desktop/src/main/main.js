const { app, BrowserWindow, ipcMain, Menu, Tray, dialog } = require('electron');
const path = require('path');
const db = require('../../dados.json');
let janela;
let janelaModal;
let tray = null;

const criarJanela = () => {
    janela = new BrowserWindow({
        width: 1920,
        height: 1080,
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

// Mover a função para fora do app.whenReady()
const criarMenuPrincipal = (janelaDialog) => {
    const templateDoMenu = [
        {
            label: 'Ações do Sistema',
            submenu: [
                { label: 'Sair Imediatamente', role: 'quit', accelerator: 'CmdOrCtrl+Q' }
            ],
        },
        {
            label: 'Operações',
            submenu: [
                {
                    label: 'Remover Último Produto',
                    click: async () => {
                        // 1. Mostra o diálogo de confirmação
                        const resposta = await dialog.showMessageBox({
                            type: 'warning',
                            title: 'Remover Produto',
                            message: 'Tem certeza que deseja remover o último produto?',
                            detail: `Vai sumir: "${db[db.length - 1].nome}"`,
                            buttons: ['Sim, remover', 'Cancelar'],
                            defaultId: 1,
                            cancelId: 1
                        });

                        // 2. Decide com base no índice do botão clicado
                        if (resposta.response === 0) {
                            db.pop(); // Remove do array em memória
                            janela.webContents.send('atualizar-tela');
                        }
                    }
                }
            ]
        }
    ];

    // 2. Transforma a receita em um Menu de verdade
    const menuReal = Menu.buildFromTemplate(templateDoMenu);

    // 3. Aplica o menu à nossa aplicação inteira!
    Menu.setApplicationMenu(menuReal);
};

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
        db.push(dados);
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