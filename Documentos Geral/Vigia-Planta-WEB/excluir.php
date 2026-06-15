<?php 
require "config.php";

session_start();

if ($_SESSION['idUser'] == ""){
        header("Location: login.php");
        exit;
    }else{

    $id = $_SESSION["idUser"];

    $nomeP = $_GET['nomeP'];

$nomeP = $_GET['nomeP'];

$sql = "DELETE FROM planta where userId = '$id' and nome = '$nomeP'";

$conn->query($sql);

header("Location: Minhas Plantas.php");
exit;
    }
?>