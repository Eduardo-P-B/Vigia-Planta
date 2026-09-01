<?php

session_start(); 

    require "config.php";

?>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Configurar sensores · VIGIA</title>
  <!-- Font Awesome (ícones) -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
  <style>
    /* ===== RESET / BASE ===== */
    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
    }

    body {
      font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
      background: linear-gradient(135deg, #8BC34A 0%, #40a744 100%);
      min-height: 100vh;
      display: flex;
      align-items: center;
      justify-content: center;
      padding: 20px;
      position: relative;
    }

    /* ===== DECORAÇÃO DE FUNDO ===== */
    body::before {
      content: '';
      position: absolute;
      top: 0;
      left: 0;
      right: 0;
      bottom: 0;
      background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1440 320"><path fill="rgba(255,255,255,0.1)" fill-opacity="1" d="M0,96L48,112C96,128,192,160,288,160C384,160,480,128,576,122.7C672,117,768,139,864,154.7C960,171,1056,181,1152,165.3C1248,149,1344,107,1392,85.3L1440,64L1440,320L1392,320C1344,320,1248,320,1152,320C1056,320,960,320,864,320C768,320,672,320,576,320C480,320,384,320,288,320C192,320,96,320,48,320L0,320Z"></path></svg>') no-repeat bottom;
      background-size: cover;
      opacity: 0.25;
      pointer-events: none;
    }

    /* ===== CONTAINER PRINCIPAL ===== */
    .container {
      width: 100%;
      max-width: 750px;
      position: relative;
      z-index: 1;
    }

    /* ===== CARD ===== */
    .sensor-card {
      background: rgba(241, 245, 236, 0.95);
      backdrop-filter: blur(10px);
      border-radius: 30px;
      padding: 40px 35px;
      box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.25);
      transition: transform 0.3s ease, box-shadow 0.3s ease;
      position: relative;
      overflow: hidden;
    }

    .sensor-card:hover {
      transform: translateY(-5px);
      box-shadow: 0 30px 60px -12px rgba(0, 0, 0, 0.3);
    }

    /* ===== CABEÇALHO ===== */
    .header-section {
      display: flex;
      align-items: center;
      gap: 18px;
      margin-bottom: 32px;
    }

    .header-icon {
      width: 65px;
      height: 65px;
      background: linear-gradient(135deg, #4CAF50, #186d1d);
      border-radius: 20px;
      display: flex;
      align-items: center;
      justify-content: center;
      color: white;
      font-size: 30px;
      animation: pulse 2s infinite;
      flex-shrink: 0;
    }

    .header-title {
      font-size: 28px;
      font-weight: 800;
      background: linear-gradient(135deg, #4CAF50, #186d1d);
      -webkit-background-clip: text;
      -webkit-text-fill-color: transparent;
      background-clip: text;
    }

    .header-sub {
      font-size: 15px;
      color: #555;
      font-weight: 500;
      margin-top: 2px;
    }

    .header-sub i {
      color: #4CAF50;
      margin-right: 6px;
    }

    /* ===== GRID DE OPCÕES ===== */
    .options-grid {
      display: grid;
      grid-template-columns: repeat(3, 1fr);
      gap: 18px;
      margin: 10px 0 25px;
    }

    /* ===== CADA OPÇÃO (agora como div) ===== */
    .sensor-option {
      background: white;
      border-radius: 20px;
      padding: 28px 16px 22px;
      text-align: center;
      border: 3px solid #e8eeea;
      transition: all 0.3s ease;
      cursor: pointer;
      box-shadow: 0 4px 12px rgba(0,0,0,0.03);
      position: relative;
      user-select: none;
    }

    .sensor-option:hover {
      transform: translateY(-5px);
      border-color: #a5d6a7;
      box-shadow: 0 12px 28px -8px rgba(76, 175, 80, 0.2);
    }

    /* Quando selecionado - fica verde! */
    .sensor-option.selected {
      border-color: #4CAF50;
      background: #f0f9f0;
      box-shadow: 0 0 0 4px rgba(76, 175, 80, 0.12), 0 8px 20px -6px rgba(76, 175, 80, 0.25);
      transform: translateY(-3px);
    }

    /* Esconde o checkbox real */
    .sensor-option input[type="checkbox"] {
      display: none;
    }

    .option-icon {
      font-size: 42px;
      color: #2E7D32;
      margin-bottom: 12px;
      display: block;
      transition: transform 0.3s ease;
    }

    .sensor-option.selected .option-icon {
      transform: scale(1.1);
    }

    .option-label {
      font-weight: 700;
      color: #1e2b1e;
      font-size: 16px;
      display: block;
      margin-bottom: 5px;
    }

    .option-desc {
      font-size: 13px;
      color: #6b7a6b;
      line-height: 1.3;
    }

    /* Check-mark (ícone de seleção) */
    .check-mark {
      position: absolute;
      top: 12px;
      right: 14px;
      color: #4CAF50;
      font-size: 22px;
      opacity: 0;
      transition: opacity 0.25s ease, transform 0.25s ease;
      transform: scale(0.7);
    }

    .sensor-option.selected .check-mark {
      opacity: 1;
      transform: scale(1);
    }

    /* ===== BOTÃO DE AÇÃO ===== */
    .action-btn {
      width: 100%;
      padding: 18px;
      background: linear-gradient(135deg, #4CAF50, #186d1d);
      border: none;
      border-radius: 16px;
      color: white;
      font-size: 18px;
      font-weight: 700;
      cursor: pointer;
      transition: all 0.3s ease;
      display: flex;
      align-items: center;
      justify-content: center;
      gap: 12px;
      margin-top: 8px;
    }

    .action-btn:hover {
      transform: translateY(-3px);
      box-shadow: 0 12px 28px rgba(76, 175, 80, 0.35);
    }

    .action-btn:active {
      transform: translateY(0);
    }

    .action-btn i {
      font-size: 20px;
    }

    /* ===== FEEDBACK ===== */
    #feedback {
      margin-top: 20px;
      font-size: 15px;
      font-weight: 600;
      text-align: center;
      min-height: 28px;
      padding: 10px;
      border-radius: 14px;
      transition: all 0.2s;
    }

    #feedback.success {
      color: #1e6b1e;
      background: rgba(76, 175, 80, 0.15);
    }

    #feedback.error {
      color: #c0392b;
      background: rgba(231, 76, 60, 0.12);
    }

    #feedback.info {
      color: #2c3e50;
      background: rgba(52, 152, 219, 0.10);
    }

    /* ===== ANIMAÇÕES ===== */
    @keyframes pulse {
      0%, 100% { transform: scale(1); }
      50% { transform: scale(1.05); }
    }

    /* ===== RESPONSIVIDADE ===== */
    @media (max-width: 700px) {
      .sensor-card { padding: 30px 22px; }
      .options-grid { grid-template-columns: 1fr 1fr; }
    }

    @media (max-width: 480px) {
      .sensor-card { padding: 24px 16px; }
      .options-grid { grid-template-columns: 1fr; gap: 14px; }
      .header-section { flex-direction: column; text-align: center; }
      .header-icon { width: 55px; height: 55px; font-size: 24px; }
      .header-title { font-size: 22px; }
      .option-icon { font-size: 34px; }
      .action-btn { font-size: 16px; padding: 15px; }
    }

    /* ===== DARK MODE ===== */
    @media (prefers-color-scheme: dark) {
      .sensor-card {
        background: rgba(30, 30, 30, 0.95);
      }
      .header-sub { color: #b0b0b0; }
      .sensor-option {
        background: #2a2a2a;
        border-color: #3d4a3d;
      }
      .sensor-option.selected {
        background: #1f3a1f;
        border-color: #4CAF50;
      }
      .option-label { color: #e0e8e0; }
      .option-desc { color: #9aaa9a; }
      #feedback.info {
        color: #b0c4de;
        background: rgba(52, 152, 219, 0.08);
      }
      #feedback.success {
        color: #8bc34a;
        background: rgba(76, 175, 80, 0.15);
      }
      #feedback.error {
        color: #e74c3c;
        background: rgba(231, 76, 60, 0.12);
      }
    }
  </style>
