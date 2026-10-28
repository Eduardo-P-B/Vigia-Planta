<?php
/** Normaliza o caminho da foto de uma planta e evita URLs quebradas por espaços/caminhos antigos. */
function urlFotoPlanta($foto)
{
    $fallback = 'images/sempre/planta-placeholder.svg';
    $foto = trim(str_replace('\\', '/', (string)($foto ?? '')));
    $foto = preg_replace('~/+~', '/', $foto);
    if ($foto === '') {
        return $fallback;
    }

    $foto = preg_replace('~^(?:\\./)+~', '', $foto);
    $foto = ltrim($foto, '/');
    if (strpos($foto, 'images/') !== 0) {
        $foto = 'images/' . basename($foto);
    }
    if (strpos($foto, '../') !== false) {
        return $fallback;
    }

    $caminhoFisico = dirname(__DIR__) . DIRECTORY_SEPARATOR . str_replace('/', DIRECTORY_SEPARATOR, $foto);
    if (!is_file($caminhoFisico)) {
        return $fallback;
    }

    $segmentos = explode('/', $foto);
    return implode('/', array_map('rawurlencode', $segmentos));
}

/** Retorna iniciais sem depender de serviço de avatar externo. */
function iniciaisAvatar($nome)
{
    $nome = trim((string)$nome);
    if ($nome === '') {
        return 'U';
    }
    $partes = preg_split('/\\s+/u', $nome);
    $selecionadas = array_slice($partes ?: [$nome], 0, 2);
    $iniciais = '';
    foreach ($selecionadas as $parte) {
        if ($parte === '') continue;
        if (function_exists('mb_substr')) {
            $iniciais .= mb_substr($parte, 0, 1, 'UTF-8');
        } elseif (preg_match('/^./us', $parte, $match)) {
            $iniciais .= $match[0];
        } else {
            $iniciais .= substr($parte, 0, 1);
        }
    }
    return function_exists('mb_strtoupper') ? mb_strtoupper($iniciais, 'UTF-8') : strtoupper($iniciais);
}
?>
