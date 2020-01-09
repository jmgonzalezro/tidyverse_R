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
        count(dest)


not_cancelled %>%
        group_by(dest) %>%
        tally()


not_cancelled %>%
        group_by(tailnum) %>%
        tally(wt = distance)


flights %>%
        group_by(year, month, day) %>%
        filter(is.na(dep_delay)) %>% # aquí ya estamos solo filtrando los cancelados
        summarise(
                n = n(),
                media = mean(dep_delay, na.rm = ) # no da por el mero hecho de que la media de los cancelados NA es NA
        )

not_cancelled %>%
        filter(dep_delay > 0) %>%
        mutate(prop_delay = dep_delay / sum(dep_delay)) %>%
        select(year:day, dest, dep_delay, prop_delay)

flights %>%
        mutate(prop_delay = dep_delay / sum(dep_delay), na.rm = T) %>%
        group_by(year, month, day) %>%
        filter(is.na(dep_delay)) %>%
        count(dep_delay)

flights %>%
        group_by(carrier) %>%
        filter(is.na(dep_delay)) %>%
        count(sort = T)

# 5 Efectos que producen los retrasos por culpa de los malos aeropuertops vs malas compañías
# Intenta desentrañar los efectos que producen los retrasos por culpa de malos aeropuertos vs malas compañías aéreas. Por ejemplo, intenta usar 
# flights %>% group_by(carrier, dest) %>% summarise(n())

flights %>%
        group_by(carrier, dest) %>%
        summarise(n = n(),
                  delay = mean(dep_delay, na.rm = T),
                  delay_carrier = mean(dep_delay),
                  delay_dest = ) # LO DEJO AQui. MIRAR MAÑANA ESTA ZONA. MIRAR EL RETRASO QUE HAY POR COMPAÑÍA Y AEROPUERTO. VER EL RETRASO DE LA COMPAÑÍA SOLO. VER EL RETRASO DEL AEROPUERTO
# SOLO, Y VER LA SUMA O DIVISIÓN ETNRE LOS DOS

malas_comps <- flights %>%
        group_by(carrier) %>%
        filter(rank(desc(dep_delay)) < 10) %>%
        summarise(n())
malas_comps        

malos_dest <- flights %>%
        group_by(dest) %>%
        filter(rank(desc(dep_delay)) < 10) %>%
        summarise(n())

malos_dest        





flights %>%
        group_by(tailnum) %>%
        arrange(rank(desc(arr_delay))) %>%
        select(carrier, tailnum)


flights %>%
        filter(!is.na(dep_delay)) %>%
        arrange(rank(desc(dep_delay))) %>%
        select(hour, day)

# Para cada destino, calcula el total de minutos de retraso acumulado.

#Para cada uno de ellos, calcula la proporción del total de retraso para dicho destino.
flights %>%
        group_by(dest)%>%
        summarize(n = n(),
                  sum = sum(dep_delay, na.rm = T),
                  proporcion = sum / n)


flights %>%
        group_by(tailnum) %>%
        lead(dep_delay)

flights %>%
        group_by(tailnum) %>%
        mutate(siguiente = lead(dep_delay, order_by = tailnum),
               anterior = lag(dep_delay, order_by = tailnum))

# 11

flights %>%
        arrange(carrier)
        


##########################################################################################################################


Intenta describir con frases entendibles el conjunto de vuelos retrasados. Intenta dar afirmaciones como por ejemplo:
        
        - Un vuelo tiende a salir unos 20 minutos antes el 50% de las veces y a salir tarde el 50% de las veces restantes.

- Los vuelos de la compañía XX llegan siempre 20 minutos tarde

- El 95% de los vuelos a HNL llegan a tiempo, pero el 5% restante se retrasan más de 3 horas.

Intenta dar por lo menos 5 afirmaciones verídicas en base a los datos que tenemos disponibles.

not_cancelled_hour <- not_cancelled %>%
        
        mutate(hour_dep_time = dep_time %/% 100)



view(not_cancelled_hour %>% group_by(origin, hour_dep_time) %>%
             
             filter(month ==8, origin == "EWR") %>%
             
             summarise(total_flights = n(),
                       
                       total_dep_delay = sum(dep_delay)) %>%
             
             arrange(hour_dep_time))

