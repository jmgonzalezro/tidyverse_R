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
  geom_histogram(mapping = aes(x = carat), binwidth = 0.2)

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


## Outliers
ggplot(diamonds) +
  geom_histogram(mapping = aes(x = y), binwidth = 0.5)
# podemos hacer un zoom como hay muchos outliers a la derecha

ggplot(diamonds) +
  geom_histogram(mapping = aes(x = y), binwidth = 0.5) +
  coord_cartesian(ylim = c(0,100)) # cambiamos los límites de las coordenadas
# cartesianas para hacer un zoom
# si usamos el xlim o el ylim en ggplot, eliminaremos los valores que caen fuera del zoom

unusual_diamonds <- diamonds %>%
  filter(y < 1 | y > 30) %>% # para sacar los outliers
  select(price, x,y,z) %>%
  arrange(y)

View(unusual_diamonds) # tiene pinta que son valores incorrectos, a 0 de anchuda y 25mil euros

# una vez tenemos los outliers podemos eliminarlos del dataset ( o reemplazar por NAs)
good_diamonds <- diamonds %>%
  filter(between(y, 2.5, 29.5))
# esta opción es la menos recomendable. 

# La opción más recomendable es reemplazarlos por NA
good_diamonds <- diamonds %>%
  mutate(y = ifelse(y < 2 | y > 30, NA, y))

# ifelse se usa un vector lógico, máscara.
# EN caso de que la condición se satisfaga da el segundo argumento,
# en caso de que no se cumpla dará el 3er dato del argumento

ggplot(data = good_diamonds, mapping = aes(x = x, y = y)) +
  geom_point(na.rm = T)

###________________ EJERCICIOS _____________________
ggplot(data = diamonds, mapping = aes(price)) + 
  geom_histogram()

# 3
diamonds %>%
  count(carat == 0.99)

diamonds %>%
  count(carat == 1)

# 4
ggplot(diamonds) +
  geom_histogram(mapping = aes(x = y)) +
  coord_cartesian(ylim = c(0,10))

#5 


ggplot(data = good_diamonds, mapping = aes(x = x, y = y)) +
  geom_bar(na.rm = T)


diamonds %>%
  ggplot(mapping = aes(price)) + 
  geom_bar()
###________________ EJERCICIOS _____________________

#### COVARIACIÓN

# cuando queremos visualizar una categoría vs continua -> la manera más sencilla con geom_freqpolly

ggplot(diamonds, mapping = aes(x = price)) +
  geom_freqpoly(mapping = aes(color = cut), binwidth = 500)

ggplot(diamonds) +
  geom_bar(mapping = aes(x = cut))

ggplot(data = diamonds, mapping = aes(x = price, y = ..density..)) + # se utiliza .. para que represente la densidad y no el count
  geom_freqpoly(mapping = aes(color = cut), binwidth = 500)

# boxplot

ggplot(data = diamonds, mapping = aes(x = cut, y = price))+
  geom_boxplot()


ggplot(data = mpg, mapping = (aes( x = class, y = hwy))) +
  geom_boxplot() # aquí tendríamos las clases sin ordenar

ggplot(data = mpg) %>%
  geom_boxplot(mapping = aes(x = reorder(class, hwy, FUN = median)), y = hwy)
# ahora estarían ordeados y con la mediana ascendente
# también se puede añadir un coord_flip() para girar las cajas

# Categoría vs categoría

diamonds %>%
  count(color, cut) %>%
  ggplot(mapping = aes(x = cut, y = color)) +
  geom_tile(mapping = aes(fill = n)) # para hacer un mapa de calor mas o menos
# También habría un d3heatmap y un heatmaply para hacer mejores mapas de calor 


# Variable continua vs variable continua
ggplot(data = diamonds) +
  geom_point(mapping = aes(x = carat, y = price), alpha = 0.01)


install.packages("hexbin")
library(hexbin)

ggplot(data = diamonds) +
  geom_bin2d(mapping = aes(x = carat, y = price))

ggplot(data = diamonds) +
  geom_hex(mapping = aes(x = carat, y = price))

diamonds %>%
  filter(carat <3) %>%
  ggplot(data = diamonds, mapping = aes(x = carat, y = price)) +
  geom_boxplot(mapping = aes(group = cut_width(carat, 0.1)), varwidth = T)

diamonds %>%
  filter(carat < 3) %>%
  ggplot(mapping = aes(x = carat, y = price)) +
  geom_boxplot(mapping = aes(group = cut_number(carat, 20)))



# Tenemos que buscar patrones
# ¿Son coincidencia?
# Relaciones que implica el patrón (relación lineal, exponencia, logarítmica...)
# ¿Fuerza de la relación?
# ¿Otras variables afectadas?
# ¿Subgrupos?

ggplot(data = faithful) +
  geom_point(mapping = aes(x = eruptions, y = waiting))

# Introduciremos un trozo de código que nos permite ver si los kilates y compute
# los residuos (diferencia entre predicción y el valor real) para ver si el 
# modelo lo hace bien

install.packages("modelr")

library(modelr)
mod <- lm(log(price) ~log(carat), data = diamonds)
mod

diamonds_pred <- diamonds %>%
  add_residuals(mod) %>%
  mutate(res = exp(resid))

View(diamonds_pred)
ggplot(data = diamonds_pred) +
  geom_point(mapping = aes(x = carat, y = resid))


ggplot(diamonds_pred) +
  geom_boxplot(mapping = aes(x = cut, y = resid))



###________________ EJERCICIOS _____________________
#1 visualizar mejor los tiempos de salida para vuelos cancelados vs no cancelados

library(nycflights13)
View(flights)

cancelled <- flights %>%
  filter(is.na(dep_delay) | is.na(arr_delay))
not_cancelled <- flights %>%
  filter(!is.na(dep_delay) | !is.na(arr_delay))
not_cancelled
cancelled

ggplot(data = cancelled, mapping = aes(sched_dep_time)) + 
  geom_histogram()
ggplot(data = not_cancelled, mapping = aes(sched_dep_time)) + 
  geom_histogram()


# 2 Variable más importante
# 3
install.packages("ggstance")
library(ggstance)

ggplot(data = diamonds, mapping = aes(x = cut, y = price))+
  geom_boxplot() + 
  coord_flip()


ggplot(data = diamonds, mapping = aes(x = cut, y = price))+
  geom_boxploth()


# 4
install.packages("lvplot")
library(lvplot)

# 5
ggplot(data = diamonds, mapping = aes(x = cut, y = price)) +
  geom_violin()

# 6
install.packages("ggbeeswarm")
library(ggbeeswarm)

ggplot(data = diamonds, mapping = aes(x = cut, y = price)) +
  geom_quasirandom() # está mal

#7
diamonds %>%
  count(color, cut) %>%
  ggplot(mapping = aes(x = cut, y = color)) +
  geom_tile(mapping = aes(fill = n))


diamonds %>%
  count(color, cut) %>%
  ggplot(mapping = aes(x = color, y = cut)) +
  geom_tile(mapping = aes(fill = n))

#8

library(nycflights13)
flights %>%
  count(dep_time, dest) %>%
  ggplot(mapping = aes(x = dep_time, y = dest)) +
          geom_tile(mapping = aes(fill = count))










