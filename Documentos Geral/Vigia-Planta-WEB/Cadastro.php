<?php

require "config.php";

$erro = "";
$sucesso = "";

$nome = "";
$email = "";
$senha1 = "";
$senha2 = "";

if ($_SERVER['REQUEST_METHOD'] == 'POST') {

    $nome = trim($_POST['nome']);
    $email = trim($_POST['email']);
    $senha1 = trim($_POST['senha1']);
    $senha2 = trim($_POST['senha2']);


    // VALIDAÇÃO
    if (empty($nome)) {
        $erro .= "Nome do usuario é obrigatório<br>";
    }

    if (filter_var($email, FILTER_VALIDATE_EMAIL)) {
        
    } else {
        $erro .= "O e-mail deve ser valido<br>";
    }

    if (strlen($senha1) < 8 ) {
        $erro .= "A senha deve ter mais de 8 caracteres<br>";
    }

    if ($senha2 != $senha1) {
        $erro .= "Confirme a senha<br>";
    }

    // PROCESSAMENTO
    if ($erro == "") {

        $sql = "INSERT INTO user (nome, email, senha) VALUES ('$nome', '$email', '$senha1')";

        /*$stmt*/
        $executaQuery = $conn->query($sql);

        if ($executaQuery) {
            $sucesso = "Usuário cadastrado com sucesso!";
            //limpar os campos
            $nome = "";
            $email = "";
            $senha1 = "";
            $senha2 = "";

        } else {
            $erro = "Erro ao cadastrar usuario";
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
                <p class="default-text">Cadastrar-se</p>
            </div>

            <form class="login-form" method="POST">
                <div class="input-group">
                    <label class="input-label">
                        <i class="fas fa-user"></i>
                        Nome de Usuário
                    </label>
                    <input type="text" class="input-field" placeholder="Digite seu nome" name="nome">
                </div>

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
                        <input type="password" class="input-field" placeholder="Digite sua senha" name="senha1" id="senha1">
                        <button type="button" class="toggle-password" id="btnsenha1">
                            <i class="fas fa-eye"></i>
                        </button>
                    </div>
                </div>

                <div class="input-group">
                    <label class="input-label">
                        <i class="fas fa-lock"></i>
                        Confirmar Senha
                    </label>
                    <div class="password-wrapper">
                        <input type="password" class="input-field" placeholder="Digite sua senha novamente" name="senha2" id="senha2">
                        <button type="button" class="toggle-password" id="btnsenha2">
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

                <button type="submit" class="login-btn" onclick="window.location.href='login.php'">
                    <i class="fas fa-sign-in-alt"></i>
                    Cadastrar
                </button>
            </form>

            <div class="signup-prompt">
                <p>Já tem uma conta? <a href="Login.php">Entrar</a></p>
            </div>

            <div class="plant-decoration">
                <div class="plant leaf-1"></div>
                <div class="plant leaf-2"></div>
                <div class="plant leaf-3"></div>
            </div>
        </div>
    </div>

    

    <script>


        let senha1 = document.querySelector("#senha1");
        const btnsenha1 = document.querySelector("#btnsenha1");

        btnsenha1.addEventListener("click", () => {
            if (senha1.type === "password") {
                senha1.type = "text";
            } else {
                senha1.type = "password";
            }
        });

        let senha2 = document.querySelector("#senha2");
        const btnsenha2 = document.querySelector("#btnsenha2");

        btnsenha2.addEventListener("click", () => {
            if (senha2.type === "password") {
                senha2.type = "text";
            } else {
                senha2.type = "password";
            }
        });

    </script>

</body>
</html>