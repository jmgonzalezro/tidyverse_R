vignette("tibble") # lleva a la ayuda de tibble
library(tidyverse)

iris_tibble <- as_tibble(iris)
class(iris_tibble)

t <- tibble(
  x = 1:10,
  y = pi,
  z = y * x ^ 2
)

t$z
t[2, 3]

t2 <- tibble(
  `:)` = "smilie",
  ` ` = "space",
  `1988` = "number"
)
t2

# existe un modo de generar las tibbles mediante TRIBBLE de manera traspuesta
# se define la cabeza con una fórmula (tílde) y las entradas son separadas por comas
# repsectivamente, haciendo que sea fácil de leer.

tribble(
# |---|---|-----|  
  ~x, ~y, ~z,
  "a", 4, 3.14,
  "b", 8, 6.28,
  "c", 9, -1.25,
)

install.packages("lubridate")
library(lubridate)

tibble(
  a = lubridate::now() + runif(1e3)*24*60*60,
  b = 1:1e3,
  c = lubridate::today() + runif(1e3)*30,
  d = runif(1e3),
  e = sample(letters, 1e3, replace = T)
)

nycflights13::flights %>%
  print(n = 12, width = Inf)

options(tibble.print_max = 12, tibble.print_max = min 12)
options(dplyr.print_min = Inf)
options(tibble.width = Inf)

nycflights13::flights %>% #... metemos lo que sea para manipularlo
  View() # así podemos meterlo en una nueva pestaña con el view

# [["nombre_variable"]]
# [[posición_variable]]
# $nobre_variable

df <- tibble(
  x = rnorm(10),
  y = runif(10)
)
df$x
df$y
df[["x"]]
df[["y"]]
df[[1]]
df[[2]]

# antes de una pipe hay que usar el carácter . antes de nada
df %>% .$x
df %>% .$y
df %>% .[["x"]]
df %>% .[[1]]


# algunas funciones no funcionan con tibbles. Si nos las encontramos, tenemos que 
# covnertir el tibble otra vez a dataframe...
as.data.frame(df)

#[[]] sobre un df el resultado puede devolver un data.frame o un vector
# aplicados sobre una tibble, devuelve siempre una tibble

is.tibble(nycflights13::flights)
is.tibble(mtcars)

# ______________________________________EJERCICIOS______________

df <- tibble(
  `1` = 1:12,
  `2` = `1` * 2 + `1`*runif(length(`1`)),
  `3` = `2` * `1`
)

df[[1]]

ggplot(df, aes(1, 2)) + 
  geom_point(na.rm = T)

df[[3]] = df[[1]] * df[[2]]

df %>%
  rename(x = `1`, y = `2`, z = `3`)

#5
?tibble:enframe()
?tibble:deframe()


