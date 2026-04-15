library(readxl)
library(BSol.mapR)
library(dplyr)
library(tmap)
library(sf)

groups <- read_excel("data/dementia-hub-groups.xlsx") %>%
  mutate(
    Frequency = factor(
      Frequency,
      levels = c("Weekly", "Fortnightly", "Monthly")
      )
  )

dementia_counts <- read_excel("data/ward_diag_rates.xlsx")

map1 <- plot_empty_map(
  area_name = "Birmingham",
  map_type = "Ward"
) 

map2 <- add_points(
  map1,
  groups,
  size = 0.6,
  shape = "Frequency",
  color = "Type",
  palette = c("#BDCA39", "#FEB3D2")
)

map2

save_map(map2, "output/dementia-hub-groups.png")
save_map(map2, "output/dementia-hub-groups.html")


## With dementia numbers

ward_shape <- st_as_sf(Ward) %>%
  filter(
    Area == "Birmingham"
  ) %>%
  left_join(
    dementia_counts,
    by = join_by("Ward")
  )

const_shape <- st_as_sf(Constituency) %>%
  filter(
    Area == "Birmingham"
  ) 

credits <- paste0(
  "Dementia and Alzheimer cases identified based on ICD-10 codes F0[0-9] or G3[0-2] in MHSDS.\n",
  "Contains OS data \u00A9 Crown copyright and database right ",
  # Get current year
  format(Sys.Date(), "%Y"),
  ". Source:\nOffice for National Statistics licensed under the Open Government Licence v.3.0."
)

map3 <- tm_shape(ward_shape) +
  tm_fill(
    "dementia_cases",
    fill.legend = tm_legend(
      title = "Dementia Cases (2026)",
      height = 8
    )
  ) +
  tm_borders(
    col = "grey80", 
    lwd = 0.4
  ) +
  tm_shape(const_shape) +
  tm_borders(
    col = "grey40", 
    lwd = 1.5
    ) +
  tm_text(
    "Cnsttnc", 
    size = 0.8
  ) +
  tm_layout(
    legend.position = c("LEFT", "TOP"),
    legend.frame.alpha = 0,
    #legend.height = 6,
    component.autoscale = FALSE,
    legend.frame.lwd = 0,
    legend.bg.alpha = 0.0,
    inner.margins = c(0.1, 0.08, 0.08, 0.08),
    frame = FALSE
    ) +
  tm_credits(
    credits,
    size = 0.6,
    position = c("LEFT", "BOTTOM")
  ) +
  tm_compass(
    type = "8star",
    size = 4,
    position = c(0.8, 0.3),
    color.light = "white"
  )



map4 <- add_points(
  map3,
  groups,
  size = 0.6,
  shape = "Frequency",
  color = "Type",
  palette = c("#BDCA39", "#FEB3D2")
)

map4

save_map(map4, "output/dementia-hub-groups-with-counts.png")