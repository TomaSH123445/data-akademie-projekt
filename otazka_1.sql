-- Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?
SELECT 
    rok,
    ROUND(prumerna_mzda, 2) AS prumerna_mzda,
    LAG(prumerna_mzda) OVER (ORDER BY rok) AS predchozi_mzda,
    ROUND((prumerna_mzda / LAG(prumerna_mzda) OVER (ORDER BY rok) - 1) * 100, 2) AS mezirocni_zmena_procent
FROM t_tomas_havelec_project_sql_primary_final
ORDER BY rok;
