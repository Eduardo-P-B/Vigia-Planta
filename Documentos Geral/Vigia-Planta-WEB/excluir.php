<?php 
require "config.php";

if ($_SESSION['idUser'] == ""){
        header("Location: login.php");
        exit;
    }else{

    $id = $_SESSION["idUser"];

    $nomeP = $_GET['nomeP'];

$nomeP = $_GET['nomeP'];

$sql = "DELETE FROM planta where userId = $id and nome = $nomeP";

$conn->query($sql);

header("Location: home.php");
exit;
    }
?>