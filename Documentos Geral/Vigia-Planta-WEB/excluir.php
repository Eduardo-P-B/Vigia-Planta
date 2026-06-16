<?php 
require "config.php";

session_start();

if ($_SESSION['idUser'] == ""){
        header("Location: login.php");
        exit;
    }else{

    $id = $_SESSION["idUser"];

    $nomeP = $_GET['nomeP'];

$idP = $_GET['idP'];

$sql = "DELETE FROM planta where userId = '$id' and id = '$idP'";

$conn->query($sql);

header("Location: Minhas Plantas.php");
exit;
    }
?>