</head>
<body>

<div class="container">
  <div class="sensor-card">

    <!-- Cabeçalho -->
    <div class="header-section">
      <div class="header-icon">
        <i class="fas fa-microchip"></i>
      </div>
      <div>
        <div class="header-title">Sensores Inteligentes</div>
        <div class="header-sub"><i class="fas fa-leaf"></i>Selecione os módulos para seu VIGIA</div>
      </div>
    </div>

    <!-- FORMULÁRIO -->
    <form id="sensorForm">
      <!-- Grid com 3 opções de sensores -->
      <div class="options-grid" id="optionsGrid">

        <!-- 1: PAINEL SOLAR + BATERIA -->
        <div class="sensor-option" data-value="solar" onclick="toggleSensor(this)">
          <input type="checkbox" name="sensores" value="solar">
          <span class="check-mark"><i class="fas fa-check-circle"></i></span>
          <span class="option-icon"><i class="fas fa-solar-panel"></i></span>
          <span class="option-label">Painel solar</span>
          <span class="option-desc">+ bateria recarregável</span>
        </div>

        <!-- 2: MEDIDOR DE UMIDADE DO SOLO -->
        <div class="sensor-option" data-value="umidade" onclick="toggleSensor(this)">
          <input type="checkbox" name="sensores" value="umidade">
          <span class="check-mark"><i class="fas fa-check-circle"></i></span>
          <span class="option-icon"><i class="fas fa-tint"></i></span>
          <span class="option-label">Umidade do solo</span>
          <span class="option-desc"></span>
        </div>

        <!-- 3: MEDIDOR DE TEMPERATURA -->
        <div class="sensor-option" data-value="temperatura" onclick="toggleSensor(this)">
          <input type="checkbox" name="sensores" value="temperatura">
          <span class="check-mark"><i class="fas fa-check-circle"></i></span>
          <span class="option-icon"><i class="fas fa-thermometer-half"></i></span>
          <span class="option-label">Temperatura</span>
          <span class="option-desc"></span>
        </div>

      </div>

      <!-- Botão de envio -->
      <button type="button" class="action-btn" id="submitBtn">
        <i class="fas fa-check-circle"></i> Salvar configuração
      </button>
    </form>

    <!-- Feedback -->
    <div id="feedback"></div>

  </div>
