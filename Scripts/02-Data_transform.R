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


# ejercicios
transmute(flights,
          dep_time,
          sched_dep_time,
          min_salid = dep_time*0.6,
          min_previst_salid = sched_dep_time * 0.6
          )
 transmute(flights,
           dep_time,
           arr_time,
           air_time,
           new_air_time = dep_time*0.6 + air_time
           )

transmute(flights,
          dep_time,
          sched_dep_time,
          dep_delay,
          hour_dep = dep_time %/% 100,
          min_dep = dep_time %% 100
          )

arrange(mutate(flights,
               r_delay = min_rank(dep_delay)),
        r_delay
        )[1:10,]


## SUMMARISE

summarise(flights, delay = mean(dep_delay, na.rm = T))

# Tiene mucha utilidad cuando hacemos agrupaciones

by_month_group <- group_by(flights, year, month)
summarise(by_month_group, delay = mean(dep_delay, na.rm = T))

# en el caso de quererlo hacer una agrupación diaria

by_day_group <- group_by(flights, year, month, day)
summarise(by_day_group, delay = mean(dep_delay, na.rm = T))

# también se puede calcular más cosas
summarise(by_day_group,
          delay = mean(dep_delay, na.rm = T),
          median = median(dep_delay, na.rm = T),
          min = min(dep_delay, na.rm = T))

summarise(group_by(flights, carrier),
          delay = mean(dep_delay, na.rm = T))

transmute(summarise(group_by(flights, carrier),
                    delay = mean(dep_delay, na.rm = T),
                    sorted = min_rank(delay)
                    )
)

mutate(summarise(group_by(flights, carrier),
                    delay = median(dep_delay, na.rm = T),
                    sorted = min_rank(delay)
)
)


# PIPES, verbos necesarios de tidyverse

group_by_dest <- group_by(flights, dest)
delay <- summarise(group_by_dest,
                   count = n(),
                   dist = mean(distance, na.rm = T),
                   delay = mean(arr_delay, na.rm = T)
                   )
View(delay)          
delay <- filter(delay, count > 100, dest != "HNL") # para eliminar los que tienen menos de 100 y el destino es difenre te a honolulu

ggplot(data = delay, mapping = aes(x = dist, y = delay)) + 
        geom_point(aes(size = count), alpha = 0.2) + 
        geom_smooth(se = F) + 
        geom_text(aes(label = dest), alpha = 0.3)

# Esto sería la forma más larga de realizarlo sin los pipes, pero
# poniendo pipes podemos mejorar la sintaxis de la siguiente manera

delay <- flights %>%
        group_by(dest) %>%
        summarise(
                count = n(),
                dist = mean(distance, na.rm = T),
                delay = mean(arr_delay, na.rm = T)
        ) %>%
        filter(count > 100, dest != "HNL")

# las pipes las podemos leer como "y entonces". Coge el data base flights
# y entonces agrupa, y entonces sumariza, y entonces filtra


## Para eliminar los NA de los datos
flights %>%
        group_by(year, month, day) %>%
        summarise(mean = mean(dep_delay),
                  sd = sd(dep_delay),
                  count = n()
                  )
# Aquí se puede ver que arrastra todos los NA los datos
# Los NA tienen un significado inherente, que representa un vuelo cancelado
# en este dataset. Podríamos eliminarlos o quedarnos con los no cancelados
not_cancelled = flights %>%
        filter(!is.na(dep_delay), !is.na(arr_delay))

not_cancelled %>%
        group_by(year, month, day) %>%
        summarise(mean = mean(dep_delay),
                  sd = sd(dep_delay),
                  count = n()
        )

delay_numtail <- not_cancelled %>%
        group_by(tailnum) %>%
        summarise(delay = mean(arr_delay))
ggplot(data = delay_numtail, mapping = aes(x = delay)) +
        geom_freqpoly(bimwidth = 5)  # es un pequeño histograma para variables continuas
#bimwidth significa que cada 5 aviones tenemos 1 punt

ggplot(data = delay_numtail, mapping = aes(x = delay)) +
        geom_histogram(bimwidth = 5)


delay_numtail <- not_canceled %>%
        group_by(tailnum) %>%
        summarise(delay = mean(arr_delay),
        count = n()
        )
ggplot(data = delay_numtail, mapping = aes(x = count, y = delay)) + 
        geom_point(alpha = 0.2)

# POdemos filtrar los que se acercan a cero
delay_numtail %>%
        filter(count>30) %>%
        ggplot(mapping = aes(x=count, y=delay)) +
        geom_point(alpha = 0.2)






###Para ver todo lo aprendido con el paquete de baseball
View(Lahman::Batting)

batting <- as_tibble(Lahman::Batting)

