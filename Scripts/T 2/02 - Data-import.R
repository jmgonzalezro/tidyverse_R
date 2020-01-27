library(tidyverse)
# read_csv() - lee ficheros csv ,
# read_csv2() - lee ficheros en ;
# read_tsv() - separados por "\t"
# read_delim(delim = ) - delimitamos el separador

# read_fwf() -> archivo de anchura fija
# fwf_widths() para deicr la anchura
# fwf_posittions() para decir los campos
# read_table()

# read_log() - preparado para leer ficheros de errores creados por apache

write.csv(mtcars, file = "scripts\cars.csv")

cars <- read_csv("scripts/cars.csv") # aquí ponemos el path
cars %>% View()





read_csv("x;y\n1;2")


# parse_* 
parse_logical(c("TRUE", "FALSE", "FALSE", "NA"))
str(parse_logical(c("TRUE", "FALSE", "FALSE", "NA")))
str(parse_integer(c("1", "2", "3", "4")))
str(parse_date(c("1988-05-19", "2018-05-30")))

# parse_double() solo valores numéricos
# parse_number() es más flexible, puedes tener decimales... o números en diferentes formas y separadores
# parse_character()

# parse_number()

# puede tener separadores de decimales por , o .
parse_double("12.345")
parse_double("12,345", locale = locale(decimal_mark = ","))

# puede tener valores monetarios 100€, $1000
# porcentajes 12%
parse_number("100€")
parse_number("$1000")
parse_number("12%")
parse_number("el vestido ha costado 12,45€")

# agrupaciones 1,000,000
parse_number("$1,000,000")
parse_number("$1.000.000", locale = locale(grouping_mark = "."))
parse_number("1'000'000", locale = locale(grouping_mark = "'"))


# parse_character()
charToRaw("Juan Gabriel") # se guarda en formato bites en ASCII
# Hay diferentes isos
# Latin1 (ISO-8859-1) para idiomas de Europa del Oeste
# Latin2 (ISO-8859-2) para idiomas de Europa del Este

# El más usado hoy en día es el UTF-8
x1 <- "El ni\xf1o ha estado enfermo"
x2 <- "\x82\xb1\xf1\xb2\xcd"
parse_character(x1, locale= locale(encoding = "Latin1"))
parse_character(x2, locale = locale(encoding = "Shift-JIS"))

guess_encoding(charToRaw(x1))
guess_encoding(charToRaw(x2))



# parse_factor()
months <- c("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")
parse_factor(c("May", "apr", "Jul", "Sec", "Nov"), levels = months)

# El dato más dificil de procesar por su estructura innata.
# parse_datetime() ISO-8601
# parse_date()
# parse_time()
# EPOCH <-indica el principio de las fechas en la informática. 1970-01-01 00:00
parse_datetime("2018-06-05T1845")
parse_datetime("20180605")

parse_date("2015-12-07")
parse_date("2018/05/18")

parse_time("03:00 pm")
parse_time("20:04:34")

# Años
# %Y <- año con 4 digitos
# %y <- año con 2 digitos (00-69) -> 2000-2069, (70-99) -> 1970-1999

# Meses
# %m <- mes en formato digitos 01-12
# $b <- abreviacion del mes "Ene", "Feb"...
# %B <- nombre compelto del mes "Enero", "Febrero"...

# Día
# %d <- número del día con dos dígitos
# %e <-  es opcional y los dígitos del 1-9 puden llevar espacio en blanco

# Horas
# %H <- hora entre las 0-23 horas
# %I <- hora entre 0-12 y va con %p
# %p <- am/pm
# %N <- minutos 0-59
# %s <- segundos entre 0-59
# %OS <- segundos reales con decimales para altra precisión
# %Z <- Zona horaria, como América/Chicago, Canadá, France, Spain
# %z <- Zona horaria con respecto la UTC +0800, +0100

