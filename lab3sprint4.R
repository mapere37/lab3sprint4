# Cargar las librerías necesarias
install.packages("dplyr")
install.packages("tidyr")

library(dplyr)
library(tidyr)

# Cargar el dataset mtcars y convertirlo a dataframe
data(mtcars)
df <- as.data.frame(mtcars)

# 2. Selección de columnas y filtrado de filas
selected_df <- df %>%
  select(mpg, cyl, hp, gear) %>%
  filter(cyl > 4)
print("Seleccion y filtrado:")
print(selected_df)

# 3. Ordenación y renombrado de columnas
renamed_sorted_df <- selected_df %>%
  arrange(desc(hp)) %>%
  rename(consumo = mpg, potencia = hp)
print("Ordenacion y renombrado:")
print(renamed_sorted_df)

# 4. Creación de nuevas columnas y agregación de datos
grouped_df <- renamed_sorted_df %>%
  mutate(eficiencia = consumo / potencia) %>%
  group_by(cyl) %>%
  summarise(consumo_medio = mean(consumo), potencia_max = max(potencia))
print("Creacion y agregacion:")
print(grouped_df)

# 5. Creación del segundo dataframe y unión de dataframes
transmision_df <- data.frame(
  gear = c(3, 4, 5),
  tipo_transmision = c("Manual", "Automática", "Semiautomática")
)

joined_df <- renamed_sorted_df %>%
  left_join(transmision_df, by = "gear")
print("Union de dataframes:")
print(joined_df)

# 6. Transformación de formatos
long_df <- joined_df %>%
  pivot_longer(cols = c(consumo, potencia, eficiencia),
               names_to = "medida",
               values_to = "valor")
print("Formato largo:")
print(long_df)

# Identificar y manejar duplicados antes de transformar a formato ancho
deduplicated_df <- long_df %>%
  group_by(cyl, gear, tipo_transmision, medida) %>%
  summarise(valor = mean(valor), .groups = "drop")

wide_df <- deduplicated_df %>%
  pivot_wider(names_from = medida, values_from = valor)
print("Formato ancho:")
print(wide_df)
