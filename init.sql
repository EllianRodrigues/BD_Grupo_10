-- Tabela Pessoa
CREATE TABLE Pessoa (
    cpf CHAR(11) PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cep CHAR(8),
    rua VARCHAR(150),
    numero_casa INTEGER,
    complemento VARCHAR(50)
);

-- Tabela Numero (Telefones)
CREATE TABLE Numero (
    id_numero SERIAL PRIMARY KEY,
    cpf_pessoa CHAR(11) NOT NULL,
    numero VARCHAR(15) NOT NULL,
    FOREIGN KEY (cpf_pessoa) REFERENCES Pessoa(cpf)
);

-- Tabela Sala
CREATE TABLE Sala (
    numero_sala INTEGER PRIMARY KEY,
    capacidade_sala INTEGER NOT NULL CHECK (capacidade_sala > 0),
    tipo_sala VARCHAR(50)
);

-- Tabela Filme
CREATE TABLE Filme (
    id_filme SERIAL PRIMARY KEY,
    diretor VARCHAR(100),
    genero VARCHAR(50),
    titulo VARCHAR(150) NOT NULL,
    duracao INTEGER CHECK (duracao > 0),
    classificacao VARCHAR(20)
);

-- Tabela Produto (Super-tipo para Ingresso e Comida)
CREATE TABLE Produto (
    id_produto SERIAL PRIMARY KEY
);

--------------------------------------------------------------------------------------------------------------

-- Tabela Funcionario (Herda de Pessoa)
CREATE TABLE Funcionario (
    cpf_funcionario CHAR(11) PRIMARY KEY,
    salario NUMERIC(10, 2) NOT NULL CHECK (salario >= 0),
    FOREIGN KEY (cpf_funcionario) REFERENCES Pessoa(cpf)
);

-- Tabela Cliente (Herda de Pessoa)
CREATE TABLE Cliente (
    cpf_cliente CHAR(11) PRIMARY KEY,
    data_ultima_visita DATE,
    FOREIGN KEY (cpf_cliente) REFERENCES Pessoa(cpf)
);

-- Tabela Vendedor (Herda de Funcionario)
CREATE TABLE Vendedor (
    cpf_vendedor CHAR(11) PRIMARY KEY,
    comissao NUMERIC(5, 2) CHECK (comissao >= 0 AND comissao <= 100),
    FOREIGN KEY (cpf_vendedor) REFERENCES Funcionario(cpf_funcionario)
);

-- Tabela Zelador (Herda de Funcionario)
CREATE TABLE Zelador (
    cpf_zelador CHAR(11) PRIMARY KEY,
    turno VARCHAR(20) NOT NULL,
    FOREIGN KEY (cpf_zelador) REFERENCES Funcionario(cpf_funcionario)
);

-- Tabela Sessao
CREATE TABLE Sessao (
    id_sessao SERIAL PRIMARY KEY,
    id_filme INTEGER NOT NULL,
    idioma VARCHAR(50),
    data_hora TIMESTAMP NOT NULL,
    numero_sala INTEGER NOT NULL,
    FOREIGN KEY (id_filme) REFERENCES Filme(id_filme),
    FOREIGN KEY (numero_sala) REFERENCES Sala(numero_sala)
);

-- Tabela Ingresso (Herda de Produto)
CREATE TABLE Ingresso (
    id_produto INTEGER PRIMARY KEY,
    poltrona VARCHAR(10),
    preco_ingresso NUMERIC(10, 2) NOT NULL CHECK (preco_ingresso >= 0),
    tipo VARCHAR(50),
    nome_ingresso VARCHAR(100),
    id_sessao INTEGER NOT NULL,
    FOREIGN KEY (id_produto) REFERENCES Produto(id_produto),
    FOREIGN KEY (id_sessao) REFERENCES Sessao(id_sessao)
);

-- Tabela Comida (Herda de Produto)
CREATE TABLE Comida (
    id_produto INTEGER PRIMARY KEY,
    preco_comida NUMERIC(10, 2) NOT NULL CHECK (preco_comida >= 0),
    nome_comida VARCHAR(100),
    FOREIGN KEY (id_produto) REFERENCES Produto(id_produto)
);

-------------------------------------------------------------------------------------------------

