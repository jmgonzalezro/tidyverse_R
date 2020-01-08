library(tidyverse)
# Análisis exploratorio de datos

# Modelar
# Representación gráfica
# Transformar datos


# ¿Qué tipo de variaciones sufren las variables?
# ¿Qué tipo de covariación sufren las variables?

# Variable: Cantidad, dato cualitativo, factor o propiedad medible
# valor: Estado de la variable al ser medida.
# observación: Conjunto de medidas tomadas en condiciones similares
#               data point, conjunto de valores tomados para cada variable
# datos tabulares: conjunto de valores, asociado a cada variable y observación
#                   si los datos están limpios, cada valor tiene su propia celda
#                   cada variable tiene su columna y cada observación su fila


##### VARIACIÓN
## Variables categóricas: Factor o vector de caracteres.
ggplot(data = diamonds) +
  geom_bar(mapping = aes(cut))

diamonds %>%
  count(cut)


## Variable contínua: conjunto infinito de valores ordenados(números, fechas)
ggplot(data = diamonds) +
  geom_histogram(mapping = aes(carat), binwidth = 0.5)

diamonds %>%
  count(cut_width(carat, 0.5))

# Como no hay valores por encima de 3 pues hacemos un filtro rápido con dplyr
diamonds_filter <- diamonds %>%
  filter(carat < 3)

ggplot(data = diamonds_filter) +
  geom_histogram(mapping = aes(x = carat), binwidth = 0.2
                 )
ggplot(data = diamonds_filter, mapping = aes(x= carat, color = cut)) +
         geom_freqpoly(binwidth = 0.1)

# Cuáles son los valores más comunes y por qué?
# Cuales son los valores más raros? Por Qué? Cunple con lo esperado?
# Vemos algún patrón característico o inusual Podemos explicarlos?

# Qué hace que los elementos de un cluster sean similares entre sí
# Qué determina qué clusters separados sean diferentes entre sí
# Describir y explicar cada uno de los clusters.
# Por qué alguna observación puede ser clasificada en el cluster erróneo...

View(faithful) # es un geiser en yellowstone
?faithful

ggplot(data = faithful, mapping = aes(x = eruptions)) +
  geom_histogram(binwidth = 0.2)



















