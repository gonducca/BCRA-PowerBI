# Registro de uso de IA generativa

Qué le pedí a Claude, qué hizo y qué corregí. Incluye lo que salió mal.

## Configuración

- Herramienta: Claude con el plugin Power BI Authoring (MCP), que lee y edita el proyecto en formato PBIP (`tablero.pbip`): modelo semántico en TMDL y reporte en PBIR.
- Fecha: octubre de 2026 (7 al 15/10).
- Problemas de instalación y cómo los resolví:
  - El plugin pide aceptar una licencia antes de usarse; la acepté yo explícitamente.
  - Si Power BI Desktop está abierto mientras Claude edita los archivos, Desktop pisa los cambios al guardar. Solución: cerrar Desktop **sin guardar**, dejar que Claude edite y volver a abrir `tablero.pbip`.
  - Claude no puede renderizar el tablero: yo le mandaba capturas para que viera el resultado.

## Prueba 1: página 2 (tasa real en detalle)

- **Qué pedí:** "instalé nuevos plugins, hacé vos toda la página 2", después de acordar el diseño (peor y mejor mes, ranking, gráfico de 59 meses).
- **Qué hizo Claude:** agregó medidas DAX (peor y mejor tasa real, meses con pérdida real, rankings) y armó la página con tarjetas, gráfico de columnas y dos rankings.
- **Qué estuvo bien:** las medidas coincidieron con mi consulta SQL 4 (peor mes dic 2023, −12,38 %; mejor ago 2025, +2,01 %).
- **Qué corregí o rechacé, y por qué:** etiquetas del eje ("000 2023", por un formato de fecha), textos que se salían de la caja, rankings que no ordenaban por la medida (un filtro TopN no puede ordenar por una medida; se resolvió con medidas de ranking). Pedí poner el contexto de diciembre 2023 en una nota al pie.

## Prueba 2: página 3 (reservas y tasa real)

- **Qué pedí:** "vamos con la página 3", para responder las preguntas 3 y 4.
- **Qué hizo Claude:** gráfico de línea de reservas con promedio móvil, columnas de variación mensual, dispersión de tasa real contra variación de reservas y un cuadro "Qué dicen los datos".
- **Qué estuvo bien:** el 71 % de caídas con tasa real negativa (20 de 28) coincide con mis consultas SQL 6 y 7.
- **Qué corregí o rechacé, y por qué:** ajusté formato y presentación. El título lo acordamos para que diga solo lo que los datos permiten: no hay relación simple entre tasa real y reservas, y con 3 variables no se prueban causas.

## Prueba 3: un error de Claude

- **Qué pasó:** cuando pedí borrar la "página 2" duplicada, Claude borró la página equivocada: el resumen ejecutivo, que estaba bajo ese nombre. Antes me había dicho que no borrara la "Página 1", que en realidad era mi hoja de ejercicio inicial.
- **Cómo lo detecté:** al ver una captura de mi "Página 1" supe que no era el resumen.
- **Cómo se resolvió:** el proyecto estaba en Git; se restauró desde un commit anterior y se borró la hoja de ejercicio.
- **Lección:** la IA puede editar archivos con seguridad aunque se equivoque sobre qué es cada cosa. Por eso trabajo con control de versiones y reviso cada cambio contra una captura.

## Conclusiones

- **Qué conviene delegar a la IA:** la construcción repetitiva de visuales, formatos y medidas una vez definido el diseño.
- **Qué conviene hacer a mano:** definir las preguntas de negocio, elegir las variables, escribir y entender las consultas SQL, y decidir qué conclusiones se pueden afirmar.
- **Cómo valido lo que devuelve la IA:** comparo cada medida DAX con una consulta SQL, reviso las capturas y mantengo el proyecto en Git para poder volver atrás.
