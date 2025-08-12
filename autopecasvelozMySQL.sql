- SQL Script para o banco de dados da AutoPeças Veloz

-- 1. Criar o banco de dados se não existir
CREATE DATABASE IF NOT EXISTS autopecas_veloz;

-- 2. Usar o banco de dados criado
USE autopecas_veloz;

-- 3. Criar a tabela 'fornecedores'
-- Armazena informações sobre os fornecedores das peças
CREATE TABLE fornecedores (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL UNIQUE,
    contato VARCHAR(100),
    telefone VARCHAR(20),
    email VARCHAR(100)
);

-- 4. Criar a tabela 'pecas'
-- Armazena informações sobre as peças disponíveis para venda
CREATE TABLE pecas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT,
    preco_custo DECIMAL(10, 2) NOT NULL,
    preco_venda DECIMAL(10, 2) NOT NULL,
    estoque INT NOT NULL DEFAULT 0,-- SQL Script para o banco de dados da AutoPeças Veloz
    id INT AUTO_INCREMENT PRIMARY KEY,
    pedido_id INT,
    peca_id INT,
    quantidade INT NOT NULL,
    preco_unitario DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (pedido_id) REFERENCES pedidos(id),
    FOREIGN KEY (peca_id) REFERENCES pecas(id)
);

-- 8. Inserir dados de exemplo

-- Inserir fornecedores
INSERT INTO fornecedores (nome, contato, telefone, email) VALUES
('Fornecedor AutoMax', 'Carlos Mendes', '(11) 91234-5678', 'carlos@automax.com.br'),
('Peças Essenciais Ltda', 'Ana Costa', '(21) 98765-4321', 'ana@pecasessenciais.com.br'),
('Distribuidora Rodas & Cia', 'Bruno Silva', '(31) 99876-5432', 'bruno@rodasecia.com.br');

-- Inserir peças
INSERT INTO pecas (nome, descricao, preco_custo, preco_venda, estoque, fornecedor_id) VALUES
('Filtro de Óleo', 'Filtro de óleo para motores 1.0 a 1.6', 15.00, 25.00, 150, 1),
('Pastilha de Freio Dianteira', 'Conjunto de pastilhas de freio para rodas dianteiras', 60.00, 110.00, 80, 2),
('Vela de Ignição (Jogo)', 'Jogo com 4 velas de ignição', 30.00, 55.00, 120, 1),
('Amortecedor Traseiro', 'Amortecedor para suspensão traseira', 120.00, 220.00, 40, 3),
('Bateria 60Ah', 'Bateria automotiva 12V 60Ah', 200.00, 350.00, 30, 2);

-- Inserir clientes
INSERT INTO clientes (nome, telefone, email, endereco) VALUES
('Mariana Souza', '(11) 99999-8888', 'mariana.souza@email.com', 'Rua das Flores, 123, São Paulo - SP'),
('Roberto Almeida', '(21) 97777-6666', 'roberto.almeida@email.com', 'Av. Central, 456, Rio de Janeiro - RJ');

-- Inserir pedidos
-- Pedido 1 para Mariana Souza
INSERT INTO pedidos (cliente_id, data_pedido, status) VALUES
(1, '2025-07-20 10:30:00', 'Entregue');

-- Itens do Pedido 1
INSERT INTO itens_pedido (pedido_id, peca_id, quantidade, preco_unitario) VALUES
(1, 1, 2, 25.00), -- 2 Filtros de Óleo
(1, 3, 1, 55.00); -- 1 Jogo de Vela de Ignição

-- Pedido 2 para Roberto Almeida
INSERT INTO pedidos (cliente_id, data_pedido, status) VALUES
(2, '2025-08-01 14:00:00', 'Pendente');

-- Itens do Pedido 2
INSERT INTO itens_pedido (pedido_id, peca_id, quantidade, preco_unitario) VALUES
(2, 2, 1, 110.00), -- 1 Pastilha de Freio Dianteira
(2, 5, 1, 350.00); -- 1 Bateria 60Ah

