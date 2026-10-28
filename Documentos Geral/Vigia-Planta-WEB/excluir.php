<?php
require "dependencias/autenticacao.php";
require "dependencias/config.php";

$id = $_SESSION["id"];
$idP = filter_input(INPUT_GET, 'idP', FILTER_VALIDATE_INT);
if (!$idP) {
    header("Location: Minhas Plantas.php");
    exit;
}

$stmt = $conn->prepare("SELECT foto FROM planta WHERE id = :idP AND userId = :id");
$stmt->bindValue(':idP', $idP, PDO::PARAM_INT);
$stmt->bindValue(':id', $id, PDO::PARAM_INT);
$stmt->execute();
$planta = $stmt->fetch(PDO::FETCH_ASSOC);

if ($planta) {
    $stmt = $conn->prepare("DELETE FROM planta WHERE id = :idP AND userId = :id");
    $stmt->bindValue(':idP', $idP, PDO::PARAM_INT);
    $stmt->bindValue(':id', $id, PDO::PARAM_INT);
    $stmt->execute();

    if ($stmt->rowCount() > 0 && !empty($planta['foto'])) {
        $caminhoFoto = realpath(__DIR__ . '/' . $planta['foto']);
        $pastaImagens = realpath(__DIR__ . '/images');
        if ($caminhoFoto && $pastaImagens &&
            strpos($caminhoFoto, $pastaImagens . DIRECTORY_SEPARATOR) === 0 &&
            is_file($caminhoFoto)) {
            unlink($caminhoFoto);
        }
    }
}

header("Location: Minhas Plantas.php");
exit;
