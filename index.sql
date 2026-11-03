USE Pizzaria;

SELECT * FROM Clientes;
DESCRIBE Clientes;

SELECT * FROM Clientes WHERE nome = 'Adelcio Biazi';
SELECT * FROM Clientes WHERE nome LIKE 'Adelcio';
SELECT * FROM Clientes WHERE nome LIKE '%Ana%';
SELECT * FROM Clientes WHERE nome LIKE 'Ana%';

CREATE INDEX i_nome ON Clientes(nome);

DESCRIBE Clientes;

SELECT * FROM Clientes WHERE nome LIKE 'Ana%';