CREATE TABLE usuario(
	id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
	nome_usuario VARCHAR(150) NOT NULL,
    email VARCHAR(200) UNIQUE NOT NULL,
    senha VARCHAR(50) NOT NULL
    );
    
CREATE TABLE tipo_planta(
	id_tipo_planta INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT
);

CREATE TABLE planta (
    id_planta INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    id_usuario INT NOT NULL,
    id_tipo_planta INT NOT NULL,

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

CREATE TABLE informacao_planta (
    id_informacao INT AUTO_INCREMENT PRIMARY KEY,
    id_planta INT NOT NULL UNIQUE,
    umidade DECIMAL(5,2),
    temperatura DECIMAL(5,2),
    luminosidade DECIMAL(5,2),

    CONSTRAINT fk_info_planta
        FOREIGN KEY (id_planta)
        REFERENCES planta(id_planta)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
