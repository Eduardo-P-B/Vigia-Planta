<?php

    session_start();

    if (!isset($_SESSION['idUser'])) {
        header("Location: ../login.php");
        exit();
    }

?>