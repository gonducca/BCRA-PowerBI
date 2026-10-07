-- Consultas del proyecto: tablero del sistema financiero argentino
-- Motor sugerido: SQLite o DuckDB. Cargá los CSV de la carpeta datos/.
-- Regla: escribí primero tu versión; después pedile a Claude que la revise.
--
-- Tabla de ejemplo (ajustá nombres a tus datos):
--   series(id_variable, fecha, valor)
--   variables(id_variable, descripcion, periodicidad, unidad)

-- ---------------------------------------------------------------
-- 1. Variación mensual de una serie (LAG)
-- Pregunta que responde: [completar]
-- ---------------------------------------------------------------
-- [tu consulta]


-- ---------------------------------------------------------------
-- 2. Promedio móvil (función de ventana)
-- Pregunta que responde: [completar]
-- ---------------------------------------------------------------
-- [tu consulta]


-- ---------------------------------------------------------------
-- 3. Ranking de los meses con mayor variación
-- Pregunta que responde: [completar]
-- ---------------------------------------------------------------
-- [tu consulta]


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