-- Atualizar valor_total para Pedido 1 (2*25.00 + 1*55.00 = 50.00 + 55.00 = 105.00)
UPDATE pedidos SET valor_total = (SELECT SUM(quantidade * preco_unitario) FROM itens_pedido WHERE pedido_id = 1) WHERE id = 1;

-- Atualizar valor_total para Pedido 2 (1*110.00 + 1*350.00 = 460.00)
UPDATE pedidos SET valor_total = (SELECT SUM(quantidade * preco_unitario) FROM itens_pedido WHERE pedido_id = 2) WHERE id = 2;


-- 9. Consultas de exemplo

-- Consultar todas as peças com seus fornecedores
SELECT
    p.nome AS nome_peca,
    p.descricao,
    p.preco_venda,
    p.estoque,
    f.nome AS nome_fornecedor,
    f.telefone AS telefone_fornecedor
FROM
    pecas p
JOIN
    fornecedores f ON p.fornecedor_id = f.id;

-- Consultar todos os pedidos de um cliente específico (Mariana Souza) com os itens do pedido
SELECT
    c.nome AS nome_cliente,
    p.id AS numero_pedido,
    p.data_pedido,
    p.valor_total,
    p.status,
    ip.quantidade,
    pe.nome AS nome_peca,
    ip.preco_unitario
FROM
    clientes c
JOIN
    pedidos p ON c.id = p.cliente_id
JOIN
    itens_pedido ip ON p.id = ip.pedido_id
JOIN
    pecas pe ON ip.peca_id = pe.id
WHERE

    fornecedor_id INT,
    FOREIGN KEY (fornecedor_id) REFERENCES fornecedores(id)
);

-- 5. Criar a tabela 'clientes'
-- Armazena informações sobre os clientes da loja
CREATE TABLE clientes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    telefone VARCHAR(20),
    email VARCHAR(100) UNIQUE,
    endereco TEXT
);

-- 6. Criar a tabela 'pedidos'
-- Armazena informações sobre os pedidos de peças feitos pelos clientes
CREATE TABLE pedidos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cliente_id INT,
    data_pedido DATETIME DEFAULT CURRENT_TIMESTAMP,
    valor_total DECIMAL(10, 2) DEFAULT 0.00,
    status ENUM('Pendente', 'Confirmado', 'Enviado', 'Entregue', 'Cancelado') DEFAULT 'Pendente',
    FOREIGN KEY (cliente_id) REFERENCES clientes(id)
);

-- 7. Criar a tabela 'itens_pedido'
-- Armazena os detalhes de cada item dentro de um pedido
CREATE TABLE itens_pedido (
    id INT AUTO_INCREMENT PRIMARY KEY,
    pedido_id INT,
    peca_id INT,
    quantidade INT NOT NULL,
    preco_unitario DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (pedido_id) REFERENCES pedidos(id),
    FOREIGN KEY (peca_id) REFERENCES pecas(id)
);

-- 8. Inserir dados de exemplo

-- Inserir fornecedores
INSERT INTO fornecedores (nome, contato, telefone, email) VALUES
('Fornecedor AutoMax', 'Carlos Mendes', '(11) 91234-5678', 'carlos@automax.com.br'),
('Peças Essenciais Ltda', 'Ana Costa', '(21) 98765-4321', 'ana@pecasessenciais.com.br'),
('Distribuidora Rodas & Cia', 'Bruno Silva', '(31) 99876-5432', 'bruno@rodasecia.com.br');

-- Inserir peças
INSERT INTO pecas (nome, descricao, preco_custo, preco_venda, estoque, fornecedor_id) VALUES
('Filtro de Óleo', 'Filtro de óleo para motores 1.0 a 1.6', 15.00, 25.00, 150, 1),
('Pastilha de Freio Dianteira', 'Conjunto de pastilhas de freio para rodas dianteiras', 60.00, 110.00, 80, 2),
('Vela de Ignição (Jogo)', 'Jogo com 4 velas de ignição', 30.00, 55.00, 120, 1),
('Amortecedor Traseiro', 'Amortecedor para suspensão traseira', 120.00, 220.00, 40, 3),
('Bateria 60Ah', 'Bateria automotiva 12V 60Ah', 200.00, 350.00, 30, 2);

