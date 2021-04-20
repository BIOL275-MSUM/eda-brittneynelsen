# Install Packages --------------------------------------------------------
#remotes::install_github("ropensci/rinat")
library(tidyverse)
library(rinat)
library(lubridate)

# Get Koala Information ---------------------------------------------------
koala <- get_inat_obs(query = "Koala")
koala
unique(koala$scientific_name)


# Koalas in Australia -----------------------------------------------------
vp_obs <- get_inat_obs(query = "Queensland")
vp_obs
head(vp_obs$scientific_name)

Koala_2015<- get_inat_obs(taxon_name = "Phascolarctos cinereus")
Koala_2015


# Data Manipulation --------------------------------------------------

koala_raw <- get_inat_obs(taxon_name = "Phascolarctos cinereus",
                        quality = "research", maxresults = 10000)

koala_data <-
  koala_raw %>% 
  as_tibble() %>% 
  mutate(datetime = as_datetime(datetime), year = year(datetime))


# Koala Location Maps -----------------------------------------------------

filter(koala_data, year > 2015) %>%
  ggplot(aes(x = longitude,
             y = latitude,
             colour = scientific_name)) +
  geom_polygon(
    data = map_data("world"),
    aes(x = long, y = lat, group = group),
    fill = "grey95",
    color = "gray40",
    size = 0.1
  ) +
  geom_point(size = 0.3, alpha = 0.8) +
  facet_wrap(~ year, ncol = 2)+
  coord_fixed(
    xlim = c(110, 154),
    ylim = c(-40, -10)
  )+
  theme_bw()+
  theme(legend.position = "bottom", legend.direction = "vertical")


