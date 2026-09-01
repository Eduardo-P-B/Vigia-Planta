<?php 
    require "dependencias/config.php";
    require "dependencias/sessao.php";



    $id = $_SESSION["idUser"];

    $nomeP = $_GET['nomeP'];

    $idP = $_GET['idP'];

    $sql = "DELETE FROM planta WHERE userId = :id AND id = :idP";

    $stmt = $conn->prepare($sql);

    $stmt->bindParam(":id", $id);
    $stmt->bindParam(":idP", $idP);

    $stmt->execute();


    header("Location: Minhas Plantas.php");
    exit;
    
?>