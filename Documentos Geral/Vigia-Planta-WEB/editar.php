<?php
require "config.php";

 if ($_SESSION['idUser'] == ""){
        header("Location: login.php");
        exit;
    }else{

        $nomeP = $_GET['nomeP'];

        $id = $_SESSION["idUser"];

        $sql = "SELECT * FROM planta where userId = $id and nome = $nomeP";

        $resultado = $conn->query($sql);

        $produto = $resultado->fetch_assoc();

        if ($_SERVER["REQUEST_METHOD"] == "POST") {
            $nome = $_POST['nome'];
            $preco = $_POST['preco'];
            $quantidade = $_POST['quantidade'];

            $sql = "UPDATE Produtos SET nome='$nome', preco=$preco, quantidade=$quantidade WHERE id=$id";

            $conn->query($sql);

            header("Location: listar.php");
            exit;
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
    <link rel="icon" href="images/Favicom.png" type="image/png">
</head>
<body>

<h1>Editar Produto</h1>

    <form method="POST">
        <label for="nome">Nome:</label>
        <input type="text" id="nome" name="nome" value="<?= $produto['nome'] ?>"><br><br>

        <label for="preco">Preço:</label>
        <input type="number" id="preco" name="preco" step="0.01" value="<?= $produto['preco'] ?>"><br><br>

        <label for="quantidade">Quantidade:</label>
        <input type="number" id="quantidade" name="quantidade" value="<?= $produto['quantidade'] ?>"><br><br>

        <button type="submit">Salvar Alterações</button>
    </form>

    <a href="listar.php">Voltar para a lista de produtos</a>

</body>
    
</body>
</html>