# En agosto, desde el aeropuerto de EWR, la hora pico de mayor numero de vuelos en el dia es de

# 6 a 7am, pero paradogicamente, a esa hora, todos los vuelos salen antes de la hora prevista

# y la peor hora para volar es entre las 18 y 19 dado que es cuando se tienen mas retrasos en salidas



not_cancelled %>% group_by(carrier, origin, dest) %>%
        
        summarise(total_flights = n(),
                  
                  flights_per_day = total_flights / 365,
                  
                  mean_delay = mean(dep_delay)) %>%
        
        filter(carrier == "EV" | carrier == "B6", total_flights > 100) %>%
        
        arrange(desc(total_flights))

# Las compañias con mayor retraso son EV y B6 

# Para la compañia B6, el aeropuerto donde mas viejos saca es JFK, con 114 vuelos promedio dia,

# para la compañia EV, el aeropuerto donde mas viejos saca es EWR, tambien com 114 vuelos dia,

# pero es mas eficiente B6 porque esos 114 vuelos diarios los saca con un promedio de dep_delay

# de 12.7 min, contra 20 min de EV



not_cancelled %>% group_by(year) %>%
        
        ##filter(arr_delay > 0) %>%
        
        summarise(total_flights = n(),
                  
                  dep_delayed = sum(dep_delay >= 0) / total_flights,
                  
                  arr_delayed = sum(arr_delay >= 0) / total_flights,
                  
                  dep_ontime = sum(dep_delay < 0) / total_flights)

# Por que los vuelos aterrizan tarde?

# el 73% de los vuelos que aterrizaron tarde, fue porque salieron tambien tarde. El resto

# es porque los demoraron en el aterrizaje



not_cancelled %>% group_by(origin, dest) %>%
        
        summarise(min(air_time),
                  
                  median(air_time),
                  
                  mean(air_time),
                  
                  max(air_time),
                  
                  dif = (max(air_time) - min(air_time))*100 / min(air_time),
                  
                  avg_distance = mean(distance)
                  
        ) %>%
        
        arrange(desc(dif))





not_cancelled %>% group_by(carrier, origin, dest) %>%
        
        filter(origin == "LGA" & dest == "ORD") %>%
        
        summarise(total_flights = n(),
                  
                  mean_dep_delay = mean(dep_delay),
                  
                  perc_dep_delayed = mean(dep_delay>0),
                  
                  mean_arr_delay = mean(arr_delay),
                  
                  perc_arr_delayed = mean(arr_delay>0)) %>%
        
        arrange(desc(total_flights))



not_cancelled %>% filter(origin == "LGA" & dest == "ORD") %>%
        
        ggplot(mapping = aes(x= dep_delay, y= arr_delay)) +
        
        geom_point(alpha = 0.2) +
        
        geom_smooth(aes(color=carrier))

# Comportamiento de la ruta mas concurrida % vuelos a tiempo, % vuelos retrasados

# con el carrier AA, el 29% de los vuelos salen tarde y el 30% llegan tarde.

# con el carrier UA, el 38% de los vuelos salen tarde y el 38% llegan tarde.





not_cancelled %>% group_by(carrier, origin, dest) %>%
        
        summarise(total_flights = n(),
                  
                  total_delay = sum(dep_delay) + sum(arr_delay),
                  
                  avg_delay = total_delay / total_flights) %>%
        
        filter(total_flights > 365) %>%
        
        arrange(desc(avg_delay))

# TOP 3 de carriers / rutas que nunca (o en un alto %) tienen retrasos. Las MEJORES

#teniendo en cuenta solo las rutas que tienen mas de 365 vuelos al año, las 3 mejores

#son:

# carrier origin dest  total_flights total_delay avg_delay

# <chr>   <chr>  <chr>         <int>       <dbl>     <dbl>

# 1 AS      EWR    SEA             709       -2907    -4.10

# 2 B6      EWR    SJU             378       -1298    -3.43

# 3 US      LGA    BOS            4002      -11782    -2.94



# TOP 3 de carriers / rutas que siempre (o en un alto %) tienen retrasos. Las PEORES

# carrier origin dest  total_flights total_delay avg_delay

# <chr>   <chr>  <chr>         <int>       <dbl>     <dbl>

