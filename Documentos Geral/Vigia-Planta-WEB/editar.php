<?php

    error_reporting(E_ALL);
    ini_set('display_errors', 1);

    require "config.php";

    session_start();

if ($_SESSION['idUser'] == ""){
        header("Location: login.php");
        exit;
    }else{

        $id = $_SESSION["idUser"];

        $sql = "SELECT nome FROM user WHERE id = ?";
        $stmt = $conn->prepare($sql);
        $stmt->bind_param("i", $id);
        $stmt->execute();

        $resultado = $stmt->get_result();

        $usuario = $resultado->fetch_assoc();

        $idP = $_GET['idP'];

        $erro = "";
        $sucesso = "";

        $nomeP = "";
        $data = "";
        $local = "";
        $especie = "";

        $sql = "SELECT * FROM planta WHERE userId = ? and id = '$idP'";
                    $stmt = $conn->prepare($sql);
                    $stmt->bind_param("i", $id);
                    $stmt->execute();

                    $resultado = $stmt->get_result();

                    $linha = $resultado->fetch_assoc();

                    $nomeP = $linha['nome'];
                    $data = $linha['dataPlantio'];
                    $local = $linha['localizacao'];
                    $especie = $linha['especie'];


        if ($_SERVER['REQUEST_METHOD'] == 'POST') {

            $nomeP = trim($_POST['nomeP']);
            $data = $_POST['data'];
            $local = trim($_POST['local']);
            $especie = $_POST['especie'];



            

    // VALIDAÇÃO
            if (empty($nomeP)) {
                $erro .= "O nome da planta é obrigatório<br>";
            }
            if (empty($data)) {
                $erro .= "A data do plantio da planta é obrigatória<br>";
            }
            if (empty($local)) {
                $erro .= "O local da planta é obrigatório<br>";
            }
         if (empty($especie)) {
                $erro .= "A especie da planta é obrigatória<br>";
            }

    // PROCESSAMENTO
            if ($erro == "") {

               $sql = "UPDATE planta set nome = '$nomeP', especie = '$especie', localizacao = '$local', dataPlantio = '$data' where id = '$idP' and userId = '$id'";

                /*$stmt*/
                $executaQuery = $conn->query($sql);

                if ($executaQuery) {
                    $sucesso = "Usuário cadastrado com sucesso!";
                   //limpar os campos
                    $nomeP = "";
                    $especie = "";
                    $local = "";
                    $data = "";
                    $foto = "";

                    header("Location: Minhas Plantas.php");
                    exit;

               } else {
               $erro = "Erro ao cadastrar usuario";
                }
            }
        }
    }
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
    <title>Vigia Planta</title>
    <link rel="stylesheet" href="CSS/style-home.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="icon" href="images/sempre/Favicom.png" type="image/png">
</head>
<body>

<form id="cadastro-planta-form" method="POST" enctype="multipart/form-data">
                    <div class="form-two-columns">
                        <!-- Coluna da direita - Dados da planta -->
                        <div class="form-column data-column">
                            <div class="input-group">
                                <label class="input-label">
                                    <i class="fas fa-font"></i>
                                    Nome da Planta
                                </label>
                                <input type="text" class="input-field" placeholder="Ex: Cronton (Externo)" name="nomeP" value='<?=$nomeP?>'>
                                <span class="input-hint">Dê um nome <b>único</b> para identificar sua planta</span>
                            </div>

                            <div class="input-group">
                                <label class="input-label">
                                    <i class="fas fa-tag"></i>
                                    Espécie
                                </label>
                                <div class="select-wrapper">
                                    <select class="input-field select-field" required name="especie" value='<?=$especie?>'>
                                        <option value="" disabled selected>Selecione a espécie</option>
                                        <optgroup label="🌿 Plantas Folhagens">
                                            <option value="podocarpo">Podocarpo</option>
                                            <option value="costela de adao">Costela de Adão</option>
                                            <option value="croton">Croton</option>
                                            <option value="lirio">Lírio da Paz</option>
                                        </optgroup>
                                        <optgroup label="🌵 Suculentas e Cactos">
                                            <option value="cacto">Cacto</option>
                                            <option value="suculenta">Suculenta</option>
                                        </optgroup>
                                        <optgroup label="🌸 Flores">
                                            <option value="rosa">Rosa</option>
                                        </optgroup>
                                    </select>
                                    <div class="select-arrow">
                                        <i class="fas fa-chevron-down"></i>
                                    </div>
                                </div>
                            </div>

                            <div class="input-group">
                                <label class="input-label">
                                    <i class="fas fa-map-marker-alt"></i>
                                    Localização
                                </label>
                                <input type="text" class="input-field" placeholder="Ex: Sala, Varanda, Jardim" name="local" value='<?=$local?>'>
                            </div>

                            <div class="input-row">
                                <div class="input-group half">
                                    <label class="input-label">
                                        <i class="fas fa-calendar"></i>
                                        Data de Plantio
                                    </label>
                                    <input type="date" class="input-field" name="data" value='<?=$data?>'>
                                </div>
                            </div>
                        </div>
                    </div>


                    <!-- Botões de ação -->
                    <div class="form-actions">
                        <button type="submit" class="submit-plant-btn">
                            <i class="fas fa-save"></i>
                            Salvar Planta
                        </button>
                    </div>
                </form>

</body>
    
</body>
</html>