batters <- batting %>%
        group_by(playerID) %>%
        summarise(hits = sum(H, na.rm = T),
                  bats = sum(AB, na.rm = T),
                  bat.average = hits / bats
          )

batters %>%
        filter(bats > 100) %>%
        ggplot(mapping = aes(x = bats, y = bat.average)) +
        geom_point(alpha = 0.2) +
        geom_smooth() # se = F para quitar el error standar

# para hacer un ranking
batters %>%
        filter(bats > 100) %>%
        arrange(desc(bat.average))


# Funciones útiles para usar con summarise

# Medidas de Centralización (media y mediana)
not_cancelled %>%
        group_by(carrier) %>%
        summarise(
                mean = mean(arr_delay),
                mean2 = mean(arr_delay[arr_delay >0]),
                median = median(arr_delay)
        )

# Medidas de dispersión (desviación, rango intercuartílico...)
not_canceled %>%
        group_by(carrier) %>%
        summarise(
                sd = sd(arr_delay),
                iqr = IQR(arr_delay),
                mad = mad(arr_delay)
        ) %>%
        arrange(desc(sd))

# Medidas de orden. (quantiles...)
not_cancelled %>%
        group_by(carrier) %>%
        summarise(
                first = min(arr_delay),
                q1 = quantile(arr_delay, 0.25),
                median = quantile(arr_delay, 0.75),
                q3 = quantile(arr_delay, 0.75),
                last = max(arr_delay)
        )

# Medidas de posición
not_cancelled %>%
        group_by(carrier) %>%
        summarise(
                first_dep = first(dep_time),
                second_dep = nth(dep_time, 2),
                third_dep = nth(dep_time, 3),
                last_dep = last(dep_time)
        )

not_cancelled %>%
        group_by(carrier) %>%
        mutate(rank = min_rank(desc(dep_time))) %>%
        filter(rank %in% range(rank))

not_cancelled %>% count(dest)
not_cancelled %>% count(tailnum, wt = distance) # suma pondereda, weighted


## Sum y mean de valores lógicos = hay que identificarlo con el conteo y la proporción
not_cancelled %>%
        group_by(year, month, day) %>%
        summarise(n_prior_5 = sum(dep_time < 500))

not_cancelled %>%
        group_by(carrier) %>%
        summarise(more_than_hour_delay = mean(arr_delay > 60)) %>%
        arrange(desc(more_than_hour_delay))


# Agrupaciones múltipples
# se pueden hacer con sumarize con el sumatorio anterior y ungroup para deshacerlo

flights %>%
        group_by(year, month, day) %>%
        filter(rank(desc(arr_delay))<10)

popular_dest <- flights %>%
        group_by(dest) %>%
        filter(n() > 365)
View(popular_dest)

popular_dest %>%
        filter(arr_delay > 0 ) %>%
        mutate(prop_delay = arr_delay / sum(arr_delay)) %>%
        select(year:day, dest, arr_delay, prop_delay)


### Ejercicios

media_arr_delay <- flights %>%
        group_by(carrier) %>%
        summarise(media_arr_delay = median(arr_delay, na.rm = T))

View(media_arr_delay)

View(flights)

destino_mas_delay <- flights %>%
        group_by(dest) %>%
        arrange(min_rank(arr_delay))
(destino_mas_delay)

numero_delay <- flights %>%
        filter(arr_delay > 0 ) %>%
        group_by(carrier) %>%
        summarise(
                n = rank(n())
        )
        
View(numero_delay)

destinos <- flights %>%
        group_by(dest) %>%
        count(dest)
View(destinos)

porcent_vuelos_ret_jfk <- not_cancelled %>%
        group_by(dest) %>%
        summarise(mean = mean(arr_delay),
                  sv = sd(arr_delay),
                  q9 = quantile(arr_delay, .9)
                  )
View(porcent_vuelos_ret_jfk)

porcent_vuelos_ret_jfk <- not_cancelled %>%
        filter(dest == "JFK")

# 
# - La compañía con mayor media de vuelos retrasados es F9 (6) y la que menos media de vuelos retrasados tiene es AS (-17)
# 
# - El destino que mayor retraso ha sufrido es SFO seguido de LAX
# 
# - La compañía con mayor número de retrasos es EV con 24484 y la que menos es OO con 10
# 
# - El destino con más número de vuelos es ORD seguido por ATL
# 
# -El destino con la mayor desviación típica es HNL seguido de TUL

not_cancelled %>%
        group_by(dest) %>%
        tally()


not_cancelled %>%
        group_by(tailnum) %>%
        tally(wt = distance)


cancelled <- flights %>%
        filter(is.na(dep_time))
cancelled

cancelled %>%
        group_by(year, month, day) %>%
        summarize(
                n = n(),
                
        )


flights %>% count(is.na(dep_time))














