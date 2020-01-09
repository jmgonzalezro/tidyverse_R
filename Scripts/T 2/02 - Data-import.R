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















