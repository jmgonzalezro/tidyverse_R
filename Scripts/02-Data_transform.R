library(tidyverse)
library(nycflights13)

# -- Attaching packages --------------------------------------- tidyverse 1.3.0 --
#   v ggplot2 3.2.1     v purrr   0.3.3
# v tibble  2.1.3     v dplyr   0.8.3
# v tidyr   1.0.0     v stringr 1.4.0
# v readr   1.3.1     v forcats 0.4.0
# -- Conflicts ------------------------------------------ tidyverse_conflicts() --
#   x dplyr::filter() masks stats::filter()
# x dplyr::lag()    masks stats::lag()

nycflights13::flights


##### Tibble es un data frame mejorado para tidyverse
# filter() -> filtrar observaciones para valores concretos
# arrange() -> reodenar filas
# select() -> seleccionar variables por sus nombres
# mutate() -> crea nuevas variables con funciones a partir de las existentes
# summarise() -> colapsar varios valores para dar un resumen de los mismos
 
# group_by() -> opera la función a la que acompaña grupo a grupo

# 1- Data fram
# 2- Operaciones que queremos hacer a las variables del data frame
# 3- Resultado en un nuevo dataframe


### FILTER

jan1 <- filter(flights, month == 1, day == 1)
jan10 <- filter(flights, month == 1, day == 10)
view(jan10)
(jan10 <- filter(flights, month == 1, day == 10)) #para mostrar por consola y crear variable


## ARRANGE
arrange(flights, carrier)


# Ejercicios
filter(flights, arr_delay >=60)
filter(flights, dest == "SFO" | dest == "OAK")
filter(flights, carrier == "AA" | carrier == "UA")
filter(flights, month == 4 & month == 5 & month == 6)
filter(flights, arr_delay >= 60, dep_delay <= 60)
filter(flights, dep_delay >= 60 & arr_delay <= 30)
filter(flights, dep_time >= 0 & dep_time <= 7)
filter(flights, between(dep_time, 0, 7))
filter(flights, is.na(dep_time))

## ARRANGE que sirve para ordenar
arrange(flights, year)
sorted_date <- arrange(flights, year, month, day)
tail(sorted_date) # para mostrar los últimos días

arrange(flights, desc(arr_delay)) # desc() se hace para que sea descendiente
head(arrange(flights, desc(arr_delay)))

## SELECT
View(sorted_date[1,]) #así da solo la primera fila del dataset [1:3,] daría hasta la tercera

select(sorted_date[1:6,], arr_delay, dep_delay)
select(flights, year, month, day)

select(flights, dep_time:arr_delay) # para coger un subconjunto de columnas
select(flights, -(year:day)) # todas las columnas excepto año mes y día

select(flights, starts_with("dep"))
select(flights, ends_with("delay"))
select(flights, contains("s"))

select(flights, matches("(.)\\1")) # "(.)\\1" busca caracteres repetidos
select(flights, num_range("x", 1:5)) # buscaría variables x1 x2 x3 x4 x5

## RENAME

rename(flights, deptime = dep_time) # esta función cambia los nombres de las variables
rename(flights, deptime = dep_time, año = year, mes = month, dia = day)
select(flights, año = year) # solo renombra esa variable y la selecciona

select(flights, time_hour, distance, air_time , everything()) # con el helper everything() para ordenar las variables que quiera al principio

arrange(flights, is.na(dep_time))
arrange(flights, dep_delay)
filter(flights, dep_delay < 0)

# vuelos más rápidos
mas_rapidos <- mutate(flights, distance / air_time)
arrange(desc(mas_rapidos))

# también se puede hacer
View(arrange(flights, distance/air_time))


arrange(flights, arr_delay) # para ordenarlos por el tiempo de llegada más lento

# trayectos más largos
arrange(flights, desc(distance))
arrange(flights, distance)


### MUTATE
flights_new <- select(flights,
                      year:day,
                      ends_with("delay"),
                      distance,
                      air_time)

mutate(flights_new,
       time_gain = arr_delay - dep_delay,    # diff_t (min)
       flight_speed = distance/(air_time/60) #v = s/t (km/h)
       )

mutate(flights_new,
       time_gain = arr_delay - dep_delay,    # diff_t (min)
       air_time_hour = air_time/60,
       flight_speed = distance/(air_time/60), #v = s/t (km/h)
       time_gian_per_hour = time_gain / air_time_hour
        ) -> flights_new
#asignándole el data set al final así te quedas con las varaibales viejas y las nuevas

transmute(flights_new,
            time_gain = arr_delay - dep_delay,
            air_time_hour = air_time/60,
            flight_speed = distance/(air_time/60),
            time_gian_per_hour = time_gain / air_time_hour
            ) -> data_from_flights
View(data_from_flights)

# Operaciones aritméticas: +, -, *, /, ^
# Agregados de funciones: x/sum(x) : proporción sobre el total
#                         x - mean(x): distancia respecto de media
#                         (x - mean(x)) / sd(x) : tipificación
#                         (x - min(x)) / (max(x) - min(x)): estandarizar entre [0 , 1]

# Aritmética modular: %/% <- nos da el cociente de la división entera
#                     %% <- resto de la división entera
#                     x == y * (x%/%y) + (x%%y) <- algoritmo de euclides

#Para sacar el timepo de vuelo de cad uno de los aviones, las horas y minutos que duró el vuelo
transmute(flights,
          air_time,
          hour_air = air_time%/%60,
          minute_air = air_time%%60
          )

# Logaritmos: log() <- logaritmo en base e, log2(), log10()
# Offsets: lead(), lag(), que nos permiten barrer los datos hacia izda o dcha
# se pueden usar con groupby

df <- 1:12
lag(df) #lag mueve hacia la derecha
lag(lag(df))
lead(df) #mueve hacia la izquierda

# Funciones acumulativas: cumsum(), cumprod(), cummin(), cummax(), cummean()
cumsum(df)
cumprod(df)
cummin(df)
cummax(df)
cummean(df)

# Comparaciones lógicas: >, >=, <, <=, ==, !=
transmute(flights,
            dep_delay,
            has_been_delayed = dep_delay >0
            )
# Rankings: min_rank()
df <- c(7,14,8,1,2,3,3,3,NA,4)
min_rank(df)
min_rank(desc(df))

row_number(df)
dense_rank(df)
percent_rank(df) #porcentaje relativo
cume_dist(df) # redoneado con los dígitos que necesitemos. Son los percentiles
ntile(df, n = 4) # te los ordena por percentiles

transmute(flights,
          dep_delay,
          ntile(dep_delay, n = 100)
          ) #ordenados por quantiles

# Finalizado el módulo de transformación de datos