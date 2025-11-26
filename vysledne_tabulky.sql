-- ==============================================
-- Autor: Tomáš Havelec
-- ==============================================

-- 1) Primární tabulka
CREATE TABLE t_tomas_havelec_project_sql_primary_final AS
WITH mzdy AS (
  SELECT payroll_year AS rok, AVG(value::numeric) AS prumerna_mzda
  FROM czechia_payroll cp
  JOIN czechia_payroll_value_type vt ON cp.value_type_code = vt.code
  JOIN czechia_payroll_unit u       ON cp.unit_code        = u.code
  WHERE vt.code = 5958
    AND u.code = 200
  GROUP BY payroll_year
),
mleko AS (
  SELECT EXTRACT(YEAR FROM p.date_from)::int AS rok, AVG(p.value::numeric) AS cena_mlika
  FROM czechia_price p
  JOIN czechia_price_category c ON p.category_code = c.code
  WHERE c.name ILIKE '%mléko%' 
    AND c.price_unit ILIKE '%l%'
  GROUP BY EXTRACT(YEAR FROM p.date_from)::int
),
chleb AS (
  SELECT EXTRACT(YEAR FROM p.date_from)::int AS rok, AVG(p.value::numeric) AS cena_chleba
  FROM czechia_price p
  JOIN czechia_price_category c ON p.category_code = c.code
  WHERE c.name ILIKE '%chléb%' 
    AND c.price_unit ILIKE '%kg%'
  GROUP BY EXTRACT(YEAR FROM p.date_from)::int
),
jidlo AS (
  SELECT EXTRACT(YEAR FROM p.date_from)::int AS rok, AVG(p.value::numeric) AS prumerna_cena_jidla
  FROM czechia_price p
  GROUP BY EXTRACT(YEAR FROM p.date_from)::int
)
SELECT 
    m.rok,
    m.prumerna_mzda,
    j.prumerna_cena_jidla,
    ml.cena_mlika,
    ch.cena_chleba,
    ROUND(m.prumerna_mzda / ml.cena_mlika, 1) AS litru_mlika_za_mzdu,
    ROUND(m.prumerna_mzda / ch.cena_chleba, 1) AS kg_chleba_za_mzdu
FROM mzdy m
LEFT JOIN jidlo j ON j.rok = m.rok
LEFT JOIN mleko ml ON ml.rok = m.rok
LEFT JOIN chleb ch ON ch.rok = m.rok
WHERE ml.cena_mlika IS NOT NULL
  AND ch.cena_chleba IS NOT NULL
ORDER BY m.rok;

-- 2) Sekundární tabulka
CREATE TABLE t_tomas_havelec_project_sql_secondary_final AS
WITH rocni_ceny AS (
  SELECT 
    'Česko'::text AS stat,
    kat.code AS kod_kategorie,
    kat.name AS kategorie,
    EXTRACT(YEAR FROM p.date_from)::int AS rok,
    AVG(p.value::numeric) AS prumerna_cena
  FROM czechia_price p
  JOIN czechia_price_category kat ON p.category_code = kat.code
  GROUP BY kat.code, kat.name, EXTRACT(YEAR FROM p.date_from)::int
),
rust AS (
  SELECT 
    stat,
    kod_kategorie,
    kategorie,
    rok,
    prumerna_cena,
    LAG(prumerna_cena) OVER (PARTITION BY kod_kategorie ORDER BY rok) AS cena_minuly_rok,
    CASE
      WHEN LAG(prumerna_cena) OVER (PARTITION BY kod_kategorie ORDER BY rok) IS NOT NULL
      THEN ROUND(((prumerna_cena / LAG(prumerna_cena) OVER (PARTITION BY kod_kategorie ORDER BY rok) - 1) * 100)::numeric, 2)
    END AS rust_procenta
  FROM rocni_ceny
),
ekonomika AS (
  SELECT
    e.country   AS stat,
    e.year      AS rok,
    e.gdp       AS hdp,
    e.gini      AS gini,
    e.population AS populace,
    ROUND((100 * (e.gdp / NULLIF(LAG(e.gdp) OVER (PARTITION BY e.country ORDER BY e.year), 0) - 1))::numeric, 2) AS rust_hdp_procenta
  FROM economies e
  JOIN countries c ON c.country = e.country
  WHERE c.continent = 'Europe'
)
SELECT 
  r.stat,
  r.kod_kategorie,
  r.kategorie,
  r.rok,
  r.prumerna_cena,
  r.cena_minuly_rok,
  r.rust_procenta,
  e.hdp,
  e.gini,
  e.populace,
  e.rust_hdp_procenta
FROM rust r
LEFT JOIN ekonomika e 
  ON e.rok = r.rok AND e.stat = 'Czech Republic'
WHERE r.cena_minuly_rok IS NOT NULL
ORDER BY r.kategorie, r.rok;
