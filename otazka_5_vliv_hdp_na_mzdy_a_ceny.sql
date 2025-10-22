-- 5️⃣ Má výška HDP vliv na změny ve mzdách a cenách potravin?
WITH rust_mezd AS (
    SELECT 
        rok,
        ROUND((prumerna_mzda / LAG(prumerna_mzda) OVER (ORDER BY rok) - 1) * 100, 2) AS rust_mezd_procent
    FROM t_tomas_havelec_project_sql_primary_final
)
SELECT 
    s.rok,
    s.hdp,
    ROUND(AVG(s.rust_procenta), 2) AS rust_cen_procent,
    m.rust_mezd_procent
FROM t_tomas_havelec_project_sql_secondary_final s
LEFT JOIN rust_mezd m ON s.rok = m.rok
GROUP BY s.rok, s.hdp, m.rust_mezd_procent
ORDER BY s.rok;