# 1 EV      EWR    DSM             390       20684      53.0

# 2 EV      EWR    RIC            1615       84363      52.2

# 3 EV      LGA    CLE             388       18999      49.0



# En los retrasos, que culpa tienen los aeropuertos de Origen y que culpa los de destino?

not_cancelled %>% group_by(year) %>%
        
        summarise(total_flights = n(),
                  
                  total_delay = sum(dep_delay>0) + sum(arr_delay>0),
                  
                  count_depDelayed = sum(dep_delay>0),
                  
                  perc_depDelayed = mean(dep_delay>0),
                  
                  count_arrDelayed = sum(arr_delay>0),
                  
                  perc_arrDelayed = mean(arr_delay>0))

# del total de vuelos (327k), el 39% son vuelos retrasados en el departure aurport, el 40% en

# en el arrival airport. El restante son vuelos que no estan retrasados

Da una versión equivalente a las pipes siguientes sin usar la función count:
        
        not_cancelled %>% count(dest)

not_cancelled %>% count(tailnum, wt = distance)

not_cancelled %>% count(dest)

summarise(group_by(not_cancelled, dest),n = n()) # sin pipes y sin count

group_by(not_cancelled, dest) %>% summarise(n = n()) # con pipes y sin count



not_cancelled %>% count(tailnum, wt = distance)

summarise(group_by(not_cancelled, tailnum), sum(distance))

Para definir un vuelo cancelado hemos usado la función

(is.na(dep_delay) | is.na(arr_delay))

Intenta dar una definición que sea mejor, ya que la nuestra es un poco subóptima. ¿Cuál es la columna más importante?
        
        flights %>% filter(is.na(dep_delay) | is.na(arr_delay))

# Segun la sentencia anterior, los cancelados son 9,430



flights %>% filter(is.na(dep_time) | is.na(arr_time))

# si usamos mejor los campos dep_time y arr_time, los cancelados realmente son 8,713

Investiga si existe algún patrón del número de vuelos que se cancelan cada día.

Investiga si la proporción de vuelos cancelados está relacionada con el retraso promedio por día en los vuelos.

Investiga si la proporción de vuelos cancelados está relacionada con el retraso promedio por aeropuerto en los vuelos.

¿Qué compañía aérea sufre los peores retrasos?
        
        flights$monthday <- paste(flights$month,flights$day) #concatene month y day

view(flights)

group_by(flights, monthday) %>%
        
        filter(is.na(dep_time) | is.na(arr_time)) %>%
        
        summarise(count= n()) %>%
        
        ggplot(aes(x= monthday, y= count)) +
        
        geom_point(alpha = 0.2) +
        
        geom_smooth()

# Hay un incremento en la cancelacion de vuelos que comienza el dia 1 de cada mes,

# llegando a tu tope maximo el 10 de cada mes y luego baja al promedio el 15 del mes



# Investiga si la proporción de vuelos cancelados está relacionada con el retraso

# promedio por día en los vuelos.

flights %>% mutate(weekDay = weekdays(time_hour)) %>%
        
        group_by(day, weekDay) %>% #filter(weekDay == "martes") %>%
        
        summarise(total_flights = n(),
                  
                  canc_dep = sum(is.na(dep_time)),
                  
                  canc_arr = sum(is.na(arr_time)),
                  
                  count_depDelayed = sum(!is.na(dep_delay) & dep_delay> 0),
                  
                  count_arrDelayed = sum(!is.na(arr_delay) & arr_delay> 0) ) %>%
        
        ggplot(aes(x = day, y = total_flights, color= weekDay)) +
        
        geom_smooth(aes(y = count_depDelayed), show.legend= F)+
        
        geom_smooth(aes(y= canc_dep), show.legend= F) +
        
        facet_wrap(~weekDay, as.table = TRUE) +
        
        geom_point(aes(y = count_depDelayed), shape=23) +
        
        geom_point(aes(y = canc_dep), shape=22)

#No existe ninguna relacion, ni comparandolos por dia de la semana, ni por dia del mes



# Investiga si la proporción de vuelos cancelados está relacionada con el retraso

# promedio por aeropuerto en los vuelos.

