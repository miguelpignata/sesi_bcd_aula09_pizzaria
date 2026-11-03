-- Aula 09 - Views / Relatórios
USE Pizzaria;

-- Exemplo apresentado no material: pedidos com nome do cliente
CREATE OR REPLACE VIEW vw_pedidos1 AS
SELECT p.*, c.nome AS nome_cliente
FROM Pedidos p
INNER JOIN Clientes c ON p.cliente_id = c.cliente_id;

SELECT * FROM vw_pedidos1;

-- Desafio 1 e 2: pedidos, itens, cliente, pizza e subtotal
-- O campo Itens_Pedido.valor guarda o preço unitário registrado no pedido.
CREATE OR REPLACE VIEW vw_relatorio_pedidos_itens AS
SELECT
    p.pedido_id,
    p.data,
    p.hora,
    c.nome AS nome_cliente,
    pi.nome AS nome_pizza,
    ip.quantidade,
    ip.valor AS preco_unitario,
    (ip.valor * ip.quantidade) AS subtotal
FROM Pedidos p
INNER JOIN Clientes c ON c.cliente_id = p.cliente_id
INNER JOIN Itens_Pedido ip ON ip.pedido_id = p.pedido_id
INNER JOIN Pizzas pi ON pi.pizza_id = ip.pizza_id;

SELECT * FROM vw_relatorio_pedidos_itens
ORDER BY pedido_id, nome_pizza;

-- Desafio 3: agrupar os itens por pedido e calcular o valor total
CREATE OR REPLACE VIEW vw_total_por_pedido AS
SELECT
    p.pedido_id,
    c.nome AS nome_cliente,
    SUM(ip.quantidade * ip.valor) AS valor_total
FROM Pedidos p
INNER JOIN Clientes c ON c.cliente_id = p.cliente_id
INNER JOIN Itens_Pedido ip ON ip.pedido_id = p.pedido_id
GROUP BY p.pedido_id, c.nome;

SELECT * FROM vw_total_por_pedido
ORDER BY pedido_id;

-- Desafio 4: contar quantas pizzas cada pedido possui.
-- SUM(quantidade) conta as unidades; COUNT(*) conta as linhas/tipos.
CREATE OR REPLACE VIEW vw_quantidade_pizzas_por_pedido AS
SELECT
    p.pedido_id,
    c.nome AS nome_cliente,
    SUM(ip.quantidade) AS total_pizzas,
    COUNT(*) AS tipos_de_pizza
FROM Pedidos p
INNER JOIN Clientes c ON c.cliente_id = p.cliente_id
INNER JOIN Itens_Pedido ip ON ip.pedido_id = p.pedido_id
GROUP BY p.pedido_id, c.nome;

SELECT * FROM vw_quantidade_pizzas_por_pedido
ORDER BY pedido_id;