</div>

<script>
  // ================================================================
  // FUNÇÃO GLOBAL: toggleSensor (chamada pelo onclick da div)
  // ================================================================
  function toggleSensor(element) {
    // Encontra o checkbox dentro da div
    const checkbox = element.querySelector('input[type="checkbox"]');
    
    // Inverte o estado do checkbox
    checkbox.checked = !checkbox.checked;
    
    // Atualiza a classe visual (verde/branco)
    if (checkbox.checked) {
      element.classList.add('selected');
    } else {
      element.classList.remove('selected');
    }
    
    // Limpa feedback anterior
    const feedback = document.getElementById('feedback');
    feedback.textContent = '';
    feedback.className = '';
  }

  // ================================================================
  // INICIALIZAÇÃO: garantir que todos os sensores comecem desmarcados
  // ================================================================
  document.addEventListener('DOMContentLoaded', function() {
    const options = document.querySelectorAll('.sensor-option');
    options.forEach(opt => {
      opt.classList.remove('selected');
      const cb = opt.querySelector('input[type="checkbox"]');
      if (cb) cb.checked = false;
    });
    
    const feedback = document.getElementById('feedback');
    feedback.textContent = '💡 Clique em um sensor para ativá-lo';
    feedback.className = 'info';
  });

  // ================================================================
  // BOTÃO "SALVAR"
  // ================================================================
  document.getElementById('submitBtn').addEventListener('click', function() {
    const options = document.querySelectorAll('.sensor-option');
    const selected = [];
    
    options.forEach(opt => {
      const cb = opt.querySelector('input[type="checkbox"]');
      if (cb && cb.checked) {
        const nome = opt.querySelector('.option-label')?.textContent || cb.value;
        selected.push(nome);
      }
    });

    const feedback = document.getElementById('feedback');

    if (selected.length === 0) {
      feedback.textContent = '⚠️ Selecione pelo menos um sensor.';
      feedback.className = 'error';
      return;
    }

    // Exibe os sensores selecionados
    const nomes = selected.join(', ');
    feedback.innerHTML = `✅ Sensores ativos: <strong>${nomes}</strong>`;
    feedback.className = 'success';
  });

  // ================================================================
  // TAMBÉM PERMITE CLIQUE DIRETO NO CHECKBOX (por segurança)
  // ================================================================
  document.querySelectorAll('.sensor-option input[type="checkbox"]').forEach(cb => {
    cb.addEventListener('change', function() {
      const parent = this.closest('.sensor-option');
      if (this.checked) {
        parent.classList.add('selected');
      } else {
        parent.classList.remove('selected');
      }
      const feedback = document.getElementById('feedback');
      feedback.textContent = '';
      feedback.className = '';
    });
  });
</script>

</body>
</html>