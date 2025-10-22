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

## Postup (shrnutí)
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


