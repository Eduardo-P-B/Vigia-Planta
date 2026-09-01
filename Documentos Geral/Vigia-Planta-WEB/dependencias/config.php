<?php
    $host = "143.106.241.4";
    $banco = "cl205238";
    $usuario = "cl205238";
    $senha = "cl*03012008";
    $conn = new PDO("mysql:host=$host;dbname=$banco;charset=utf8", $usuario, $senha); //dsn
    $conn->setAttribute(
    PDO::ATTR_ERRMODE,
    PDO::ERRMODE_EXCEPTION
);