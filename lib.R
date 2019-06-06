library(dplyr)

fetchOccurrences <- function(areaids) {
  occ <- lapply(areaids, function(id) {
    message(id)
    return(occurrence(scientificname = "Pisces", areaid = id, fields = c("decimalLongitude", "decimalLatitude", "depth", "date_year", "aphiaID", "speciesid")))  
  })
  return(occ)  
}

fetchChecklists <- function(areaids, ...) {
  checklists <- lapply(areaids, function(id) {
    message(id)
    return(checklist(scientificname = "Pisces", areaid = id, ...))  
  })
  names(checklists) <- areaids
  result <- bind_rows(checklists, .id = "areaid")
  return(result)  
}

fetchAreas <- function() {
  areas <- fromJSON("https://api.obis.org/area")$results %>%
    filter(type == "iho") %>%
    mutate(id = as.numeric(id)) %>%
    select(areaid = id, areaname = name)
  return(areas)
}
