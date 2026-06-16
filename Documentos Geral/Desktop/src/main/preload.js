const { contextBridge, ipcRenderer } = require('electron');
// "Exponha no Mundo Principal (HTML)"
contextBridge.exposeInMainWorld('api', {
    fecharApp: () => ipcRenderer.send('fechar'),



    // Eu crio um comando chamado "enviarMensagem"
    // que o HTML vai poder usar!
    enviarMensagem: (texto) => {
        // Envia via Rádio IPC para o Main
        ipcRenderer.send('canal-mensagem', texto);
    },

    pedirPlantas: () => {
        return ipcRenderer.invoke('pedir-plantas');
    },

    abrirModalCadastro: () => {
        ipcRenderer.send('abrir-modal-cadastro');
    },

    fecharModalCadastro: () => {
        ipcRenderer.send('fechar-modal-cadastro');
    },

    salvarPlanta: (dados) => ipcRenderer.invoke('salvar', dados),

    onAtualizarTela: (funcaoCallback) => ipcRenderer.on('atualizar-tela', funcaoCallback),

    pedirDeletarPlanta: (id) => {
    return ipcRenderer.invoke('deletar-planta', id);
}
});