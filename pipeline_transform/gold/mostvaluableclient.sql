-- =============================================================
-- Tabela Gold: mostvaluableclient
-- Descrição: Métricas de negócio e segmentação de clientes
-- Fonte: silver.fact_transaction_revenue
-- =============================================================

CREATE OR REFRESH LIVE TABLE gold.mostvaluableclient AS
SELECT 
  customer_sk,
  customer_name,
  segmento,
  pais,
  estado,
  cidade,
  COUNT(*)                 AS total_transacoes,
  SUM(gross_value)         AS valor_total,
  AVG(gross_value)         AS ticket_medio,
  MIN(data_hora)           AS primeira_transacao,
  MAX(data_hora)           AS ultima_transacao,
  SUM(CASE WHEN data_hora >= date_sub(current_timestamp(), 30) THEN 1 ELSE 0 END) AS transacoes_ultimos_30_dias,
  SUM(fee_revenue)         AS comissao_total,
  RANK() OVER (ORDER BY COUNT(*) DESC) AS ranking_por_transacoes,
  CASE 
    WHEN RANK() OVER (ORDER BY COUNT(*) DESC) = 1 THEN 'Top 1'
    WHEN RANK() OVER (ORDER BY COUNT(*) DESC) = 2 THEN 'Top 2'
    WHEN RANK() OVER (ORDER BY COUNT(*) DESC) = 3 THEN 'Top 3'
    ELSE 'Outros'
  END AS classificacao_cliente,
  current_timestamp()      AS calculated_at
FROM LIVE.silver.fact_transaction_revenue
GROUP BY customer_sk, customer_name, segmento, pais, estado, cidade;
