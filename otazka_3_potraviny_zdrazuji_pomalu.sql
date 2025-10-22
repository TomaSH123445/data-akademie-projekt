-- 3️⃣ Která kategorie potravin zdražuje nejpomaleji (nejnižší meziroční nárůst)?
SELECT 
    kategorie,
    ROUND(AVG(rust_procenta), 2) AS prumerny_rocni_rust_procent
FROM t_tomas_havelec_project_sql_secondary_final
WHERE rust_procenta IS NOT NULL
GROUP BY kategorie
ORDER BY prumerny_rocni_rust_procent ASC
LIMIT 1;