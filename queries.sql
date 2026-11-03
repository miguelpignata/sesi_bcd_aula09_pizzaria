-- Aula 09 - Consultas e manipulação de dados
USE Pizzaria;

-- A) Quantas tabelas o banco de dados possui?
SELECT COUNT(*) AS quantidade_tabelas
FROM information_schema.tables
WHERE table_schema = 'Pizzaria';

-- B) Quantos clientes estão cadastrados?
SELECT COUNT(*) AS quantidade_clientes
FROM Clientes;

-- C) Quantas pizzas estão cadastradas?
SELECT COUNT(*) AS quantidade_pizzas
FROM Pizzas;

-- D) Quantas pizzas o pedido nº 3 possui?
-- Esta primeira consulta conta as unidades (somando a quantidade).
SELECT SUM(quantidade) AS total_unidades_pedido_3
FROM Itens_Pedido
WHERE pedido_id = 3;

-- Consulta complementar: quantos tipos/linhas de pizzas existem no pedido nº 3?
SELECT COUNT(*) AS tipos_de_pizza_pedido_3
FROM Itens_Pedido
WHERE pedido_id = 3;

-- E) Qual o nome do cliente que fez o pedido nº 3?
SELECT c.nome AS nome_cliente
FROM Pedidos p
INNER JOIN Clientes c ON c.cliente_id = p.cliente_id
WHERE p.pedido_id = 3;

-- F) Quais os nomes das pizzas do pedido nº 3?
SELECT pi.nome AS nome_pizza, ip.quantidade
FROM Itens_Pedido ip
INNER JOIN Pizzas pi ON pi.pizza_id = ip.pizza_id
WHERE ip.pedido_id = 3
ORDER BY pi.nome;

-- ------------------------------------------------------------
-- DML: cadastro do cliente Gaspar e seu primeiro pedido
-- Execute este bloco uma única vez para evitar duplicar registros.

INSERT INTO Clientes (nome, logradouro, numero, bairro, referencia)
VALUES ('Gaspar Oliveira', 'Rua Lizandro Silva', 21, 'São Dimas',
        'Ao lado da igrejinha');

SET @gaspar_id = LAST_INSERT_ID();

INSERT INTO Telefones (cliente_id, telefone)
VALUES (@gaspar_id, '19 99898-1141');

-- Pedido inicial: 1 Margherita e 2 Napolitanas
INSERT INTO Pedidos (cliente_id, data, hora, valor)
VALUES (@gaspar_id, CURDATE(), CURTIME(), 0.00);

SET @pedido_inicial = LAST_INSERT_ID();

INSERT INTO Itens_Pedido (pedido_id, pizza_id, quantidade, valor)
SELECT @pedido_inicial, pizza_id, 1, valor
FROM Pizzas WHERE nome = 'Margherita';

INSERT INTO Itens_Pedido (pedido_id, pizza_id, quantidade, valor)
SELECT @pedido_inicial, pizza_id, 2, valor
FROM Pizzas WHERE nome = 'Napolitana';

UPDATE Pedidos
SET valor = (
    SELECT SUM(quantidade * valor)
    FROM Itens_Pedido
    WHERE pedido_id = @pedido_inicial
)
WHERE pedido_id = @pedido_inicial;

-- Acrescentar a pizza A moda do chef ao cardápio
INSERT INTO Pizzas (nome, descricao, valor)
VALUES (
    'A moda do chef',
    'Molho de tomate, palmito macio em rodelas, coberto com catupiry, frango desfiado, ovos, carne seca, oregano e azeitonas',
    41.90
);

-- Segundo pedido de Gaspar: inicialmente 2 pizzas A moda do chef
INSERT INTO Pedidos (cliente_id, data, hora, valor)
VALUES (@gaspar_id, CURDATE(), CURTIME(), 0.00);

SET @pedido_chef = LAST_INSERT_ID();

INSERT INTO Itens_Pedido (pedido_id, pizza_id, quantidade, valor)
SELECT @pedido_chef, pizza_id, 2, valor
FROM Pizzas WHERE nome = 'A moda do chef';

-- Atualização solicitada: alterar para 3 A moda do chef
UPDATE Itens_Pedido
SET quantidade = 3
WHERE pedido_id = @pedido_chef
  AND pizza_id = (SELECT pizza_id FROM Pizzas WHERE nome = 'A moda do chef');

-- Acrescentar 1 Margherita ao mesmo pedido
INSERT INTO Itens_Pedido (pedido_id, pizza_id, quantidade, valor)
SELECT @pedido_chef, pizza_id, 1, valor
FROM Pizzas WHERE nome = 'Margherita';

-- Recalcular o valor total do pedido atualizado
UPDATE Pedidos
SET valor = (
    SELECT SUM(quantidade * valor)
    FROM Itens_Pedido
    WHERE pedido_id = @pedido_chef
)
WHERE pedido_id = @pedido_chef;

-- Conferir os dois pedidos de Gaspar
SELECT p.pedido_id, c.nome, p.data, p.hora, p.valor,
       pi.nome AS pizza, ip.quantidade, ip.valor AS valor_unitario
FROM Pedidos p
INNER JOIN Clientes c ON c.cliente_id = p.cliente_id
INNER JOIN Itens_Pedido ip ON ip.pedido_id = p.pedido_id
INNER JOIN Pizzas pi ON pi.pizza_id = ip.pizza_id
WHERE c.nome = 'Gaspar Oliveira'
ORDER BY p.pedido_id, pi.nome;
