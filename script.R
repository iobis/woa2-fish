library(dplyr)
library(jsonlite)
library(robis)
source("lib.R")

areas <- fetchAreas()
depths <- data.frame(
  name = c("epi", "meso", "bathy", "abysso", "hado"),
  start = c(0, 200, 1000, 4000, 6000),
  end = c(200, 1000, 4000, 6000, 11000)
)

checklists <- list()

for (i in 1:nrow(depths)) {
  message(depths$name[i])
  checklists[[i]] <- fetchChecklists(areas$areaid, startdepth = depths$start[i], enddepth = depths$end[i])
}

names(checklists) <- depths$name
taxa <- bind_rows(checklists, .id = "depth")

stats <- taxa %>%
  group_by(areaid, depth) %>%
  summarize(records = sum(records), species = length(unique(speciesid))) %>%
  left_join(areas %>% mutate(areaid = as.character(areaid)), by = "areaid") %>%
  arrange(areaname, depth) %>%
  select(areaname, areaid, depth, species, records)

write.csv(stats, row.names = FALSE, file = "statistics.csv")
