-- Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední rok?
SELECT 
    rok,
    ROUND(litru_mlika_za_mzdu, 1) AS počet_l,
    ROUND(kg_chleba_za_mzdu, 1) AS počet_kg
FROM t_tomas_havelec_project_sql_primary_final
WHERE rok IN (
    (SELECT MIN(rok) FROM t_tomas_havelec_project_sql_primary_final),
    (SELECT MAX(rok) FROM t_tomas_havelec_project_sql_primary_final)
)
ORDER BY rok;
