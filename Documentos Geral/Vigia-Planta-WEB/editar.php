<?php
require "dependencias/autenticacao.php";
require "dependencias/config.php";
require_once __DIR__ . '/dependencias/imagens.php';

$id = $_SESSION["id"];
$idP = filter_input(INPUT_GET, 'idP', FILTER_VALIDATE_INT);
if (!$idP) {
    header("Location: Minhas Plantas.php");
    exit;
}

$erro = "";
$sucesso = "";
$nomeP = "";
$data = "";
$local = "";
$especie = "";

$stmt = $conn->prepare("SELECT * FROM planta WHERE userId = :id AND id = :idP");
$stmt->bindValue(':id', $id, PDO::PARAM_INT);
$stmt->bindValue(':idP', $idP, PDO::PARAM_INT);
$stmt->execute();
$linha = $stmt->fetch(PDO::FETCH_ASSOC);
if (!$linha) {
    header("Location: Minhas Plantas.php");
    exit;
}

$fotoAtual = $linha['foto'];
$nomeP = $linha['nome'];
$data = $linha['dataPlantio'];
$local = $linha['localizacao'];
$especie = $linha['especie'];

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $nomeP = trim($_POST['nomeP'] ?? '');
    $data = $_POST['data'] ?? '';
    $local = trim($_POST['local'] ?? '');
    $especie = $_POST['especie'] ?? '';

    if ($nomeP === '') $erro .= "O nome da planta é obrigatório.<br>";
    if ($data === '') $erro .= "A data do plantio é obrigatória.<br>";
    if ($local === '') $erro .= "A localização da planta é obrigatória.<br>";
    $especiesValidas = ['podocarpo', 'costela de adao', 'croton', 'lirio da paz', 'cacto', 'suculenta', 'rosa'];
    if (!in_array($especie, $especiesValidas, true)) $erro .= "Selecione uma espécie válida.<br>";

    $novaFoto = null;
    $destinoNovo = null;
    $upload = isset($_FILES['foto']) && $_FILES['foto']['error'] !== UPLOAD_ERR_NO_FILE;
    if ($upload) {
        $tmp = $_FILES['foto']['tmp_name'] ?? '';
        if ($_FILES['foto']['error'] !== UPLOAD_ERR_OK || !is_uploaded_file($tmp)) {
            $erro .= "Não foi possível receber a nova foto.<br>";
        } else {
            $infoImagem = @getimagesize($tmp);
            $extensoes = ['image/jpeg' => 'jpg', 'image/png' => 'png', 'image/webp' => 'webp', 'image/gif' => 'gif'];
            if ($infoImagem === false || !isset($extensoes[$infoImagem['mime']])) {
                $erro .= "A foto deve ser uma imagem JPG, PNG, WEBP ou GIF.<br>";
            }
        }
    }

    if ($erro === '') {
        if ($upload) {
            $pastaImagens = __DIR__ . '/images';
            if (!is_dir($pastaImagens)) mkdir($pastaImagens, 0755, true);
            $nomeArquivo = bin2hex(random_bytes(16)) . '.' . $extensoes[$infoImagem['mime']];
            $destinoNovo = $pastaImagens . '/' . $nomeArquivo;
            $novaFoto = 'images/' . $nomeArquivo;
            if (!move_uploaded_file($tmp, $destinoNovo)) {
                $erro = "Não foi possível salvar a nova foto.";
            }
        }

        if ($erro === '') {
            try {
                $fotoSalvar = $novaFoto ?? $fotoAtual;
                $sql = "UPDATE planta SET nome = :nome, especie = :especie,
                        localizacao = :localizacao, dataPlantio = :dataPlantio,
                        foto = :foto
                        WHERE id = :idP AND userId = :id";
                $stmt = $conn->prepare($sql);
                $stmt->bindValue(':nome', $nomeP);
                $stmt->bindValue(':especie', $especie);
                $stmt->bindValue(':localizacao', $local);
                $stmt->bindValue(':dataPlantio', $data);
                $stmt->bindValue(':foto', $fotoSalvar);
                $stmt->bindValue(':idP', $idP, PDO::PARAM_INT);
                $stmt->bindValue(':id', $id, PDO::PARAM_INT);
                $stmt->execute();

                if ($novaFoto !== null && !empty($fotoAtual)) {
                    $caminhoAntigo = realpath(__DIR__ . '/' . $fotoAtual);
                    $pastaPermitida = realpath(__DIR__ . '/images');
                    if ($caminhoAntigo && $pastaPermitida &&
                        strpos($caminhoAntigo, $pastaPermitida . DIRECTORY_SEPARATOR) === 0 &&
                        is_file($caminhoAntigo)) {
                        unlink($caminhoAntigo);
                    }
                }
                header("Location: Minhas Plantas.php");
                exit;
            } catch (Throwable $e) {
                if ($destinoNovo && is_file($destinoNovo)) unlink($destinoNovo);
                $erro = "Não foi possível atualizar a planta. Tente novamente.";
            }
        }
    }
}
?>