group_by(flights, dest) %>%
        
        summarise(total_flights = n(),
                  
                  canc_dep = sum(is.na(dep_time)),
                  
                  depDelayed = sum(!is.na(dep_delay) & dep_delay> 0),
                  
                  canc_arr = sum(is.na(arr_time)),
                  
                  arrDelayed = sum(!is.na(arr_delay) & arr_delay> 0)) %>%
        
        arrange(desc(canc_arr))



ggplot(aes(x= dest, y = total_flights)) +
        
        geom_smooth(aes(y = arrDelayed), show.legend= F)+
        
        geom_smooth(aes(y= canc_arr), show.legend= F) +
        
        geom_point(aes(y = arrDelayed), shape=23, colour= "red") +
        
        geom_point(aes(y = canc_arr), shape=22, colour = "blue")

# No hay ninguna relacion.



# ¿Qué compañía aérea sufre los peores retrasos?

group_by(flights, carrier) %>%
        
        summarise(total_flights = n(),
                  
                  canc_dep = sum(is.na(dep_time)),
                  
                  depDelayed = sum(!is.na(dep_delay) & dep_delay> 0),
                  
                  canc_arr = sum(is.na(arr_time)),
                  
                  arrDelayed = sum(!is.na(arr_delay) & arr_delay> 0),
                  
                  total_delay = depDelayed + arrDelayed) %>%
        
        arrange(desc(arrDelayed))

# En total, la mas retrasada es UA, en el dep es tambien UA, en el arr es EV

Difícil: Intenta desentrañar los efectos que producen los retrasos por culpa de malos aeropuertos vs malas compañías aéreas. Por ejemplo, intenta usar 

flights %>% group_by(carrier, dest) %>% summarise(n())

group_by(flights, carrier, dest) %>%
        
        summarise(total_flights = n(),
                  
                  arrDelayed = sum(!is.na(arr_delay) & arr_delay> 0)) %>%
        
        arrange(desc(arrDelayed))

¿Qué hace el parámetro sort como argumento de count()? ¿Cuando puede sernos útil?
        
        Vuelve a la lista de funciones útiles para filtrar y mutar y describe cómo cada operación cambia cuando la juntamos con un group_by.

R/ cuando queremos hacer un conteo de observaciones y que de una vez queden

# agrupadas por la variable que le digamos. Cuando sort = TRUE los organiza

# descendentemente.

# Podemos usar count() cuando solo queremos hacer conteos de una agrupacion,

# pero si de esa grupacion queremos hacer otra operacion que no sea conteo,

# debemos usar group_by()

Vamos a por los peores aviones. Investiga el top 10 de qué aviones (número de cola y compañía) llegaron más tarde a su destino.

not_cancelled %>% group_by(carrier, tailnum) %>%
        
        summarise(total_flights = n(),
                  
                  total_delay = sum(dep_delay>0) + sum(arr_delay>0)) %>%
        
        arrange(desc(total_delay))

Queremos saber qué hora del día nos conviene volar si queremos evitar los retrasos en la salida.

Difícil: Queremos saber qué día de la seman nos conviene volar si queremos evitar los retrasos en la salida.



#R/ Las mejores horas son entre las 4 y 6am

not_cancelled_hour <- not_cancelled %>%
        
        mutate(hour_dep_time = dep_time %/% 100)



view(not_cancelled_hour %>% group_by(origin, hour_dep_time) %>%
             
             summarise(mean_dep_delay = mean(dep_delay)) %>%
             
             arrange(hour_dep_time, origin))

# Difícil: Queremos saber qué día de la seman nos conviene volar si

# queremos evitar los retrasos en la salida.

#R/ El sabado es el mejor dia

ale_flights <- mutate(not_cancelled, weekDay = weekdays(time_hour))

group_by(ale_flights, weekDay) %>%
        
        summarise(mean_dep_delay = mean(dep_delay)) %>%
        
        arrange(mean_dep_delay)

Para cada destino, calcula el total de minutos de retraso acumulado.

Para cada uno de ellos, calcula la proporción del total de retraso para dicho destino.

per_dest <- not_cancelled %>% group_by(dest) %>%
        
        summarise(sum_dep_delay = sum(dep_delay), total_flights = n())

total_flights_records <- as.integer(count(not_cancelled))

