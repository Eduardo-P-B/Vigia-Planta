CREATE TABLE IF NOT EXISTS usuario (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    nome_usuario VARCHAR(150) NOT NULL UNIQUE,
    email VARCHAR(200) UNIQUE NOT NULL,
    senha VARCHAR(255) NOT NULL,
    data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ultimo_login TIMESTAMP NULL,
    avatar VARCHAR(255) DEFAULT 'default-avatar.png',
    ativo BOOLEAN DEFAULT TRUE
);

CREATE TABLE IF NOT EXISTS tipo_planta (
    id_tipo_planta INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT,
    umidade_ideal_min DECIMAL(5,2),
    umidade_ideal_max DECIMAL(5,2),
    temperatura_ideal_min DECIMAL(5,2),
    temperatura_ideal_max DECIMAL(5,2),
    luminosidade_ideal VARCHAR(50),
    frequencia_rega_dias INT DEFAULT 7,
    imagem_referencia VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS planta (
    id_planta INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    apelido VARCHAR(100),
    id_usuario INT NOT NULL,
    id_tipo_planta INT NOT NULL,
    data_plantio DATE,
    ultima_rega DATETIME,
    proxima_rega DATETIME,
    imagem VARCHAR(255) DEFAULT 'default-plant.png',
    status ENUM('saudavel', 'atencao', 'critico') DEFAULT 'saudavel',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT fk_planta_usuario
        FOREIGN KEY (id_usuario)
        REFERENCES usuario(id_usuario)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT fk_planta_tipo
        FOREIGN KEY (id_tipo_planta)
        REFERENCES tipo_planta(id_tipo_planta)
        ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS informacao_planta (
    id_informacao INT AUTO_INCREMENT PRIMARY KEY,
    id_planta INT NOT NULL UNIQUE,
    umidade DECIMAL(5,2),
    temperatura DECIMAL(5,2),
    luminosidade DECIMAL(5,2),
    data_medicao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_info_planta
        FOREIGN KEY (id_planta)
        REFERENCES planta(id_planta)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS historico_medicoes (
    id_historico INT AUTO_INCREMENT PRIMARY KEY,
    id_planta INT NOT NULL,
    umidade DECIMAL(5,2),
    temperatura DECIMAL(5,2),
    luminosidade DECIMAL(5,2),
    data_medicao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_historico_planta
        FOREIGN KEY (id_planta)
        REFERENCES planta(id_planta)
        ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS notificacao (
    id_notificacao INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    id_planta INT,
    titulo VARCHAR(200) NOT NULL,
    mensagem TEXT NOT NULL,
    lida BOOLEAN DEFAULT FALSE,
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    tipo VARCHAR(50) DEFAULT 'info',

    CONSTRAINT fk_notificacao_usuario
        FOREIGN KEY (id_usuario)
        REFERENCES usuario(id_usuario)
        ON DELETE CASCADE,
    
    CONSTRAINT fk_notificacao_planta
        FOREIGN KEY (id_planta)
        REFERENCES planta(id_planta)
        ON DELETE CASCADE
);

INSERT IGNORE INTO tipo_planta (id_tipo_planta, nome, descricao, umidade_ideal_min, umidade_ideal_max, temperatura_ideal_min, temperatura_ideal_max, luminosidade_ideal, frequencia_rega_dias) VALUES
(1, 'Suculenta', 'Planta que armazena água em suas folhas', 20.00, 40.00, 18.00, 28.00, 'Luz solar direta', 10),
(2, 'Samambaia', 'Planta de sombra que gosta de umidade', 60.00, 80.00, 18.00, 24.00, 'Meia sombra', 3),
(3, 'Espada de São Jorge', 'Planta resistente e de baixa manutenção', 30.00, 50.00, 15.00, 30.00, 'Luz indireta', 7),
(4, 'Orquídea', 'Planta delicada com flores exuberantes', 50.00, 70.00, 20.00, 25.00, 'Luz filtrada', 5),
(5, 'Jiboia', 'Planta pendente de fácil cultivo', 50.00, 70.00, 18.00, 28.00, 'Meia sombra', 4),
(6, 'Cacto', 'Planta adaptada a ambientes secos', 10.00, 30.00, 20.00, 35.00, 'Luz solar direta', 14),
(7, 'Lavanda', 'Planta aromática e ornamental', 30.00, 50.00, 15.00, 28.00, 'Luz solar direta', 6),
(8, 'Manjericão', 'Erva aromática para temperos', 50.00, 70.00, 20.00, 30.00, 'Luz solar direta', 2),
(9, 'Hortelã', 'Erva de fácil cultivo', 60.00, 80.00, 15.00, 25.00, 'Meia sombra', 2),
(10, 'Alecrim', 'Erva resistente e medicinal', 30.00, 50.00, 15.00, 30.00, 'Luz solar direta', 5);

INSERT IGNORE INTO usuario (id_usuario, nome, nome_usuario, email, senha) VALUES
(1, 'Usuário Teste', 'teste', 'teste@email.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi');

DROP TRIGGER IF EXISTS atualizar_status_planta;
DROP TRIGGER IF EXISTS notificar_planta_critica;
DROP TRIGGER IF EXISTS calcular_proxima_rega;

DELIMITER $$

CREATE TRIGGER atualizar_status_planta
AFTER INSERT ON informacao_planta
FOR EACH ROW
BEGIN
    DECLARE status_planta VARCHAR(20);
    DECLARE umid_min DECIMAL(5,2);
    DECLARE umid_max DECIMAL(5,2);
    DECLARE temp_min DECIMAL(5,2);
    DECLARE temp_max DECIMAL(5,2);
    
    SELECT tp.umidade_ideal_min, tp.umidade_ideal_max, 
           tp.temperatura_ideal_min, tp.temperatura_ideal_max
    INTO umid_min, umid_max, temp_min, temp_max
    FROM planta p
    JOIN tipo_planta tp ON p.id_tipo_planta = tp.id_tipo_planta
    WHERE p.id_planta = NEW.id_planta;
    
    IF NEW.umidade < umid_min * 0.7 OR NEW.umidade > umid_max * 1.3 OR
       NEW.temperatura < temp_min * 0.8 OR NEW.temperatura > temp_max * 1.2 THEN
        SET status_planta = 'critico';
    ELSEIF NEW.umidade < umid_min OR NEW.umidade > umid_max OR
           NEW.temperatura < temp_min OR NEW.temperatura > temp_max THEN
        SET status_planta = 'atencao';
    ELSE
        SET status_planta = 'saudavel';
    END IF;
    
    UPDATE planta 
    SET status = status_planta 
    WHERE id_planta = NEW.id_planta;
    
    INSERT INTO historico_medicoes (id_planta, umidade, temperatura, luminosidade)
    VALUES (NEW.id_planta, NEW.umidade, NEW.temperatura, NEW.luminosidade);
END$$

CREATE TRIGGER notificar_planta_critica
AFTER UPDATE ON planta
FOR EACH ROW
BEGIN
    IF NEW.status = 'critico' AND OLD.status != 'critico' THEN
        INSERT INTO notificacao (id_usuario, id_planta, titulo, mensagem, tipo)
        VALUES (
            NEW.id_usuario, 
            NEW.id_planta, 
            'Atenção: Planta em estado crítico', 
            CONCAT('Sua planta "', NEW.nome, '" precisa de cuidados urgentes'),
            'urgente'
        );
    ELSEIF NEW.status = 'atencao' AND OLD.status = 'saudavel' THEN
        INSERT INTO notificacao (id_usuario, id_planta, titulo, mensagem, tipo)
        VALUES (
            NEW.id_usuario, 
            NEW.id_planta, 
            'Alerta: Planta precisa de atenção', 
            CONCAT('Sua planta "', NEW.nome, '" está com parâmetros fora do ideal'),
            'alerta'
        );
    END IF;
END$$

CREATE TRIGGER calcular_proxima_rega
BEFORE UPDATE ON planta
FOR EACH ROW
BEGIN
    IF NEW.ultima_rega IS NOT NULL AND (OLD.ultima_rega IS NULL OR NEW.ultima_rega != OLD.ultima_rega) THEN
        SELECT frequencia_rega_dias INTO @frequencia
        FROM tipo_planta 
        WHERE id_tipo_planta = NEW.id_tipo_planta;
        
        SET NEW.proxima_rega = DATE_ADD(NEW.ultima_rega, INTERVAL @frequencia DAY);
    END IF;
END$$

DELIMITER ;

DROP PROCEDURE IF EXISTS atualizar_proximas_regas;
DROP PROCEDURE IF EXISTS obter_estatisticas_usuario;
DROP PROCEDURE IF EXISTS plantas_precisam_rega;
DROP PROCEDURE IF EXISTS ultimas_medicoes;

DELIMITER $$

CREATE PROCEDURE atualizar_proximas_regas()
BEGIN
    UPDATE planta p
    JOIN tipo_planta tp ON p.id_tipo_planta = tp.id_tipo_planta
    SET p.proxima_rega = DATE_ADD(p.ultima_rega, INTERVAL tp.frequencia_rega_dias DAY)
    WHERE p.ultima_rega IS NOT NULL;
END$$

CREATE PROCEDURE obter_estatisticas_usuario(IN p_id_usuario INT)
BEGIN
    SELECT 
        COUNT(*) as total_plantas,
        SUM(CASE WHEN status = 'saudavel' THEN 1 ELSE 0 END) as plantas_saudaveis,
        SUM(CASE WHEN status = 'atencao' THEN 1 ELSE 0 END) as plantas_atencao,
        SUM(CASE WHEN status = 'critico' THEN 1 ELSE 0 END) as plantas_criticas,
        COUNT(DISTINCT id_tipo_planta) as tipos_diferentes
    FROM planta
    WHERE id_usuario = p_id_usuario;
END$$

CREATE PROCEDURE plantas_precisam_rega(IN p_id_usuario INT)
BEGIN
    SELECT p.*, tp.nome as tipo_nome
    FROM planta p
    JOIN tipo_planta tp ON p.id_tipo_planta = tp.id_tipo_planta
    WHERE p.id_usuario = p_id_usuario 
      AND p.proxima_rega <= NOW()
      AND p.ultima_rega IS NOT NULL
    ORDER BY p.proxima_rega ASC;
END$$

CREATE PROCEDURE ultimas_medicoes(IN p_id_planta INT, IN p_limite INT)
BEGIN
    SELECT * FROM historico_medicoes
    WHERE id_planta = p_id_planta
    ORDER BY data_medicao DESC
    LIMIT p_limite;
END$$

DELIMITER ;

DROP VIEW IF EXISTS dashboard_usuario;
DROP VIEW IF EXISTS resumo_plantas;

CREATE VIEW dashboard_usuario AS
SELECT 
    u.id_usuario,
    u.nome,
    COUNT(DISTINCT p.id_planta) as total_plantas,
    COUNT(DISTINCT CASE WHEN p.status = 'saudavel' THEN p.id_planta END) as saudaveis,
    COUNT(DISTINCT CASE WHEN p.status = 'atencao' THEN p.id_planta END) as atencao,
    COUNT(DISTINCT CASE WHEN p.status = 'critico' THEN p.id_planta END) as criticos,
    COUNT(DISTINCT CASE WHEN n.lida = FALSE THEN n.id_notificacao END) as notificacoes_nao_lidas
FROM usuario u
LEFT JOIN planta p ON u.id_usuario = p.id_usuario
LEFT JOIN notificacao n ON u.id_usuario = n.id_usuario AND n.lida = FALSE
GROUP BY u.id_usuario;

CREATE VIEW resumo_plantas AS
SELECT 
    p.id_planta,
    p.nome,
    p.apelido,
    p.status,
    p.imagem,
    tp.nome as tipo,
    ip.umidade,
    ip.temperatura,
    ip.luminosidade,
    tp.umidade_ideal_min,
    tp.umidade_ideal_max,
    tp.temperatura_ideal_min,
    tp.temperatura_ideal_max,
    CASE 
        WHEN ip.umidade < tp.umidade_ideal_min THEN 'baixa'
        WHEN ip.umidade > tp.umidade_ideal_max THEN 'alta'
        ELSE 'ideal'
    END as status_umidade
FROM planta p
JOIN tipo_planta tp ON p.id_tipo_planta = tp.id_tipo_planta
LEFT JOIN informacao_planta ip ON p.id_planta = ip.id_planta;

