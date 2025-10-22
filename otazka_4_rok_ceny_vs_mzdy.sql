-- 4️⃣ Existuje rok, ve kterém byl růst cen potravin výrazně vyšší než růst mezd (více než o 10 %)?
WITH rust AS (
    SELECT 
        rok,
        ROUND((prumerna_mzda / LAG(prumerna_mzda) OVER (ORDER BY rok) - 1) * 100, 2) AS rust_mezd_procent,
        ROUND((prumerna_cena_jidla / LAG(prumerna_cena_jidla) OVER (ORDER BY rok) - 1) * 100, 2) AS rust_cen_procent
    FROM t_tomas_havelec_project_sql_primary_final
)
SELECT 
    rok,
    rust_mezd_procent,
    rust_cen_procent,
    (rust_cen_procent - rust_mezd_procent) AS rozdil_procent
FROM rust
WHERE (rust_cen_procent - rust_mezd_procent) < 10
ORDER BY rozdil_procent DESC;