-- Tabela Vende (Vendedor - Produto)
CREATE TABLE Vende (
    cpf_vendedor CHAR(11) NOT NULL,
    id_produto INTEGER NOT NULL,
    PRIMARY KEY (cpf_vendedor, id_produto),
    FOREIGN KEY (cpf_vendedor) REFERENCES Vendedor(cpf_vendedor),
    FOREIGN KEY (id_produto) REFERENCES Produto(id_produto)
);

-- Tabela Compra (Cliente - Produto)
CREATE TABLE Compra (
    cpf_cliente CHAR(11) NOT NULL,
    id_produto INTEGER NOT NULL,
    PRIMARY KEY (cpf_cliente, id_produto),
    FOREIGN KEY (cpf_cliente) REFERENCES Cliente(cpf_cliente),
    FOREIGN KEY (id_produto) REFERENCES Produto(id_produto)
);

-- Tabela Assiste (Cliente - Sessao)
CREATE TABLE Assiste (
    cpf_cliente CHAR(11) NOT NULL,
    id_sessao INTEGER NOT NULL,
    PRIMARY KEY (cpf_cliente, id_sessao),
    FOREIGN KEY (cpf_cliente) REFERENCES Cliente(cpf_cliente),
    FOREIGN KEY (id_sessao) REFERENCES Sessao(id_sessao)
);

-- Tabela Limpa (Zelador - Sala)
CREATE TABLE Limpa (
    cpf_zelador CHAR(11) NOT NULL,
    numero_sala INTEGER NOT NULL,
    hora_limpeza TIME NOT NULL,
    observacao TEXT,
    PRIMARY KEY (cpf_zelador, numero_sala, hora_limpeza),
    FOREIGN KEY (cpf_zelador) REFERENCES Zelador(cpf_zelador),
    FOREIGN KEY (numero_sala) REFERENCES Sala(numero_sala)
);

-----------------------Mapeamento-----------------------------

-- 1. Inserindo Pessoas
INSERT INTO Pessoa (cpf, nome, cep, rua, numero_casa, complemento) VALUES
('11111111111', 'Ana Silva', '50000001', 'Rua das Flores', 101, 'Apt 1'),
('22222222222', 'Bruno Souza', '50000002', 'Av. Brasil', 200, NULL),
('33333333333', 'Carla Dias', '50000003', 'Rua do Sol', 35, 'Casa B'),
('44444444444', 'Daniel Lima', '50000004', 'Av. Boa Viagem', 1500, 'Cob 01'),
('55555555555', 'Eduardo Melo', '51000001', 'Rua A', 10, NULL), -- Vendedor
('66666666666', 'Fernanda Costa', '51000002', 'Rua B', 20, NULL), -- Vendedor
('77777777777', 'Gabriel Rocha', '51000003', 'Rua C', 30, NULL), -- Vendedor
('88888888888', 'Helena Alves', '51000004', 'Rua D', 40, NULL), -- Vendedor
('99999999999', 'Igor Santos', '52000001', 'Rua X', 5, NULL), -- Zelador
('10101010101', 'Julia Moraes', '52000002', 'Rua Y', 6, NULL), -- Zelador
('12121212121', 'Kleber Pires', '52000003', 'Rua Z', 7, NULL), -- Zelador
('13131313131', 'Laura Nunes', '52000004', 'Rua W', 8, NULL); -- Zelador

-- 2. Inserindo Telefones
INSERT INTO Numero (cpf_pessoa, numero) VALUES
('11111111111', '81999991111'),
('22222222222', '81999992222'),
('33333333333', '81999993333'),
('44444444444', '81999994444');

-- 3. Inserindo Salas
INSERT INTO Sala (numero_sala, capacidade_sala, tipo_sala) VALUES
(1, 100, '2D Padrão'),
(2, 150, '3D IMAX'),
(3, 80, 'VIP'),
(4, 120, '4DX');

-- 4. Inserindo Filmes
INSERT INTO Filme (diretor, genero, titulo, duracao, classificacao) VALUES
('Christopher Nolan', 'Ficção', 'Interestelar', 169, '10 anos'),
('Greta Gerwig', 'Comédia', 'Barbie', 114, '12 anos'),
('Francis Ford Coppola', 'Drama', 'O Poderoso Chefão', 175, '14 anos'),
('Hayao Miyazaki', 'Animação', 'A Viagem de Chihiro', 125, 'Livre');

