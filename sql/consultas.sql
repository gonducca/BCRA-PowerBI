-- Consultas del proyecto: tablero del sistema financiero argentino
-- Motor: SQLite (DataGrip). Tabla de origen: Mensual_BCRA, exportada de Power BI.
-- Columnas: Mes, Reservas_prom_MUSD, BADLAR_prom_TNA_pct, Inflacion_mensual_pct
-- Las respuestas completas y las hipótesis están en notas.md.

-- ---------------------------------------------------------------
-- 1. Variación mensual de una serie (LAG)
-- Pregunta que responde: ¿Cuánto varió mes a mes el nivel de reservas del BCRA?
-- ---------------------------------------------------------------
SELECT
    DATE(Mes) AS mes,
    Reservas_prom_MUSD AS reservas,
    LAG(Reservas_prom_MUSD) OVER (ORDER BY Mes) AS reservas_mes_anterior,
    ROUND(( Reservas_prom_MUSD - LAG(Reservas_prom_MUSD) OVER (ORDER BY Mes) )
        / LAG(Reservas_prom_MUSD) OVER (ORDER BY Mes) * 100, 2) AS variacion_pct
FROM Mensual_BCRA
ORDER BY mes;
-- Resultado: de 58 variaciones, 28 a la baja y 30 al alza, promedio +0,48 % mensual.
-- Nov 2021 a feb 2022: cuatro caídas seguidas (-1,09 %, -4,34 %, -4,02 %, -4,38 %).


-- ---------------------------------------------------------------
-- 2. Promedio móvil de 3 meses (función de ventana)
-- Pregunta que responde: ¿Las caídas de reservas del BCRA son hechos
-- aislados o se sostienen en el tiempo? El promedio móvil de 3 meses
-- suaviza la variación mensual y permite distinguir una baja puntual de una tendencia.
-- ---------------------------------------------------------------
SELECT
    DATE(Mes) AS mes,
    Reservas_prom_MUSD AS reservas,
    ROUND(
        AVG(Reservas_prom_MUSD) OVER (
            ORDER BY Mes
            ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
        )
    , 2) AS promedio_movil_3m
FROM Mensual_BCRA
ORDER BY mes;
-- Control: dic 2021 = 42013.16
-- Resultado: en los últimos 12 meses el promedio móvil sube de forma sostenida
-- (de ~40.800 en nov 2025 a ~48.700 en ago 2026).


-- ---------------------------------------------------------------
-- 3. Ranking de los meses con mayor variación (en valor absoluto)
-- Pregunta que responde: ¿Cuáles fueron los meses de mayor movimiento
-- en las reservas del BCRA?
-- ---------------------------------------------------------------
WITH variaciones AS (
    SELECT
        DATE(Mes) AS mes,
        ROUND(( Reservas_prom_MUSD - LAG(Reservas_prom_MUSD) OVER (ORDER BY Mes) )
            / LAG(Reservas_prom_MUSD) OVER (ORDER BY Mes) * 100, 2) AS variacion_pct
    FROM Mensual_BCRA
)
SELECT mes, variacion_pct
FROM variaciones
WHERE variacion_pct IS NOT NULL
ORDER BY ABS(variacion_pct) DESC
LIMIT 5;
-- Resultado: may 2025 +19,03 | abr 2025 +18,5 | jul 2023 -18,15 |
-- nov 2023 -15,19 | abr 2022 +11,4.


-- ---------------------------------------------------------------
-- 4. Tasa real (CTE que une tasa e inflación)
-- Fórmula: (1 + tasa nominal mensual) / (1 + inflación) - 1
-- Pregunta que responde: ¿En qué meses los depósitos a plazo fijo
-- ganaron o perdieron poder adquisitivo frente a la inflación?
-- ---------------------------------------------------------------
WITH tasas AS (
    SELECT
        DATE(Mes) AS mes,
        BADLAR_prom_TNA_pct / 100.0 * 30 / 365 AS tem,
        Inflacion_mensual_pct / 100.0 AS inflacion
    FROM Mensual_BCRA
),
resultado AS (
    SELECT
        mes,
        ROUND( ( (1 + tem) / (1 + inflacion) - 1 ) * 100, 2 ) AS tasa_real_pct
    FROM tasas
)
SELECT mes, tasa_real_pct
FROM resultado
ORDER BY mes;
-- Resultado: 41 meses negativos y 18 positivos de 59. Peor: dic 2023 (-12,38 %).
-- Mejor: ago 2025 (+2,01 %). Control: jul 2026 = -0,34 %, ago 2026 = +0,16 %.


