library(readxl)
library(BSol.mapR)
library(dplyr)

groups <- read_excel("data/dementia-hub-groups.xlsx")

map1 <- plot_empty_map(
  area_name = "Birmingham",
  map_type = "Ward"
)

map2 <- add_points(
  map1,
  groups,
  size = 0.5,
  shape = "Frequency",
  color = "Type",
  palette = c("#FEB3D2", "#BDCA39")
)

map2

save_map(map2, "output/dementia-hub-groups.png")