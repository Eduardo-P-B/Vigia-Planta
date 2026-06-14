<?php

    require "config.php";

    session_start();  

    if ($_SESSION['idUser'] != "")
        {
        header("Location: home.php");
        exit;
        }

    $erro = "";
    $sucesso = "";

    $senha = "";
    $email = "";
 
if ($_SERVER['REQUEST_METHOD'] == 'POST') {

    $email = trim($_POST['email']);
    $senha = trim($_POST['senha']);


    if ($email == "" || $senha == "") {
        $erro = "Preencha os campos<br>";
    }else {

    $sql = "SELECT * FROM user WHERE email = ?";

    $stmt = $conn->prepare($sql);

    $stmt->bind_param("s", $email);

    $stmt->execute();


    $resultado = $stmt->get_result();

    if ($resultado->num_rows == 1) {
        $usuario = $resultado->fetch_assoc();

        if ($senha != $usuario['senha']) {
        $erro = "E-mail ou senha invalidos";
        }else {
    
        $_SESSION['idUser'] = $usuario["id"];

        if ($_SESSION['idUser'] != "")
        {
        header("Location: home.php");
        exit;
        }
        }
    } else {
        $erro = "E-mail ou senha invalidos";
    }

}
}


?>

<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
    <title>Vigia Planta</title>
    <link rel="stylesheet" href="CSS/style-login.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="icon" href="images/Favicom.png" type="image/png">
</head>
<body>
    <div class="container">
        <div class="login-card">
            <div class="logo-section">
                <div class="logo-icon">
                    <img src="images/LogoSemFundoBranca.png" width="100">
                </div>
                <h1 class="logo-text">Vigia Planta</h1>
                <p class="tagline">Suas plantas na palma da mão</p>
                <h3 class="default-text">Entrar</h3>
            </div>

            <form class="login-form" method="POST">
                <div class="input-group">
                    <label class="input-label">
                        <i class="fas fa-envelope"></i>
                        Email
                    </label>
                    <input type="email" class="input-field" placeholder="Digite seu email" name="email">
                </div>

                <div class="input-group">
                    <label class="input-label">
                        <i class="fas fa-lock"></i>
                        Senha
                    </label>
                    <div class="password-wrapper">
                        <input type="password" class="input-field" placeholder="Digite sua senha" name="senha" id="senha">
                        <button type="button" class="toggle-password" id="btnsenha">
                            <i class="fas fa-eye"></i>
                        </button>
                    </div>
                </div>

                <?php
                    if ($erro != "") {
                        echo "<div style='color: red; border: 1px solid red; padding: 10px;'> $erro </div>";
                    }
                    if ($sucesso != "") {
                        echo "<div style='color: green; border: 1px solid green; padding: 10px;'> $sucesso </div>";
                    }
                ?>

                <!-- onclick="window.location.href='home.php'" -->
                <button type="submit" class="login-btn">
                    <i class="fas fa-sign-in-alt"></i>
                    Entrar
                </button>
            </form>

            <div class="signup-prompt">
                <p>Não tem uma conta? <a href="Cadastro.php">Criar conta</a></p>
            </div>

            <div class="plant-decoration">
                <div class="plant leaf-1"></div>
                <div class="plant leaf-2"></div>
                <div class="plant leaf-3"></div>
            </div>
        </div>
    </div>

    <script>

        let senha = document.querySelector("#senha");
        const btnsenha = document.querySelector("#btnsenha");

        btnsenha.addEventListener("click", () => {
            if (senha.type === "password") {
                senha.type = "text";
            } else {
                senha.type = "password";
            }
        });

    </script>

</body>
</html>