-- ---------------------------------------------------------------
-- 5. Cobertura de datos: primera fecha, última fecha y cantidad de registros
-- Pregunta que responde: ¿Qué período cubren los datos y están completas
-- las tres variables?
-- ---------------------------------------------------------------
SELECT
    DATE(MIN(Mes)) AS primera_fecha,
    DATE(MAX(Mes)) AS ultima_fecha,
    COUNT(*) AS filas_totales,
    COUNT(Reservas_prom_MUSD) AS n_reservas,
    COUNT(BADLAR_prom_TNA_pct) AS n_badlar,
    COUNT(Inflacion_mensual_pct) AS n_inflacion
FROM Mensual_BCRA;
-- Resultado: 2021-10-01 a 2026-08-01, las tres variables tienen 59 registros, sin faltantes.


-- ---------------------------------------------------------------
-- 6. ¿Las caídas de reservas coinciden con tasa real negativa?
-- Pregunta que responde (pregunta 4): de los meses en que bajaron las
-- reservas, ¿en cuántos la tasa real también fue negativa?
-- Une la variación mensual (consulta 1) con la tasa real (consulta 4).
-- ---------------------------------------------------------------
WITH variaciones AS (
    SELECT
        DATE(Mes) AS mes,
        ( Reservas_prom_MUSD - LAG(Reservas_prom_MUSD) OVER (ORDER BY Mes) )
            / LAG(Reservas_prom_MUSD) OVER (ORDER BY Mes) * 100 AS variacion_pct,
        ( (1 + BADLAR_prom_TNA_pct / 100.0 * 30 / 365)
            / (1 + Inflacion_mensual_pct / 100.0) - 1 ) * 100 AS tasa_real_pct
    FROM Mensual_BCRA
)
SELECT
    COUNT(*) AS meses_con_caida,
    SUM(CASE WHEN tasa_real_pct < 0 THEN 1 ELSE 0 END) AS con_tasa_real_negativa,
    ROUND(100.0 * SUM(CASE WHEN tasa_real_pct < 0 THEN 1 ELSE 0 END) / COUNT(*), 0) AS pct_con_tasa_real_negativa
FROM variaciones
WHERE variacion_pct < 0;
-- Resultado: 28 meses con caída de reservas, 20 con tasa real negativa (71 %).
-- Referencia: la tasa real fue negativa en 41 de 59 meses (69 %), así que la
-- coincidencia no es mayor a lo que se esperaría por azar.


-- ---------------------------------------------------------------
-- 7. Las 5 mayores caídas de reservas y su tasa real
-- Pregunta que responde: ¿Cuándo cayeron más las reservas y cómo estaba
-- la tasa real esos meses?
-- ---------------------------------------------------------------
WITH variaciones AS (
    SELECT
        DATE(Mes) AS mes,
        ROUND(( Reservas_prom_MUSD - LAG(Reservas_prom_MUSD) OVER (ORDER BY Mes) )
            / LAG(Reservas_prom_MUSD) OVER (ORDER BY Mes) * 100, 2) AS variacion_pct,
        ROUND(( (1 + BADLAR_prom_TNA_pct / 100.0 * 30 / 365)
            / (1 + Inflacion_mensual_pct / 100.0) - 1 ) * 100, 2) AS tasa_real_pct
    FROM Mensual_BCRA
)
SELECT mes, variacion_pct, tasa_real_pct
FROM variaciones
WHERE variacion_pct IS NOT NULL
ORDER BY variacion_pct ASC
LIMIT 5;
-- Resultado: jul 2023 -18,15 (tasa real +1,23) | nov 2023 -15,19 (-1,92) |
-- may 2023 -9,27 (-0,37) | oct 2023 -8,2 (+1,6) | ago 2022 -8,08 (-1,9).
-- Cuatro de las cinco caídas son de 2023; dos ocurrieron con tasa real positiva.
