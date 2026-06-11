const { app, BrowserWindow, ipcMain } = require('electron');
const path = require('path');
const db = require('../../dados.json');

const criarJanela = () => {
    const janela = new BrowserWindow({
        width: 800,
        height: 600,
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


app.whenReady().then(() => {
    criarJanela();

    ipcMain.on('fechar', () => {
        console.log('Fechando a aplicativo...');
        app.quit(); // Comando poderoso do Node/Electron para matar o processo
    });

    ipcMain.handle('pedir-plantas', () => {
        return db;
    });
});