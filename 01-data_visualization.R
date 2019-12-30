library(tidyverse)

# los coches con motor más grande consumen más combustible que los coches con motor más pequeño
# La relación consumo/tamaño es lineal? No lineal? Exponencial? Positiva? Negativa?

ggplot2::mpg
view(mpg)
# displ: tamaño del motor del coche en litros
help(mpg)

# hwy: numero de millas por autopista por galón de combustible (1 Galón = 3.78541 litros)

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy))

#PLATNILLA PARA HACER UNA REPRESENTACIÓN GRÁFICA CON GGPLOT
#######################################################
# ggplot(data = DATAFRAME) + 
# GEOM_FUNCTION(mapping = aes(MAPPINGS))
#######################################################

ggplot(data = mpg)
length(rownames(mpg))

ggplot(data = mpg) +
  geom_point(mapping = aes(x = class, y = drv))

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, color = class))

# Tamaño de los puntos (conviene que sea numérico)
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, size = class))

# Transparencia de los puuntos
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, alpha = class)) 


# Solo permite 6 formas diferentes a la vez con la forma de los puntos
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, shape = class))

# Elección manual de estéticas (va fuera de los argumentos de la estética)
ggplot(data = mpg) +
  geom_point(mapping = aes(displ, hwy), color = "red")
# color = nombre inglés en string
# size = 

ggplot(data = mpg) +
  geom_point(mapping = aes(model, trans))

# Hacer un mapeo de una estética con algo diferente a un nombre de una variable.
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, color = displ < 4))

## FACETS
# facet_wrap(~FORMULA_VARIABLE): la varaible debe de ser discreta

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_wrap(~class, nrow = 2)

# facet_grid(FORMULA_VARIABLE_1 ~ FORMULA VARIABLE 2)
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_grid(drv~cyl)


ggplot(data = mpg) +
  geom_point(mapping = aes(x=displ, y = hwy)) +
  facet_grid(.~cyl)

ggplot(data = mpg) +
  geom_point(mapping = aes(x=displ, y = hwy)) +
  facet_grid(drv~.)

# Diferentes GEOMETRíAS
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy))

ggplot(data = mpg) +
  geom_smooth(mapping = aes(displ, hwy))

ggplot(data = mpg) +
  geom_smooth(mapping = aes(x = displ, y = hwy, linetype = drv))


# Estos dos códigos son lo mismo 
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  geom_smooth(mapping = aes(x = displ, y = hwy))

# Lo único que te restringe a hacerlo siempre con las mismas variables
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point() + 
  geom_smooth()

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point(mapping = aes(color = class)) + 
  geom_smooth(mapping = aes(color = drv))

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point(mapping = aes(color = class)) + 
  geom_smooth(data = filter(mpg, class == "suv"), se = F) #se quita el intervalo de confianza




## Ejemplo del data set de diamantes
View(diamonds)

# hacer un diagrama de barras para ver los datos
ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut))


# Diferentes tipos de aestéticas

ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, fill = cut))


ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, fill = clarity))

## position = "identity"

ggplot(data = diamonds, mapping = aes(x = cut, fill = clarity)) +
  geom_bar(alpha = 0.25, position = "identity")

ggplot(data = diamonds, mapping = aes(x = cut, colour = clarity)) +
  geom_bar(fill = NA, position = "identity")

## position = "fill"

ggplot(data = diamonds, mapping = aes(x = cut, fill = clarity)) +
  geom_bar(position = "fill")

## position = "dodge"

ggplot(data = diamonds, mapping = aes(x = cut, fill = clarity)) +
  geom_bar(position = "dodge")

## VOlvemos al scatterplot
## position = jitter (solo tiene sentido en scatterplots)
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point(position = "jitter")
#son el mismo tipo de geometría, pero ggplot ya tiene jitter implementado
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_jitter()



# Sistemas de Coordenadas

#Coord_flip() -> Cambia los papeles de x e y
ggplot(data = mpg, mapping = aes(x = class, y = hwy)) +
  geom_boxplot() +
  coord_flip()

# coord_quickmap() -> configura el aspect ratio para mapas
usa <- map_data("usa")
ggplot(usa, aes(long, lat, group = group)) +
  geom_polygon(fill = "blue", color = "white") +
  coord_quickmap()

italy <- map_data("italy")
ggplot(italy, aes(long, lat, group = group)) +
  geom_polygon(fill = "blue", color = "white") +
  coord_quickmap()

# coord_polar()
ggplot(data = diamonds) +
  geom_bar(
    mapping = aes(x = cut, fill = cut),
    show.legend = F,
    width = 1
  ) + 
  theme(aspect.ratio = 1) +
  labs(x = NULL, y = NULL) +
  coord_polar()


# Gramatica por capas de ggplot2
#######################################################
# ggplot(data = DATA_FRAME) +
#   GEOM_FUNCTION(
#     mapping = aes(MAPPINGS),
#     stat = STAT, 
#     position = POSITION
#   ) +
#   COORDINATE_FUNCTION()+
#   FACET_FUNCTION()
#######################################################


ggplot(data = mpg, mapping = aes(x = class)) +
  geom_bar() + 
  coord_map()

ggplot(data = mpg, mapping = aes(x = cty, y = hwy )) + 
  geom_point() + 
  geom_abline() + 
  coord_fixed()








