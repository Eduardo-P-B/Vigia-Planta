const { contextBridge, ipcRenderer } = require('electron');

contextBridge.exposeInMainWorld('api', {
    // Cria o atalho para o Front-end
    pedirUsuarios: () => {
        return ipcRenderer.invoke('pedir-usuarios');
    }
});