-- Inserir clientes
INSERT INTO clientes (nome, telefone, email, endereco) VALUES
('Mariana Souza', '(11) 99999-8888', 'mariana.souza@email.com', 'Rua das Flores, 123, São Paulo - SP'),
('Roberto Almeida', '(21) 97777-6666', 'roberto.almeida@email.com', 'Av. Central, 456, Rio de Janeiro - RJ');

-- Inserir pedidos
-- Pedido 1 para Mariana Souza
INSERT INTO pedidos (cliente_id, data_pedido, status) VALUES
(1, '2025-07-20 10:30:00', 'Entregue');

-- Itens do Pedido 1
INSERT INTO itens_pedido (pedido_id, peca_id, quantidade, preco_unitario) VALUES
(1, 1, 2, 25.00), -- 2 Filtros de Óleo
(1, 3, 1, 55.00); -- 1 Jogo de Vela de Ignição

-- Pedido 2 para Roberto Almeida
INSERT INTO pedidos (cliente_id, data_pedido, status) VALUES
(2, '2025-08-01 14:00:00', 'Pendente');

-- Itens do Pedido 2
INSERT INTO itens_pedido (pedido_id, peca_id, quantidade, preco_unitario) VALUES
(2, 2, 1, 110.00), -- 1 Pastilha de Freio Dianteira
(2, 5, 1, 350.00); -- 1 Bateria 60Ah

-- Atualizar valor_total para Pedido 1 (2*25.00 + 1*55.00 = 50.00 + 55.00 = 105.00)
UPDATE pedidos SET valor_total = (SELECT SUM(quantidade * preco_unitario) FROM itens_pedido WHERE pedido_id = 1) WHERE id = 1;

-- Atualizar valor_total para Pedido 2 (1*110.00 + 1*350.00 = 460.00)
UPDATE pedidos SET valor_total = (SELECT SUM(quantidade * preco_unitario) FROM itens_pedido WHERE pedido_id = 2) WHERE id = 2;


-- 9. Consultas de exemplo

-- Consultar todas as peças com seus fornecedores
SELECT
    p.nome AS nome_peca,
    p.descricao,
    p.preco_venda,
    p.estoque,
    f.nome AS nome_fornecedor,
    f.telefone AS telefone_fornecedor
FROM
    pecas p
JOIN
    fornecedores f ON p.fornecedor_id = f.id;

-- Consultar todos os pedidos de um cliente específico (Mariana Souza) com os itens do pedido
SELECT
    c.nome AS nome_cliente,
    p.id AS numero_pedido,
    p.data_pedido,
    p.valor_total,
    p.status,
    ip.quantidade,
    pe.nome AS nome_peca,
    ip.preco_unitario
FROM
    clientes c
JOIN
    pedidos p ON c.id = p.cliente_id
JOIN
    itens_pedido ip ON p.id = ip.pedido_id
JOIN
    pecas pe ON ip.peca_id = pe.id
WHERE
    c.nome = 'Mariana Souza'
ORDER BY
    p.data_pedido DESC;

-- Consultar o estoque atual de cada peça
SELECT
    nome,
    estoque
FROM
    pecas
ORDER BY
    nome;

-- Consultar o total de vendas por peça
SELECT
    p.nome AS nome_peca,
    SUM(ip.quantidade) AS total_vendido,
    SUM(ip.quantidade * ip.preco_unitario) AS receita_total_peca
FROM
    pecas p
JOIN
    itens_pedido ip ON p.id = ip.peca_id
GROUP BY
    p.nome
ORDER BY
    receita_total_peca DESC;

