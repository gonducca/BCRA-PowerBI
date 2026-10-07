SELECT *
FROM mensual_bcra
ORDER BY Mes;

SELECT
    DATE(Mes) AS mes,
    Reservas_prom_MUSD AS reservas,
    LAG(Reservas_prom_MUSD) OVER (ORDER BY Mes) AS reservas_mes_anterior,
    ROUND(( Reservas_prom_MUSD - LAG(Reservas_prom_MUSD) OVER (ORDER BY Mes) )
/ LAG(Reservas_prom_MUSD) OVER (ORDER BY Mes) * 100,2) AS variacion_pct
FROM Mensual_BCRA
ORDER BY mes;

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

WITH variaciones AS (
   SELECT
    DATE(Mes) AS mes,
    Reservas_prom_MUSD AS reservas,
    LAG(Reservas_prom_MUSD) OVER (ORDER BY Mes) AS reservas_mes_anterior,
    ROUND(( Reservas_prom_MUSD - LAG(Reservas_prom_MUSD) OVER (ORDER BY Mes) )
/ LAG(Reservas_prom_MUSD) OVER (ORDER BY Mes) * 100,2) AS variacion_pct
FROM Mensual_BCRA
ORDER BY mes
)
SELECT mes,variacion_pct AS variacion_pct
FROM variaciones
WHERE variacion_pct IS NOT NULL
ORDER BY ABS(variacion_pct) DESC
LIMIT 5;