# No dígitos
# %.7 para eliminar un carácter no dígito
# %* <- sirve para eliminar cualquier número de caracteres que no sean dígitos

parse_date("05/08/15", format = "%d/%m/%y")
parse_date("08/05/15", format = "%m/%d/%y")
parse_date("01-05-2018", format = "%d-%m-%Y")
parse_date("03 March 17", format = "%d %B %y")
parse_date("5 janvier 2012", format = "%d %B %Y", locale = locale("fr"))
parse_date("3 Septiembre 2013", format = "%d %B %Y", locale = locale("es"))



locale(date_names = "en", date_format = "%AT", time_format = "%AD",
      decimal_mark = ".", grouping_mark = ",", tz = "UTC",
      encoding = "UTF-8", asciify = FALSE)


# EJERCICIOS
parse_date("01/02/2013", locale = locale(date_format = "%d/%m/%Y"))

obj_locale <- locale(date_names = "es", date_format = "%AD", time_format = "AT", decimal_mark = ",", grouping_mark = ".", tz = "UTC", encoding = "UTF-8", asciify = FALSE)

v1 <- "May 19, 2018"
v2 <- "2018-May-08"
v3 <- "09-Jul-2013"
v4 <- c("January 19 (2019)", "Mayo 1 (2015)")
v5 <- "12/31/18" # Dic 31, 2014
v6 <- "1305"
v7 <- "12:05:11.15 PM"

parse_date(v1, format = "%B %d, %Y")
parse_date(v2, format = "%Y-%b-%d")
parse_date(v3, format = "%d-%b-%Y")
parse_date(v4, format = "%B %d (%Y)")
parse_date(v5, format = "%m/%d/%y")
parse_time(v6, format = "%H%M")
parse_time(v7)



# Ha generado un archivo de challenge.csv
challenge <- read_csv(
  readr_example("challenge.csv"),
  col_types = cols(
    x = col_double(), #parse_dobule()
    y = col_date() # parse_date()
  )
)

challenge2 <-  read_csv(readr_example("challenge.csv"), guess_max = 1001)
head(challenge2)
# esto sirve para inducarke ak readr_example el número de filas que tiene que tomar
# para hacer el cálculo del tipo de parseado que tiene que aplicar.

challenge3 <- read_csv(readr_example("challenge.csv"), 
                       col_types = cols(.default = col_character()))
head(challenge3)
# el col_character no peta nunca así que e smuuy útil para hacer una primera lectura
# si se usa con type_convert es muy útil
type_convert(challenge3)

# Usemoslo en un df de prueba
df <- tribble(
  ~x, ~y,
  "1", "1.2",
  "2", "3.86",
  "3", "3.1416"
)
type_convert(df)

read_lines(readr_example("challenge.csv"))
read_file(readr_example("challenge.csv"))





# Escritura de ficheros
# write_csv(), write_tsv()
# strings en UTF8
# date / datetimes ISO8601
# write_excel.csv() por si alguien lo va a usar de marketing para que se abra en excel

write_csv(challenge, path = "Scripts/") # por ejemplo
read_csv("Scripts/", gues_max = 1001)

# el csv no es el mejor sistema para cachear resultados parciales porque necesitaremos
# reespecificar cómo cargar cada columna de datos para evitar problemas.

# Tenemos alternativas como:
write_rds(challenge, path = "Scripts/challenge.rds") # Son formatos de R específicos en bianrio. Rdatastore
read_rds("Scripts/challenge.rds")

library(feather)
write_feather(challenge, path = "Scripts/challenge.feather") # archivos muy ligeros para la lectura de datos
read_feather("Scripts/challenge.feather") # lectura y escritura muy muy rápidas


# Hay otros tipos de datos/librerías en R que conviene conocer como:
# haven -> SPSS, Stata, SAS
# readxl -> .xml, xmls
# DBI -> sirve para trabajar con paquetes de RMySQL, RSQLite, RPostgreSQL











