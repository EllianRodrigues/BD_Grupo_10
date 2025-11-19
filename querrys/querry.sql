SELECT * FROM pessoa;

-- 1. Filmes mais assistidos
SELECT f.titulo,
       COUNT(a.cpf_cliente) AS total_espectadores
FROM Filme f
JOIN Sessao s ON s.id_filme = f.id_filme
LEFT JOIN Assiste a ON a.id_sessao = s.id_sessao
GROUP BY f.titulo
ORDER BY total_espectadores DESC;

-- 2. Arrecadação total por sala (somente ingressos)
SELECT sa.numero_sala,
       sa.capacidade_sala,
       SUM(i.preco_ingresso) AS total_arrecadado
FROM Sala sa
JOIN Sessao se ON se.numero_sala = sa.numero_sala
JOIN Ingresso i ON i.id_sessao = se.id_sessao
GROUP BY sa.numero_sala, sa.capacidade_sala
ORDER BY total_arrecadado DESC;

-- 3. Funcionários que também são clientes
SELECT pe.cpf, pe.nome
FROM Pessoa pe
JOIN Funcionario f ON f.cpf_funcionario = pe.cpf
JOIN Cliente c ON c.cpf_cliente = pe.cpf;

-- 4. Top vendedores por valor total vendido
SELECT v.cpf_vendedor,
       pe.nome,
       SUM(
           COALESCE(i.preco_ingresso, 0) +
           COALESCE(c.preco_comida, 0)
       ) AS valor_total_vendido
FROM Vendedor v
JOIN Pessoa pe ON pe.cpf = v.cpf_vendedor
JOIN Vende ve ON ve.cpf_vendedor = v.cpf_vendedor
LEFT JOIN Ingresso i ON i.id_produto = ve.id_produto
LEFT JOIN Comida c ON c.id_produto = ve.id_produto
GROUP BY v.cpf_vendedor, pe.nome
ORDER BY valor_total_vendido DESC;

-- 5. Sessões sem espectadores
SELECT s.id_sessao, f.titulo, s.data_hora, s.numero_sala
FROM Sessao s
JOIN Filme f ON f.id_filme = s.id_filme
LEFT JOIN Assiste a ON a.id_sessao = s.id_sessao
WHERE a.cpf_cliente IS NULL;

-- 6. Clientes que compraram somente comidas e nunca ingressos
SELECT c.cpf_cliente, pe.nome
FROM Cliente c
JOIN Pessoa pe ON pe.cpf = c.cpf_cliente
WHERE NOT EXISTS (
    SELECT 1
    FROM Compra cp
    JOIN Ingresso i ON i.id_produto = cp.id_produto
    WHERE cp.cpf_cliente = c.cpf_cliente
)
AND EXISTS (
    SELECT 1
    FROM Compra cp
    JOIN Comida co ON co.id_produto = cp.id_produto
    WHERE cp.cpf_cliente = c.cpf_cliente
);

-- 7. Salas mais limpas
SELECT sa.numero_sala,
       COUNT(l.cpf_zelador) AS qtd_limpezas
FROM Sala sa
JOIN Limpa l ON l.numero_sala = sa.numero_sala
GROUP BY sa.numero_sala
ORDER BY qtd_limpezas DESC;

-- 8. Filmes exibidos em mais de uma sala
SELECT f.titulo,
       COUNT(DISTINCT s.numero_sala) AS qtd_salas
FROM Filme f
JOIN Sessao s ON s.id_filme = f.id_filme
GROUP BY f.titulo
HAVING COUNT(DISTINCT s.numero_sala) > 1;

-- 9. Sessões com lotação acima de 80%
SELECT s.id_sessao,
       f.titulo,
       sa.capacidade_sala,
       COUNT(a.cpf_cliente) AS ocupacao,
       ROUND((COUNT(a.cpf_cliente)::NUMERIC / sa.capacidade_sala) * 100, 2) AS percentual
FROM Sessao s
JOIN Sala sa ON sa.numero_sala = s.numero_sala
JOIN Filme f ON f.id_filme = s.id_filme
LEFT JOIN Assiste a ON a.id_sessao = s.id_sessao
GROUP BY s.id_sessao, f.titulo, sa.capacidade_sala
HAVING COUNT(a.cpf_cliente) >= sa.capacidade_sala * 0.8;

-- 10. Total gasto por cada cliente
SELECT c.cpf_cliente,
       pe.nome,
       SUM(COALESCE(i.preco_ingresso, 0) + COALESCE(co.preco_comida, 0)) AS total_gasto
FROM Cliente c
JOIN Pessoa pe ON pe.cpf = c.cpf_cliente
JOIN Compra cp ON cp.cpf_cliente = c.cpf_cliente
LEFT JOIN Ingresso i ON i.id_produto = cp.id_produto
LEFT JOIN Comida co ON co.id_produto = cp.id_produto
GROUP BY c.cpf_cliente, pe.nome
ORDER BY total_gasto DESC;

-- 11. Vendedores que venderam mais ingressos que comidas
SELECT v.cpf_vendedor,
       pe.nome,
       COUNT(i.id_produto) AS ingressos_vendidos,
       COUNT(c.id_produto) AS comidas_vendidas
FROM Vendedor v
JOIN Pessoa pe ON pe.cpf = v.cpf_vendedor
JOIN Vende ve ON ve.cpf_vendedor = v.cpf_vendedor
LEFT JOIN Ingresso i ON i.id_produto = ve.id_produto
LEFT JOIN Comida c ON c.id_produto = ve.id_produto
GROUP BY v.cpf_vendedor, pe.nome
HAVING COUNT(i.id_produto) > COUNT(c.id_produto);

-- 12. Zelador que fez a limpeza imediatamente anterior à sessão
SELECT s.id_sessao, s.data_hora, s.numero_sala,
       z.cpf_zelador, pe.nome AS zelador
FROM Sessao s
JOIN Limpa l ON l.numero_sala = s.numero_sala
JOIN Zelador z ON z.cpf_zelador = l.cpf_zelador
JOIN Pessoa pe ON pe.cpf = z.cpf_zelador
WHERE l.hora_limpeza = (
    SELECT MAX(l2.hora_limpeza)
    FROM Limpa l2
    WHERE l2.numero_sala = s.numero_sala
      AND l2.hora_limpeza < CAST(s.data_hora AS TIME)
);

-- 13. Clientes que assistiram mais de 1 filme
SELECT c.cpf_cliente,
       pe.nome,
       COUNT(DISTINCT s.id_filme) AS qtd_filmes
FROM Cliente c
JOIN Pessoa pe ON pe.cpf = c.cpf_cliente
JOIN Assiste a ON a.cpf_cliente = c.cpf_cliente
JOIN Sessao s ON s.id_sessao = a.id_sessao
GROUP BY c.cpf_cliente, pe.nome
HAVING COUNT(DISTINCT s.id_filme) > 1;
