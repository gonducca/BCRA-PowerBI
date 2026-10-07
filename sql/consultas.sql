-- Consultas del proyecto: tablero del sistema financiero argentino
-- Motor sugerido: SQLite o DuckDB. Cargá los CSV de la carpeta datos/.
-- Regla: escribí primero tu versión; después pedile a Claude que la revise.
--
-- Tabla de ejemplo (ajustá nombres a tus datos):
--   series(id_variable, fecha, valor)
--   variables(id_variable, descripcion, periodicidad, unidad)

-- ---------------------------------------------------------------
-- 1. Variación mensual de una serie (LAG)
-- Pregunta que responde: ¿Cuánto varió mes a mes el nivel de reservas del BCRA?
-- ---------------------------------------------------------------
-- SELECT
    DATE(Mes) AS mes,
    Reservas_prom_MUSD AS reservas,
    LAG(Reservas_prom_MUSD) OVER (ORDER BY Mes) AS reservas_mes_anterior,
    ROUND(( Reservas_prom_MUSD - LAG(Reservas_prom_MUSD) OVER (ORDER BY Mes) )
/ LAG(Reservas_prom_MUSD) OVER (ORDER BY Mes) * 100,2) AS variacion_pct
FROM Mensual_BCRA
ORDER BY mes;


-- ---------------------------------------------------------------
-- 2. Promedio móvil (función de ventana)
-- Pregunta que responde: ¿Las caídas de reservas del BCRA son hechos 
aislados o se sostienen en el tiempo? El promedio móvil de 3 meses 
suaviza la variación mensual y permite distinguir una baja puntual de una tendencia. 
---------------------------------------------------------------
-- SELECT
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


-- ---------------------------------------------------------------
-- 3. Ranking de los meses con mayor variación
-- ---------------------------------------------------------------
-- Resultado: los 5 meses con mayor movimiento (en valor absoluto) fueron
mayo 2025 (19,03 %), abril 2025 (18,5 %), julio 2023 (18,15 %),
noviembre 2023 (15,19 %) y abril 2022 (11,4 %).
Signo de cada uno: [completar al correr la consulta sin ABS]

Hipótesis sobre abril y mayo de 2025 (a contrastar con el tablero):
En abril de 2025 se anunció el acuerdo con el FMI (unos USD 20.000 millones)
y el primer desembolso fue de alrededor de USD 12.000 millones. Eso sube el
nivel de reservas de golpe. Como mi serie es el promedio mensual, el efecto
se reparte en dos meses: abril lo refleja parcialmente y mayo, con las reservas
ya en el nivel nuevo durante todo el mes, completa el salto.

Lo que no sé todavía: qué pasó en julio y noviembre de 2023 y en abril de 2022.
Pendiente: buscar el contexto de esos tres meses antes de escribir la
conclusión en el README.

Aprendizaje: una variación grande en un promedio mensual puede venir de un
hecho puntual del mes anterior. Para ver bien un evento conviene mirar también
la serie diaria.

-- ---------------------------------------------------------------
-- 4. Tasa real (CTE que une tasa e inflación)
-- Fórmula: (1 + tasa nominal) / (1 + inflación) - 1
-- Pregunta que responde: [completar]
-- ---------------------------------------------------------------
-- [tu consulta]


-- ---------------------------------------------------------------
-- 5. Cobertura de datos: primera fecha, última fecha y cantidad de registros por variable
-- Pregunta que responde: [completar]
-- ---------------------------------------------------------------
-- [tu consulta]
