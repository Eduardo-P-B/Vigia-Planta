<?php
require "dependencias/autenticacao.php";
require "dependencias/config.php";
require_once __DIR__ . '/dependencias/imagens.php';

$nomeU = $_SESSION['nome'] ?? 'Usuário';
$iniciaisUsuario = iniciaisAvatar($nomeU);

// O pedido ainda não é salvo em uma tabela própria. O servidor valida os módulos,
// calcula o total com o catálogo fixo e prepara a confirmação temporária para a home.
if ($_SERVER['REQUEST_METHOD'] === 'POST' && ($_POST['acao'] ?? '') === 'finalizar_pedido') {
    $catalogo = [
        'solar' => ['nome' => 'Módulo solar', 'precoCentavos' => 19000],
        'temperatura' => ['nome' => 'Módulo de temperatura', 'precoCentavos' => 1000],
        'umidade' => ['nome' => 'Módulo de umidade', 'precoCentavos' => 1000],
    ];
    $modulosRecebidos = $_POST['modulos'] ?? [];
    $modulosEscolhidos = [];
    if (is_array($modulosRecebidos)) {
        foreach ($modulosRecebidos as $modulo) {
            if (is_string($modulo) && isset($catalogo[$modulo])) {
                $modulosEscolhidos[$modulo] = $catalogo[$modulo];
            }
        }
    }

    if (!$modulosEscolhidos) {
        $_SESSION['erro_pedido'] = 'Escolha pelo menos um módulo para finalizar o pedido.';
        header('Location: lojinha.php');
        exit;
    }

    $nomesItens = ['Dispositivo base'];
    $totalCentavos = 9000;
    foreach ($modulosEscolhidos as $modulo) {
        $nomesItens[] = $modulo['nome'];
        $totalCentavos += $modulo['precoCentavos'];
    }
    $_SESSION['pedido_concluido'] = [
        'itens' => implode(', ', $nomesItens),
        'total' => 'R$ ' . number_format($totalCentavos / 100, 2, ',', '.'),
    ];
    header('Location: home.php');
    exit;
}

