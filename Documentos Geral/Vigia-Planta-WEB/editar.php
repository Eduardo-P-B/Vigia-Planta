<?php

require "dependencias/config.php";
require "dependencias/sessao.php";

$id = $_SESSION["idUser"];

/* Buscar usuário */
$sql = "SELECT nome FROM user WHERE id = :id";
$stmt = $conn->prepare($sql);
$stmt->bindParam(":id", $id);
$stmt->execute();

$usuario = $stmt->fetch(PDO::FETCH_ASSOC);

/* ID da planta */
$idP = $_GET['idP'] ?? null;

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

/* Buscar planta */
$sql = "SELECT * FROM planta 
        WHERE userId = :id 
        AND id = :idP";

$stmt = $conn->prepare($sql);
$stmt->bindParam(":id", $id);
$stmt->bindParam(":idP", $idP);
$stmt->execute();

$linha = $stmt->fetch(PDO::FETCH_ASSOC);

if (!$linha) {
    header("Location: Minhas Plantas.php");
    exit;
}

$nomeP = $linha['nome'];
$data = $linha['dataPlantio'];
$local = $linha['localizacao'];
$especie = $linha['especie'];


/* Atualização */
if ($_SERVER['REQUEST_METHOD'] == 'POST') {

    $nomeP = trim($_POST['nomeP'] ?? '');
    $data = $_POST['data'] ?? '';
    $local = trim($_POST['local'] ?? '');
    $especie = $_POST['especie'] ?? '';

    /* VALIDAÇÃO */

    if (empty($nomeP)) {
        $erro .= "O nome da planta é obrigatório.<br>";
    }

    if (empty($data)) {
        $erro .= "A data do plantio é obrigatória.<br>";
    }

    if (empty($local)) {
        $erro .= "O local da planta é obrigatório.<br>";
    }

    if (empty($especie)) {
        $erro .= "A espécie da planta é obrigatória.<br>";
    }


    /* PROCESSAMENTO */

    if ($erro == "") {

        $sql = "UPDATE planta 
                SET nome = :nome,
                    especie = :especie,
                    localizacao = :localizacao,
                    dataPlantio = :dataPlantio
                WHERE id = :idP
                AND userId = :userId";

        $stmt = $conn->prepare($sql);

        $stmt->bindParam(":nome", $nomeP);
        $stmt->bindParam(":especie", $especie);
        $stmt->bindParam(":localizacao", $local);
        $stmt->bindParam(":dataPlantio", $data);
        $stmt->bindParam(":idP", $idP);
        $stmt->bindParam(":userId", $id);

        if ($stmt->execute()) {

            $sucesso = "Planta atualizada com sucesso!";

            header("Location: Minhas Plantas.php");
            exit;

        } else {

            $erro = "Não foi possível atualizar a planta.";
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
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

    <link rel="icon"
          href="images/sempre/Favicom.png"
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
                  method="POST">


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

                                    <option value="lirio"
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

</body>

</html>