not_cancelled %>% group_by(dest) %>%
        
        summarise(sum_dep_delay = sum(dep_delay),
                  
                  total_flights = n(),
                  
                  perc_dest = total_flights / total_flights_records) %>%
        
        arrange(desc(perc_dest))

Los retrasos suelen estar correlacionados con el tiempo. Aunque el problema que ha causado el primer retraso de un avión se resuelva, el resto de vuelos se retrasan para que salgan primero los aviones que debían haber partido antes. Intenta usar la función lag() explora cómo el retraso de un avión se relaciona con el retraso del avión inmediatamente anterior o posterior.

count(not_cancelled, month, day, tailnum) %>% arrange(desc(n))

my_flights <- not_cancelled %>%
        
        arrange(month, day, tailnum, sched_dep_time, origin, dest) %>%
        
        mutate(fl_behind = lag(flight), fl_ahead = lead(flight)) %>%
        
        select(month, day, tailnum, origin, dest, sched_dep_time, dep_time,
               
               dep_delay, carrier, flight, fl_behind, fl_ahead) %>%
        
        filter(tailnum == "N732US" & month== 2 & day== 15)

# desde la optica de tailnum, no se evidencia que si un avion llega tarde a su

# destino, afecte el siguiente vuelo que parte desde ese destino hacia uno nuevo

# usando el mismo avion.



my_flights <- not_cancelled %>%
        
        arrange(month, day, origin, dep_time, origin, dest) %>%
        
        mutate(fl_behind = lag(flight), fl_ahead = lead(flight)) %>%
        
        select(month, day, origin, dest, dep_time, sched_dep_time, 
               
               dep_delay, carrier, flight, fl_behind, fl_ahead)

# Desde la optica del aeropuerto de origen, tampoco se evidencia que el retraso

# de un vuelo afecte los demas que estan pendientes por salir, dado que los

# aeropuertos tienen varias pistas para que puedan darse varios despeques

# al mismo tiempo

lead(1:10, 1)

lead(1:10, 2)



lag(1:10, 1)

lead(1:10, 1)



x <- runif(5)

cbind(ahead = lead(x), x, behind = lag(x))



# Use order_by if data not already ordered

df <- data.frame(year = 2000:2005, value = (0:5) ^ 2)

scrambled <- df[sample(nrow(df)), ]



wrong <- mutate(scrambled, prev = lag(value))

arrange(wrong, year)



right <- mutate(scrambled, prev = lag(value, order_by = year))

arrange(right, year)

Vamos a por los destinos esta vez. Localiza vuelos que llegaron 'demasiado rápido' a sus destinos. Seguramente, el becario se equivocó al introducir el tiempo de vuelo y se trate de un error en los datos. Calcula para ello el cociente entre el tiempo en el aire de cada vuelo relativo al tiempo de vuelo del avión que tardó menos en llegar a dicho destino. ¿Qué vuelos fueron los que más se retrasaron en el aire?
        
        fastest_flights <- not_cancelled %>% group_by(origin, dest) %>%
        
        mutate(fastest = min(air_time)) %>%
        
        arrange(origin, dest, air_time)

# Con esta sentencia anterior, le metimos la variable fastest a cada registro

# del dataframe

fastest_flights %>% mutate(vs_fastest = air_time / fastest) %>%
        
        select(month, day, dep_time, dep_delay, arr_time, arr_delay, carrier,
               
               origin, dest, air_time, fastest, vs_fastest) %>%
        
        arrange(desc(vs_fastest))

Encuentra todos los destinos a los que vuelan dos o más compañías y para cada uno de ellos, crea un ranking de las mejores compañías para volar a cada destino (utiliza el criterio que consideres más conveniente como probabilidad de retraso, velocidad o tiempo de vuelo, número de vuelos al año..)

Finalmente, para cada avión (basándonos en el número de cola) cuenta el número de vuelos que hace antes de sufrir su primer retraso de más de una hora. Valora entonces la fiabilidad del avión o de la compañía aérea asociada al mismo.

view(
        
        not_cancelled %>% group_by(origin, dest) %>%
                
                filter(n_distinct(carrier) >=2) %>%
                
                summarise(min_delay = min(dep_delay + arr_delay))
        
)

# No pude terminarla. Agradeceria comentarios sobre como terminarl