$erroPedido = $_SESSION['erro_pedido'] ?? '';
unset($_SESSION['erro_pedido']);
?>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Lojinha · Vigia Planta</title>
  <link rel="icon" href="images/sempre/favicon.png" type="image/png">
  <link rel="stylesheet" href="CSS/style-home.css">
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
  <!-- Font Awesome (ícones) -->
  <link rel="stylesheet" href="CSS/fontawesome/all.min.css">
    <link rel="stylesheet" href="CSS/fontawesome/v4-shims.min.css">
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
      display: block;
      padding: 0;
      overflow-x: hidden;
      position: relative;
    }

    .shop-main {
      display: flex;
      justify-content: center;
      align-items: flex-start;
      width: 100%;
      min-height: calc(100vh - 90px);
      padding: 30px 20px;
      position: relative;
      z-index: 1;
    }

    .shop-main .container { margin: 0 auto; }

    @media (max-width: 767px) {
      .shop-main { padding: 18px 12px; }
      .sensor-card { padding: 28px 18px; border-radius: 22px; }
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
      margin-bottom: 28px;
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

    /* ===== TÍTULO DA SEÇÃO DE MÓDULOS ===== */
    .section-label {
      font-size: 14px;
      font-weight: 700;
      color: #555;
      margin: 26px 0 0 4px;
    }

    .section-label i {
      color: #4CAF50;
      margin-right: 6px;
    }

    .section-label small {
      font-weight: 500;
      color: #6b7a6b;
      margin-left: 4px;
    }

    /* ===== GRID DE MÓDULOS ===== */
    .options-grid {
      display: grid;
      grid-template-columns: repeat(3, 1fr);
      gap: 18px;
      margin: 12px 0 22px;
    }

    /* ===== CADA ITEM (div clicável) ===== */
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
      display: block;
    }

    .option-price {
      font-size: 20px;
      font-weight: 800;
      color: #2E7D32;
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

    /* ===== MÓDULOS (opcionais) ===== */
    .modulo {
      display: flex;
      flex-direction: column;
      align-items: center;
    }

    .modulo:focus-visible {
      outline: 3px solid #4CAF50;
      outline-offset: 3px;
    }

    /* Preço sempre alinhado na base do card, mesmo sem descrição */
    .modulo .option-price {
      margin-top: auto;
      padding-top: 14px;
    }

    /* ===== DISPOSITIVO BASE (sempre incluso) ===== */
    .sensor-option.base-item {
      display: flex;
      align-items: center;
      gap: 18px;
      text-align: left;
      padding: 20px 24px;
      cursor: default;
      transform: none;
    }

    .sensor-option.base-item:hover {
      transform: none;
      border-color: #4CAF50;
      box-shadow: 0 0 0 4px rgba(76, 175, 80, 0.12), 0 8px 20px -6px rgba(76, 175, 80, 0.25);
    }

    .base-item .option-icon {
      margin-bottom: 0;
      font-size: 38px;
      flex-shrink: 0;
    }

    .base-info {
      flex: 1;
      min-width: 0;
    }

    .base-info .option-label {
      margin-bottom: 2px;
    }

    .base-price {
      display: flex;
      flex-direction: column;
      align-items: flex-end;
      gap: 6px;
      padding-right: 30px; /* espaço para o check-mark */
    }

    .badge-incluso {
      background: #e3f2e4;
      color: #2E7D32;
      font-size: 11px;
      font-weight: 700;
      letter-spacing: 0.5px;
      text-transform: uppercase;
      padding: 3px 10px;
      border-radius: 20px;
    }

    /* ===== RESUMO DO PEDIDO ===== */
    .summary {
      background: white;
      border: 3px solid #e8eeea;
      border-radius: 20px;
      padding: 18px 22px 20px;
      margin-bottom: 18px;
    }

    .summary-title {
      font-size: 12px;
      font-weight: 700;
      letter-spacing: 0.6px;
      text-transform: uppercase;
      color: #6b7a6b;
      margin-bottom: 8px;
    }

    .summary-list {
      list-style: none;
    }

    .summary-list li {
      display: flex;
      justify-content: space-between;
      gap: 12px;
      font-size: 15px;
      color: #1e2b1e;
      padding: 7px 0;
      border-bottom: 1px solid #eef3ee;
    }

    .summary-total {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-top: 14px;
      font-size: 16px;
      font-weight: 700;
      color: #1e2b1e;
    }

    .summary-total strong {
      font-size: 26px;
      font-weight: 800;
      color: #2E7D32;
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
      .sensor-option.base-item { flex-direction: column; text-align: center; padding: 22px 16px; }
      .base-price { align-items: center; padding-right: 0; }
    }

    /* ===== DARK MODE ===== */
    @media (prefers-color-scheme: dark) {
      .sensor-card {
        background: rgba(30, 30, 30, 0.95);
      }
      .header-sub { color: #b0b0b0; }
      .section-label { color: #b0b0b0; }
      .section-label small { color: #9aaa9a; }
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
      .option-price { color: #81c784; }
      .badge-incluso {
        background: #264a28;
        color: #a5d6a7;
      }
      .summary {
        background: #2a2a2a;
        border-color: #3d4a3d;
      }
      .summary-title { color: #9aaa9a; }
      .summary-list li {
        color: #e0e8e0;
        border-bottom-color: #3d4a3d;
      }
      .summary-total { color: #e0e8e0; }
      .summary-total strong { color: #81c784; }
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
<div class="background-pattern"></div>

<!-- Barra lateral padrão do Vigia Planta -->
<div class="sidebar" id="sidebar">
  <div class="sidebar-header">
    <img src="images/sempre/favicon.png" height="30" alt="Logo Vigia Planta">
    <h3>Vigia Planta</h3>
  </div>
  <nav class="sidebar-nav">
    <a href="home.php" class="sidebar-link"><i class="fas fa-home"></i><span>Início</span></a>
    <a href="Minhas Plantas.php" class="sidebar-link"><i class="fas fa-seedling"></i><span>Minhas Plantas</span></a>
    <a href="lojinha.php" class="sidebar-link active" aria-current="page"><i class="fas fa-store"></i><span>Lojinha</span></a>
  </nav>
  <a href="sair.php" class="btn-delete" style="display:block; padding:12px 16px; text-align:center; text-decoration:none; border-radius:10px; margin-top:12px;">SAIR</a>
  <div class="sidebar-footer">
    <div class="user-info-sidebar">
      <span class="avatar-placeholder" role="img" aria-label="Avatar de <?= htmlspecialchars($nomeU, ENT_QUOTES, 'UTF-8') ?>"><?= htmlspecialchars($iniciaisUsuario, ENT_QUOTES, 'UTF-8') ?></span>
      <div><p><?= htmlspecialchars($nomeU, ENT_QUOTES, 'UTF-8') ?></p></div>
    </div>
  </div>
</div>
<div class="sidebar-overlay" id="sidebarOverlay"></div>

<div class="main-wrapper">
  <header class="top-bar">
    <button class="menu-toggle" id="menuToggle" aria-label="Abrir menu"><i class="fas fa-bars"></i></button>
    <div class="top-actions">
      <img src="images/sempre/logo-vigia.png" height="60" alt="Vigia Planta">
      <div class="user-profile"><span class="avatar-placeholder" role="img" aria-label="Perfil de <?= htmlspecialchars($nomeU, ENT_QUOTES, 'UTF-8') ?>"><?= htmlspecialchars($iniciaisUsuario, ENT_QUOTES, 'UTF-8') ?></span></div>
    </div>
  </header>
  <main class="shop-main">
<div class="container">
  <div class="sensor-card">

    <!-- Cabeçalho -->
    <div class="header-section">
      <div class="header-icon">
        <i class="fas fa-store"></i>
      </div>
      <div>
        <div class="header-title">Lojinha Vigia Planta</div>
        <div class="header-sub"><i class="fas fa-leaf"></i>Escolha os módulos do seu Vigia</div>
      </div>
    </div>

    <!-- DISPOSITIVO BASE: sempre incluso no pedido -->
    <div class="sensor-option base-item selected" data-preco="90.00">
      <span class="check-mark"><i class="fas fa-check-circle"></i></span>
      <span class="option-icon"><i class="fas fa-microchip"></i></span>
      <div class="base-info">
        <span class="option-label">Dispositivo base</span>
        <span class="option-desc">Placa Arduino UNO R3 WiFi, sem módulos</span>
      </div>
      <div class="base-price">
        <span class="option-price"></span>
        <span class="badge-incluso">Incluso</span>
      </div>
    </div>

    <!-- MÓDULOS: o cliente escolhe, no mínimo um -->
    <div class="section-label">
      <i class="fas fa-puzzle-piece"></i>Módulos<small>(escolha pelo menos um)</small>
    </div>

    <div class="options-grid" id="optionsGrid">

      <!-- 1: MÓDULO SOLAR -->
      <div class="sensor-option modulo" data-produto="solar" data-preco="190.00" role="checkbox" aria-checked="false" tabindex="0">
        <span class="check-mark"><i class="fas fa-check-circle"></i></span>
        <span class="option-icon"><i class="fas fa-solar-panel"></i></span>
        <span class="option-label">Módulo solar</span>
        <span class="option-desc">3 painéis solares e medidor de luz solar</span>
        <span class="option-price"></span>
      </div>

      <!-- 2: MÓDULO DE TEMPERATURA -->
      <div class="sensor-option modulo" data-produto="temperatura" data-preco="10.00" role="checkbox" aria-checked="false" tabindex="0">
        <span class="check-mark"><i class="fas fa-check-circle"></i></span>
        <span class="option-icon"><i class="fas fa-thermometer-half"></i></span>
        <span class="option-label">Módulo de temperatura</span>
        <span class="option-price"></span>
      </div>

      <!-- 3: MÓDULO DE UMIDADE -->
      <div class="sensor-option modulo" data-produto="umidade" data-preco="10.00" role="checkbox" aria-checked="false" tabindex="0">
        <span class="check-mark"><i class="fas fa-check-circle"></i></span>
        <span class="option-icon"><i class="fas fa-tint"></i></span>
        <span class="option-label">Módulo de umidade</span>
        <span class="option-price"></span>
      </div>

    </div>

    <!-- RESUMO DO PEDIDO -->
    <div class="summary">
      <div class="summary-title">Resumo do pedido</div>
      <ul class="summary-list" id="summaryList"></ul>
      <div class="summary-total">
        <span>Total</span>
        <strong id="total">R$ 0,00</strong>
      </div>
    </div>

    <!-- Botão de envio -->
    <button type="button" class="action-btn" id="submitBtn">
      <i class="fas fa-check-circle"></i> Finalizar pedido
    </button>

    <!-- Feedback -->
    <div id="feedback" aria-live="polite"></div>

  </div>
</div>

<script>
  (function () {
    // Os preços ficam só no atributo data-preco de cada item (em reais, com ponto)
    const brl = (centavos) => (centavos / 100).toLocaleString('pt-BR', { style: 'currency', currency: 'BRL' });
    const centavosDe = (el) => Math.round(parseFloat(el.dataset.preco) * 100);
    const nomeDe = (el) => el.querySelector('.option-label').textContent.trim();

    const itemBase = document.querySelector('.base-item');
    const modulos = document.querySelectorAll('.modulo');
    const lista = document.getElementById('summaryList');
    const totalEl = document.getElementById('total');
    const feedback = document.getElementById('feedback');

    function mostrarFeedback(html, tipo) {
      feedback.innerHTML = html;
      feedback.className = tipo;
    }

    function limparFeedback() {
      feedback.innerHTML = '';
      feedback.className = '';
    }

    function modulosSelecionados() {
      return Array.from(modulos).filter((m) => m.classList.contains('selected'));
    }

    // Escreve o preço em cada card
    document.querySelectorAll('[data-preco]').forEach((el) => {
      el.querySelector('.option-price').textContent = brl(centavosDe(el));
    });

    // Monta o resumo (base + módulos escolhidos) e calcula o total
    function atualizarResumo() {
      const itens = [itemBase].concat(modulosSelecionados());
      let total = 0;

      lista.innerHTML = '';
      itens.forEach((el) => {
        total += centavosDe(el);

        const li = document.createElement('li');
        const nome = document.createElement('span');
        const valor = document.createElement('span');
        nome.textContent = nomeDe(el);
        valor.textContent = brl(centavosDe(el));
        li.appendChild(nome);
        li.appendChild(valor);
        lista.appendChild(li);
      });

      totalEl.textContent = brl(total);
    }

    // Marca / desmarca um módulo
    function alternar(el) {
      const ativo = el.classList.toggle('selected');
      el.setAttribute('aria-checked', String(ativo));
      atualizarResumo();
      limparFeedback();
    }

    modulos.forEach((el) => {
      el.addEventListener('click', () => alternar(el));
      el.addEventListener('keydown', (e) => {
        if (e.key === 'Enter' || e.key === ' ') {
          e.preventDefault();
          alternar(el);
        }
      });
    });

    // Envia a seleção ao servidor, que valida o pedido e redireciona para a home.
    document.getElementById('submitBtn').addEventListener('click', () => {
      const escolhidos = modulosSelecionados();
      if (escolhidos.length === 0) {
        mostrarFeedback('⚠️ Escolha pelo menos um módulo.', 'error');
        return;
      }

      const form = document.createElement('form');
      form.method = 'POST';
      form.action = 'lojinha.php';
      const acao = document.createElement('input');
      acao.type = 'hidden';
      acao.name = 'acao';
      acao.value = 'finalizar_pedido';
      form.appendChild(acao);
      escolhidos.forEach((el) => {
        const input = document.createElement('input');
        input.type = 'hidden';
        input.name = 'modulos[]';
        input.value = el.dataset.produto;
        form.appendChild(input);
      });
      document.body.appendChild(form);
      form.submit();
    });

    // Início: só o dispositivo base no resumo
    atualizarResumo();
    const erroInicial = <?= json_encode($erroPedido, JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_HEX_AMP) ?>;
    if (erroInicial) {
      mostrarFeedback(erroInicial, 'error');
    } else {
      mostrarFeedback('💡 Clique nos módulos que você quer no seu Vigia', 'info');
    }
  })();
</script>
  </main>
</div>

<script>
  // Menu lateral responsivo compartilhado com as demais páginas.
  const menuToggle = document.getElementById('menuToggle');
  const sidebar = document.getElementById('sidebar');
  const overlay = document.getElementById('sidebarOverlay');
  function toggleSidebar() {
    sidebar.classList.toggle('active');
    overlay.classList.toggle('active');
    document.body.style.overflow = sidebar.classList.contains('active') ? 'hidden' : '';
  }
  menuToggle.addEventListener('click', toggleSidebar);
  overlay.addEventListener('click', toggleSidebar);
  document.addEventListener('keydown', function (event) {
    if (event.key === 'Escape' && sidebar.classList.contains('active')) toggleSidebar();
  });
</script>
</body>
</html>
