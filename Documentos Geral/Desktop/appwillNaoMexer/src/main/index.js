const { app, BrowserWindow, ipcMain } = require('electron');
const path = require('path');
const db = require('../../dados.json');

app.whenReady().then(() => {
    const janela = new BrowserWindow({
        width: 1000, height: 700,
        webPreferences: {
            // Preload está na MESMA pasta que o index.js
            preload: path.join(__dirname, 'preload.js')

        },
    });

    // Volta uma pasta (sai de 'main', entra em 'renderer')
    janela.loadFile(path.join(__dirname, '../renderer/index.html'));
    janela.webContents.openDevTools();

    ipcMain.handle('pedir-usuarios', () => {
        return db;
    });
});