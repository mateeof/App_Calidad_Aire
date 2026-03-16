
source("Scripts/data_download_processing.R")
library(dplyr)
library(lubridate)

estaciones_lista <- rmcab_aqs$aqs[
  !rmcab_aqs$aqs %in% c("Bosa", "Usme")
]

fechas <- seq(as.Date("2016-01-01"), Sys.Date() - 1, by = "month")

datos_lista <- list()

for (f in fechas) {
  f <- as.Date(f, origin = "1970-01-01")
  message("Descargando: ", format(f, "%Y-%m"))
  
  for (est in estaciones_lista) {
    tryCatch({
      df <- get_data_clean(
        aqs        = est,
        start_date = format(f, "%d-%m-%Y"),
        end_date   = format(f + 28, "%d-%m-%Y")
      )
      if (is.null(df) || nrow(df) == 0) next
      
      resumen <- df %>%
        summarise(
          site    = first(site),
          lat     = first(lat),
          lon     = first(lon),
          pm2.5   = mean(`pm2.5`, na.rm = TRUE),
          pm10    = mean(pm10,    na.rm = TRUE),
          ozono   = mean(ozono,   na.rm = TRUE),
          no2     = mean(no2,     na.rm = TRUE),
          so2     = mean(so2,     na.rm = TRUE),
          co      = mean(co,      na.rm = TRUE),
          periodo = format(f, "%Y-%m")
        )
      datos_lista[[paste(est, format(f, "%Y-%m"), sep = "_")]] <- resumen
      
    }, error = function(e) message("Error: ", est, " ", format(f, "%Y-%m")))
    
    Sys.sleep(0.1)
  }
}

datos_historicos <- bind_rows(datos_lista) %>%
  filter(!is.na(site)) %>%
  rowwise() %>%
  mutate(valor = calcular_iboca(pm2.5, pm10, ozono, no2, so2, co)) %>%
  ungroup() %>%
  filter(!is.na(valor))

dir.create("datos", showWarnings = FALSE)
saveRDS(datos_historicos, "datos/datos_gif_historicos.rds")
message("Guardado: ", nrow(datos_historicos), " filas")

