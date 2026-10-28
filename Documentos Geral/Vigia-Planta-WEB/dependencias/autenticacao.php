<?php

    // Inicia a sessão e verifica se o usuário está autenticado.
    // As páginas protegidas não chamam session_start(): só pedem este arquivo
    //     require "dependencias/autenticacao.php";
    session_start();

    // Usuário não fez login?
    if (!isset($_SESSION["id"], $_SESSION["nome"])) {
        // Todas as páginas protegidas ficam na mesma pasta do login.php
        header("Location: login.php");
        exit();
    }
