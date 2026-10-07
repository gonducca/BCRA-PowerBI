# Tablero del sistema financiero argentino (Power BI + SQL + DAX)


## 1. Pregunta de negocio

Un analista de una entidad financiera necesita decidir si ofrecer plazos fijos en pesos es atractivo para los ahorristas, y para eso tiene que saber si la tasa real fue positiva o negativa en los últimos meses y cómo evolucionaron las reservas.

### Preguntas que responde 

1. 	¿En cuántos de los últimos 12 meses la tasa real fue positiva?
2. 	¿Cuál fue el peor y el mejor mes para quien colocó a tasa BADLAR en los últimos 5 años?
3. ¿Cómo evolucionó el nivel de reservas y en qué períodos cayó más?
4. 	¿Los meses de tasa real negativa coinciden con caídas de reservas?

## 2. Datos

| Variable | idVariable | Periodicidad | Unidad | Moneda | Desde | Hasta |
| --- | --- | --- | --- | --- | --- | --- |
| Reservas internacionales | 1 | D | Millones de USD | ME | 2021-10-01 | 2026-10-02 |    
| Tasa de interés BADLAR de bancos privados | 7 | D | % Nominal Anual | ML | 2021-10-01 | 2026-10-05 |
| Inflación mensual| 27 | M | % | ML | 2021-10-1 | 2026-08-31 |

- **Fuente:** API de Estadísticas Monetarias v4.0 del BCRA (https://www.bcra.gob.ar/apis-banco-central/).
- **Fecha de descarga:** 2026-10-06
- **Cómo se descargaron:** JSON bajado desde el navegador
- **Limitaciones de los datos:** [por ejemplo, series con distinta periodicidad, tramos sin datos]

## 3. Modelo de datos

[Captura del modelo en `capturas/modelo.png` y 2 o 3 líneas: qué tablas hay, qué relaciones y por qué.]

## 4. Consultas SQL

Están en [`sql/consultas.sql`](sql/consultas.sql). Resumen:

| # | Qué calcula | Técnica |
| --- | --- | --- |
| 1 | Variación mensual | LAG |
| 2 | Promedio móvil | Función de ventana |
| 3 | Ranking de meses con mayor variación | ORDER BY / RANK |
| 4 | Tasa real | CTE |
| 5 | Cobertura de datos | Agregaciones |

## 5. Medidas DAX

| Medida | Qué hace (una línea) | Validada contra SQL |
| --- | --- | --- |
| Último valor | [explicar] | [ ] |
| Variación mensual | [explicar] | [ ] |
| Variación interanual | [explicar] | [ ] |
| Promedio móvil 30 días | [explicar] | [ ] |
| Tasa real | [explicar] | [ ] |

## 6. El tablero

- Página 1, Resumen ejecutivo: `capturas/pagina1.png`
- Página 2, Dólar y reservas: `capturas/pagina2.png`
- Página 3, Crédito y depósitos: `capturas/pagina3.png`

## 7. Hallazgos

Solo conclusiones que se puedan comprobar con una consulta de `consultas.sql`.

1. [Hallazgo 1, con el número y la consulta que lo respalda]
2. [Hallazgo 2]
3. [Hallazgo 3]

## 8. Uso de IA generativa

Ver [`ia/registro-claude.md`](ia/registro-claude.md): qué pedí, qué devolvió y qué corregí.

## 9. Cómo reproducirlo

1. Clonar el repositorio.
2. Abrir `tablero.pbix` en Power BI Desktop (solo Windows).
3. [Pasos para actualizar los datos]

## Autor

Gonzalo. [Enlace a LinkedIn]
