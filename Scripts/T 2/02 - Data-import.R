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
  # puede tener valores monetarios 100€, $1000
  # porcentajes 12%
  # agrupaciones 1,000,000















