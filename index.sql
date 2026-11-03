-- Aula 09 - Índices
USE Pizzaria;

-- Consultas iniciais e estrutura da tabela
SELECT * FROM Clientes;
DESCRIBE Clientes;

-- Testes de busca por nome
SELECT * FROM Clientes WHERE nome = 'Adelcio Biazi';
SELECT * FROM Clientes WHERE nome LIKE 'Adelcio';
SELECT * FROM Clientes WHERE nome LIKE '%Ana%';
SELECT * FROM Clientes WHERE nome LIKE 'Ana%';

-- Criar índice para melhorar buscas pelo início do nome
CREATE INDEX i_nome ON Clientes(nome);

-- Conferir se o índice foi criado (a coluna nome deve aparecer como MUL)
DESCRIBE Clientes;

-- Testar novamente a busca
SELECT * FROM Clientes WHERE nome LIKE 'Ana%';

-- Observação: índices podem acelerar consultas, mas ocupam espaço
-- e podem deixar INSERT/UPDATE/DELETE um pouco mais lentos.
-- Para executar novamente, remova antes o índice:
-- DROP INDEX i_nome ON Clientes;