-- 5. Inserindo Produtos
INSERT INTO Produto DEFAULT VALUES; -- ID 1
INSERT INTO Produto DEFAULT VALUES; -- ID 2
INSERT INTO Produto DEFAULT VALUES; -- ID 3
INSERT INTO Produto DEFAULT VALUES; -- ID 4
INSERT INTO Produto DEFAULT VALUES; -- ID 5
INSERT INTO Produto DEFAULT VALUES; -- ID 6
INSERT INTO Produto DEFAULT VALUES; -- ID 7
INSERT INTO Produto DEFAULT VALUES; -- ID 8

-- 6. Inserindo Clientes
INSERT INTO Cliente (cpf_cliente, data_ultima_visita) VALUES
('11111111111', '2023-10-01'),
('22222222222', '2023-10-05'),
('33333333333', '2023-10-10'),
('44444444444', '2023-10-15');

-- 7. Inserindo Funcionarios 
INSERT INTO Funcionario (cpf_funcionario, salario) VALUES
('55555555555', 2500.00),
('66666666666', 2500.00),
('77777777777', 2500.00),
('88888888888', 2600.00),
('99999999999', 1800.00),
('10101010101', 1800.00),
('12121212121', 1900.00),
('13131313131', 1800.00);

-- 8. Inserindo Comidas 
INSERT INTO Comida (id_produto, preco_comida, nome_comida) VALUES
(1, 20.00, 'Pipoca Grande'),
(2, 15.00, 'Refrigerante 500ml'),
(3, 12.00, 'Nachos'),
(4, 8.00, 'Chocolate');

-- 9. Inserindo Sessoes 
INSERT INTO Sessao (id_filme, idioma, data_hora, numero_sala) VALUES
(1, 'Legendado', '2023-11-01 14:00:00', 1),
(2, 'Dublado', '2023-11-01 16:00:00', 2),
(3, 'Legendado', '2023-11-01 19:00:00', 3),
(4, 'Dublado', '2023-11-01 20:00:00', 4);

-- 10. Inserindo Vendedores
INSERT INTO Vendedor (cpf_vendedor, comissao) VALUES
('55555555555', 5.00),
('66666666666', 5.00),
('77777777777', 4.50),
('88888888888', 6.00);

-- 11. Inserindo Zeladores
INSERT INTO Zelador (cpf_zelador, turno) VALUES
('99999999999', 'Manhã'),
('10101010101', 'Tarde'),
('12121212121', 'Noite'),
('13131313131', 'Madrugada');

-- 12. Inserindo Ingressos
INSERT INTO Ingresso (id_produto, poltrona, preco_ingresso, tipo, nome_ingresso, id_sessao) VALUES
(5, 'A10', 30.00, 'Inteira', 'Interestelar 14h', 1),
(6, 'B05', 15.00, 'Meia', 'Barbie 16h', 2),
(7, 'C12', 50.00, 'VIP', 'O Poderoso Chefão 19h', 3),
(8, 'D08', 40.00, 'Inteira', 'Chihiro 20h', 4);

-- 13. Inserindo Vende (Vendedor vende Produto)
INSERT INTO Vende (cpf_vendedor, id_produto) VALUES
('55555555555', 1), -- Eduardo vendeu Pipoca
('66666666666', 5), -- Fernanda vendeu Ingresso A10
('77777777777', 2), -- Gabriel vendeu Refri
('88888888888', 7); -- Helena vendeu Ingresso VIP

-- 14. Inserindo Compra (Cliente compra Produto)
INSERT INTO Compra (cpf_cliente, id_produto) VALUES
('11111111111', 1), -- Ana comprou Pipoca
('22222222222', 5), -- Bruno comprou Ingresso A10
('33333333333', 2), -- Carla comprou Refri
('44444444444', 7); -- Daniel comprou Ingresso VIP

-- 15. Inserindo Assiste (Cliente assiste Sessao)
INSERT INTO Assiste (cpf_cliente, id_sessao) VALUES
('11111111111', 1), -- Ana assiste Sessao 1
('22222222222', 2), -- Bruno assiste Sessao 2
('33333333333', 3), -- Carla assiste Sessao 3
('44444444444', 4); -- Daniel assiste Sessao 4

-- 16. Inserindo Limpa 
INSERT INTO Limpa (cpf_zelador, numero_sala, hora_limpeza, observacao) VALUES
('99999999999', 1, '13:00:00', 'Limpeza pré-sessão'),
('10101010101', 2, '15:30:00', 'Recolhimento de lixo'),
('12121212121', 3, '18:30:00', 'Limpeza completa'),
('13131313131', 4, '22:00:00', 'Manutenção de poltrona');