<!DOCTYPE html>
<html lang="pt-BR">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Editar Planta | Vigia Planta</title>

    <link rel="stylesheet"
          href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap">

    <link rel="stylesheet"
          href="CSS/fontawesome/all.min.css">
    <link rel="stylesheet" href="CSS/fontawesome/v4-shims.min.css">

    <link rel="icon"
          href="images/sempre/favicon.png"
          type="image/png">

    <link rel="stylesheet"
          href="CSS/style-editar-planta.css">

</head>

<body>

    <!-- Decoração -->
    <div class="background-decoration decoration-1"></div>
    <div class="background-decoration decoration-2"></div>
    <div class="background-decoration decoration-3"></div>


    <main class="page-container">

        <section class="edit-card">

            <!-- Cabeçalho -->
            <header class="edit-header">

                <div class="header-icon">
                    <i class="fas fa-seedling"></i>
                </div>

                <div class="header-text">

                    <span class="header-label">
                        VIGIA PLANTA
                    </span>

                    <h1>
                        Editar planta
                    </h1>

                    <p>
                        Atualize as informações da sua planta.
                    </p>

                </div>

            </header>


            <!-- Mensagens -->

            <?php if (!empty($erro)): ?>

                <div class="message error-message">
                    <i class="fas fa-circle-exclamation"></i>

                    <div>
                        <?= $erro ?>
                    </div>
                </div>

            <?php endif; ?>


            <?php if (!empty($sucesso)): ?>

                <div class="message success-message">
                    <i class="fas fa-circle-check"></i>

                    <span>
                        <?= $sucesso ?>
                    </span>
                </div>

            <?php endif; ?>


            <!-- Formulário -->

            <form id="cadastro-planta-form"
                  method="POST" enctype="multipart/form-data">


                <div class="input-group">
                    <label class="input-label" for="foto">
                        <span class="label-icon"><i class="fas fa-image"></i></span>
                        <span>Foto da planta<small>Selecione uma nova imagem para substituir a atual (opcional)</small></span>
                    </label>
                    <div style="margin: 12px 0;">
                        <img id="fotoPreviewEditar" src="<?= htmlspecialchars(urlFotoPlanta($fotoAtual ?? ''), ENT_QUOTES, 'UTF-8') ?>"
                             alt="Foto atual da planta"
                             onerror="this.onerror=null;this.src='images/sempre/planta-placeholder.svg';"
                             style="width: 180px; height: 150px; object-fit: cover; border-radius: 12px; display: block;">
                    </div>
                    <input type="file" id="foto" name="foto" class="input-field" accept="image/jpeg,image/png,image/webp,image/gif">
                </div>

                <div class="form-content">


                    <!-- Nome -->

                    <div class="input-group">

                        <label class="input-label"
                               for="nomeP">

                            <span class="label-icon">
                                <i class="fas fa-leaf"></i>
                            </span>

                            <span>
                                Nome da Planta
                                <small>Como você identifica sua planta</small>
                            </span>

                        </label>

                        <input
                            type="text"
                            id="nomeP"
                            class="input-field"
                            placeholder="Ex: Cróton da sala"
                            name="nomeP"
                            value="<?= htmlspecialchars($nomeP) ?>"
                            autocomplete="off"
                        >

                    </div>


                    <!-- Espécie -->

                    <div class="input-group">

                        <label class="input-label"
                               for="especie">

                            <span class="label-icon">
                                <i class="fas fa-tag"></i>
                            </span>

                            <span>
                                Espécie
                                <small>Selecione o tipo da planta</small>
                            </span>

                        </label>


                        <div class="select-wrapper">

                            <select
                                class="input-field select-field"
                                id="especie"
                                name="especie"
                            >

                                <option value="" disabled
                                    <?= empty($especie) ? 'selected' : '' ?>>
                                    Selecione a espécie
                                </option>


                                <optgroup label="🌿 Plantas Folhagens">

                                    <option value="podocarpo"
                                        <?= $especie == 'podocarpo' ? 'selected' : '' ?>>
                                        Podocarpo
                                    </option>

                                    <option value="costela de adao"
                                        <?= $especie == 'costela de adao' ? 'selected' : '' ?>>
                                        Costela de Adão
                                    </option>

                                    <option value="croton"
                                        <?= $especie == 'croton' ? 'selected' : '' ?>>
                                        Croton
                                    </option>

                                    <option value="lirio da paz"
                                        <?= $especie == 'lirio' ? 'selected' : '' ?>>
                                        Lírio da Paz
                                    </option>

                                </optgroup>


                                <optgroup label="🌵 Suculentas e Cactos">

                                    <option value="cacto"
                                        <?= $especie == 'cacto' ? 'selected' : '' ?>>
                                        Cacto
                                    </option>

                                    <option value="suculenta"
                                        <?= $especie == 'suculenta' ? 'selected' : '' ?>>
                                        Suculenta
                                    </option>

                                </optgroup>


                                <optgroup label="🌸 Flores">

                                    <option value="rosa"
                                        <?= $especie == 'rosa' ? 'selected' : '' ?>>
                                        Rosa
                                    </option>

                                </optgroup>

                            </select>

                            <i class="fas fa-chevron-down select-arrow"></i>

                        </div>

                    </div>


                    <!-- Local -->

                    <div class="input-group">

                        <label class="input-label"
                               for="local">

                            <span class="label-icon">
                                <i class="fas fa-location-dot"></i>
                            </span>

                            <span>
                                Localização
                                <small>Onde sua planta está</small>
                            </span>

                        </label>

                        <input
                            type="text"
                            id="local"
                            class="input-field"
                            placeholder="Ex: Sala, varanda ou jardim"
                            name="local"
                            value="<?= htmlspecialchars($local) ?>"
                        >

                    </div>


                    <!-- Data -->

                    <div class="input-group">

                        <label class="input-label"
                               for="data">

                            <span class="label-icon">
                                <i class="fas fa-calendar-days"></i>
                            </span>

                            <span>
                                Data de Plantio
                                <small>Quando a planta foi plantada</small>
                            </span>

                        </label>

                        <input
                            type="date"
                            id="data"
                            class="input-field"
                            name="data"
                            value="<?= htmlspecialchars($data) ?>"
                        >

                    </div>

                </div>


                <!-- Botões -->

                <div class="form-actions">

                    <a href="Minhas Plantas.php"
                       class="cancel-btn">

                        <i class="fas fa-arrow-left"></i>

                        Cancelar

                    </a>


                    <button
                        type="submit"
                        class="submit-plant-btn">

                        <i class="fas fa-check"></i>

                        Salvar alterações

                    </button>

                </div>

            </form>

        </section>


        <!-- Rodapé -->

        <p class="page-footer">
            <i class="fas fa-seedling"></i>
            Cuide hoje. Cultive amanhã.
        </p>

    </main>

<script>
const fotoEditar = document.getElementById('foto');
const previewEditar = document.getElementById('fotoPreviewEditar');
if (fotoEditar && previewEditar) {
    fotoEditar.addEventListener('change', function () {
        const arquivo = this.files && this.files[0];
        if (!arquivo) return;
        if (!arquivo.type.startsWith('image/')) {
            this.value = '';
            alert('Selecione um arquivo de imagem.');
            return;
        }
        const leitor = new FileReader();
        leitor.onload = function (evento) {
            previewEditar.src = evento.target.result;
            previewEditar.style.display = 'block';
        };
        leitor.readAsDataURL(arquivo);
    });
}
</script>
</body>

</html>
