# SQL Projekt

**Autor:** Tomáš Havelec  

## Cíl
Vytvořit dvě výsledné tabulky:
1. `t_tomas_havelec_project_sql_primary_final` – agregovaná data za ČR (mzdy + ceny potravin) po rocích a ukazatele kupní síly.
2. `t_tomas_havelec_project_sql_secondary_final` – roční ceny potravin po kategoriích včetně meziročních růstů a připojených makroindikátorů (HDP, GINI, populace).

## Datové zdroje
- `czechia_payroll`, `czechia_payroll_value_type`, `czechia_payroll_unit`
- `czechia_price`, `czechia_price_category`
- `economies`, `countries`

## Postup
- Primární tabulka: roční průměrná mzda (value_type_code=5958, unit_code=200), roční průměry cen (mléko, chléb, průměr všech potravin), výpočet kupní síly (litry/kg za mzdu), ponechány jen roky s dostupnými cenami mléka i chleba.
- Sekundární tabulka: roční průměrné ceny po kategoriích, meziroční růst (%), připojené makroindikátory a YoY HDP.

## Klíčové sloupce
### Primární
`rok`, `prumerna_mzda`, `prumerna_cena_jidla`, `cena_mlika`, `cena_chleba`, `litru_mlika_za_mzdu`, `kg_chleba_za_mzdu`

### Sekundární
`stat`, `rok`, `kod_kategorie`, `kategorie`, `prumerna_cena`, `cena_minuly_rok`, `rust_procenta`, `hdp`, `gini`, `populace`, `rust_hdp_procenta`

## Kontroly kvality a chybějící hodnoty
Spusťte `kontroly_dat.sql`. Získáte:
- rozsah let a počty řádků,
- počty `NULL` po sloupcích,
- roky s chybějícím mlékem/chlebem,
- TOP 5 kategorií s nejnižším průměrným YoY růstem.

## Jak spustit
1. `vysledne_tabulky.sql`
2. `kontroly_dat.sql`
3. volitelně dotazy `otazka_*.sql` pro výzkumné otázky.

## Odpovědi na otázky
1. Otázka : -- Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají? Klesají v roce 2013
2. Otázka :-- Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední rok? 2006_l - 1432.1 2006_kg -1282.4 2018_l - 1639.2	2018_kg - 1340.2
3. Otázka : -- Která kategorie potravin zdražuje nejpomaleji (nejnižší meziroční nárůst)?  Cukr krystalový -1.92
4. Otázka : -- Existuje rok, ve kterém byl růst cen potravin výrazně vyšší než růst mezd (více než o 10 %)? max -9.97 2008
5. Otázka : -- Má výška HDP vliv na změny ve mzdách a cenách potravin?  ANO 



