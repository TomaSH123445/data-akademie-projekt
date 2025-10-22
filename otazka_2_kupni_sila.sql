-- 2️⃣ Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední rok?
SELECT 
    rok,
    ROUND(litru_mlika, 1) AS litru_mlika_za_mzdu,
    ROUND(kg_chleba, 1) AS kg_chleba_za_mzdu
FROM t_tomas_havelec_project_sql_primary_final
WHERE rok IN (
    (SELECT MIN(rok) FROM t_tomas_havelec_project_sql_primary_final),
    (SELECT MAX(rok) FROM t_tomas_havelec_project_sql_primary_final)
)
ORDER BY rok;
