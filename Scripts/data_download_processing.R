library(bogotAIR)
library(tidyr)
library(dplyr)




#Descargar datos de RMCAB

get_data_clean <- function(aqs, start_date, end_date){
  row <- which(rmcab_aqs$aqs == aqs)
  if (length(row) == 0)return(NULL)
  aqs_code <- rmcab_aqs$code[row[1]]
  # Descarga
  data <- download_rmcab_data(
    aqs_code = aqs_code,
    start_date = start_date,
    end_date = end_date
  )
  # --- VALIDACIÓN CRÍTICA ---
  if (is.null(data) || nrow(data) == 0){ 
    return(NULL)
    }
  
  data$site <- aqs
  data$lat<- rmcab_aqs$lat[row[1]]
  data$lon <- rmcab_aqs$lon[row[1]]
  
  # LIMPIEZA DE NOMBRES Y FORMATOS
  names(data) <- tolower(names(data))
  names(data)[names(data) == "vel_viento"] <- "ws"
  names(data)[names(data) == "dir_viento"] <- "wd"
  # Conversion Numerica
  data$ws <- as.numeric(data$ws)
  data$wd <- as.numeric(data$wd)
  data$date <- as.POSIXct(data$date, tz="UTC")
  # ESCUDO PARA "TRUE/FALSE needed" (Limpiar NAs críticos)
  # Solo dejamos filas que tengan Fecha, Viento y Dirección
  data <- data[!is.na(data$date),]
  
  if (is.null(data) || nrow(data) == 0 ) return(NULL)
  return(as.data.frame(data))
}

#Obtener el contaminante dominante y su concentracion
get_rmcab_summary <- function(update = NULL) {
  # Lista de contaminantes que definiste
  contaminantes_validos <- c("pm10", "pm25", "co", "no", "no2", "nox", "so2", "ozono")
  fecha_ayer <- format(Sys.Date()-1, "%d-%m-%Y")
  
  # Estaciones para el resumen
  estaciones_lista <- rmcab_aqs$aqs
  all_data <- list()
  
  n <- length(estaciones_lista)
  
  for(i in 1:n) {
    est <- estaciones_lista[i]
    
    # --- MENSAJE PARA LA BARRA DE PROGRESO ---
    if (is.function(update)) {
      update(value = i/n, detail = paste("Descargando estación:", est))
    }
    
    # Escudo de error individual por estación
    resultado_estacion <- try({
      get_data_clean(aqs = est, start_date = fecha_ayer, end_date = fecha_ayer)
    }, silent = TRUE)
    
    if(!inherits(resultado_estacion, "try-error") && !is.null(resultado_estacion)) {
      temp <- resultado_estacion
      names(temp) <- tolower(names(temp))
      
      # Filtrado estricto de contaminantes
      columnas_presentes <- intersect(names(temp), contaminantes_validos)
      
      if(length(columnas_presentes) > 0) {
        all_data[[est]] <- temp %>% 
          select(all_of(columnas_presentes)) %>%
          mutate(across(everything(), ~as.numeric(as.character(.x))))
      }
    }
    Sys.sleep(0.4) # Pausa para que el mensaje sea legible
  }
  
  if (length(all_data) == 0) return(NULL)
  
  # Consolidación y promedios
  df_total <- bind_rows(all_data)
  df_total[is.na(df_total)] <- 0
  
  promedios <- df_total %>%
    summarise(across(everything(), ~mean(.x, na.rm = TRUE))) %>%
    pivot_longer(everything(), names_to = "contaminante", values_to = "valor") %>%
    filter(valor > 0) %>% 
    arrange(desc(valor))
  
  if (nrow(promedios) == 0) return(NULL)
  
  dominante <- promedios[1, ]
  
  return(list(
    val = round(dominante$valor, 1), 
    pol = toupper(dominante$contaminante), 
    color = ifelse(dominante$valor > 37, "#FF9800", "#FFEB3B"),
    active = length(all_data)
  ))
}

get_data_for_gif <- function(fecha, contaminante_sel, update = NULL) {
  # Usamos la lista de estaciones de la librería oficial
  estaciones_sin_datos <- c('Bosa', 'Usme')
  estaciones_lista <- bogotAIR::rmcab_aqs$aqs[!bogotAIR::rmcab_aqs$aqs %in% estaciones_sin_datos]
  all_data <- list()
  
  n <- length(estaciones_lista)
  fecha_str <- format(fecha, "%d-%m-%Y")
  
  for(i in 1:n) {
    est <- estaciones_lista[i]
    
    # --- PROGRESO PARA LA UI ---
    if (is.function(update)) {
      update(value = i/n, detail = paste("Descargando estación:", est))
    }
    
    resultado_estacion <- try({
      get_data_clean(aqs = est, start_date = fecha_str, end_date = fecha_str)
    }, silent = TRUE)
    
    if(!inherits(resultado_estacion, "try-error") && !is.null(resultado_estacion)) {
      temp <- resultado_estacion
      names(temp) <- tolower(names(temp))
      
      # Verificamos si la estación mide el contaminante seleccionado
      if(contaminante_sel %in% names(temp)) {
        # Guardamos: Estación, Fecha/Hora y el Valor del contaminante
        all_data[[est]] <- temp %>%
          select(site, date, any_of(c("pm2.5", "pm10", "ozono", "no2", "so2", "co"))) %>%
          mutate(across(-c(site, date), ~as.numeric(as.character(.x))))
      }
    }
    Sys.sleep(0.1) # Pausa más corta para que el GIF no tarde tanto en procesar
  }
  
  if (length(all_data) == 0) return(NULL)
  
  # Unimos todo en un solo dataframe
  return(bind_rows(all_data))}

# Media móvil ponderada NowCast (12h) para PM2.5 y PM10
nowcast <- function(valores){
  # Requiere vector de 12 valores horarios, el más reciente primero
  if(length(valores) < 3) return(NA)
  valores <- valores[1:min(12, length(valores))]
  
  # Rango
  rango <- max(valores, na.rm = TRUE) - min(valores, na.rm = TRUE)
  max_val <- max(valores, na.rm = TRUE)
  if(is.na(max_val) || max_val == 0) return(NA)
  
  # Factor de ponderación
  w <- 1 - (rango / max_val)
  w <- max(w, 0.5)  # mínimo 0.5
  
  # Pesos por hora
  pesos <- w^(0:(length(valores)-1))
  
  # Solo usar horas con datos
  validos <- !is.na(valores)
  if(sum(validos) < 2) return(NA)
  
  resultado <- sum(valores[validos] * pesos[validos]) / sum(pesos[validos])
  return(round(resultado, 2))
}

# Media móvil simple (para O3 8h y CO 8h)
media_movil <- function(valores, ventana = 8){
  if(sum(!is.na(valores)) < ventana * 0.75) return(NA)
  return(mean(valores[1:ventana], na.rm = TRUE))
}

calcular_iboca_horario <- function(df_estacion, hora_objetivo){
  # df_estacion: datos de UNA estación ordenados por fecha descendente
  # hora_objetivo: POSIXct de la hora que queremos calcular
  
  df_estacion <- df_estacion[order(df_estacion$date, decreasing = TRUE), ]
  
  # Filtrar hasta la hora objetivo
  df_antes <- df_estacion[df_estacion$date <= hora_objetivo, ]
  
  if(nrow(df_antes) == 0) return(NA)
  
  # PM2.5 y PM10: NowCast 12h
  pm25_vals <- head(df_antes$`pm2.5`, 12)
  pm10_vals <- head(df_antes$pm10,    12)
  
  pm25_nc <- nowcast(pm25_vals)
  pm10_nc <- nowcast(pm10_vals)
  
  # O3 y CO: media 8h
  o3_vals <- head(df_antes$ozono, 8)
  co_vals <- head(df_antes$co,    8)
  
  o3_8h <- media_movil(o3_vals, 8)
  co_8h <- media_movil(co_vals, 8)
  
  # NO2 y SO2: valor horario (1h)
  no2_1h <- df_antes$no2[1]
  so2_1h <- df_antes$so2[1]
  
  return(calcular_iboca(pm25_nc, pm10_nc, o3_8h, no2_1h, so2_1h, co_8h))
}

# Función para calcular el IBOCA
calcular_iboca <- function(pm2.5 = NA, pm10 = NA, ozono = NA, 
                           no2 = NA, so2 = NA, co = NA) {
  
  # Sub-índice por contaminante según tabla IBOCA
  subindice <- function(valor, breakpoints_conc, breakpoints_iboca) {
    if (is.na(valor)) return(NA)
    
    for (i in 1:(length(breakpoints_conc) - 1)) {
      if (valor >= breakpoints_conc[i] && valor <= breakpoints_conc[i + 1]) {
        iboca <- ((breakpoints_iboca[i + 1] - breakpoints_iboca[i]) /
                    (breakpoints_conc[i + 1] - breakpoints_conc[i])) *
          (valor - breakpoints_conc[i]) + breakpoints_iboca[i]
        return(round(iboca))
      }
    }
    return(500) # fuera de rango máximo
  }
  
  # Breakpoints de concentración y sus IBOCA correspondientes
  i_pm25  <- subindice(pm2.5,
                       c(0, 12,   35.4, 55.4,  151.2, 250.4, 500.4),
                       c(0, 50,  100,   150,   200,   300,   500))
  
  i_pm10  <- subindice(pm10,
                       c(0, 27.2, 63.8, 95.5,  246.7, 405.2, 800.4),
                       c(0, 50,  100,   150,   200,   300,   500))
  
  i_o3    <- subindice(ozono,
                       c(0, 72,  107,   137,   281,   432,   809),
                       c(0, 50,  100,   150,   200,   300,   500))
  
  i_no2   <- subindice(no2,
                       c(0, 28.5, 84.1, 132.2, 361.9, 602.6, 1202.6),
                       c(0, 50,  100,   150,   200,   300,   500))
  
  i_so2   <- subindice(so2,
                       c(0, 9.6,  38.5, 63.5,  182.7, 307.7, 619.2),
                       c(0, 50,  100,   150,   200,   300,   500))
  
  i_co    <- subindice(co,
                       c(0, 2549, 5022, 7165,  17384, 28099, 54802),
                       c(0, 50,   100,  150,   200,   300,   500))
  
  # IBOCA = máximo de todos los sub-índices disponibles
  valores <- c(i_pm25, i_pm10, i_o3, i_no2, i_so2, i_co)
  valores <- valores[!is.na(valores)]
  if (length(valores) == 0) return(NA)
  iboca_final <- max(valores)
  
  if (is.infinite(iboca_final)) return(NA)
  return(iboca_final)
}

color_iboca <- function(iboca) {
  if (is.na(iboca))      return(list(color = "#CCCCCC", nivel = "Sin datos",    emoji = "⚪"))
  if (iboca <= 50)       return(list(color = "#68E045", nivel = "Bajo",         emoji = "🟢"))
  if (iboca <= 100)      return(list(color = "#FFFE54", nivel = "Moderado",     emoji = "🟡"))
  if (iboca <= 150)      return(list(color = "#ECBA41", nivel = "Regular",      emoji = "🟠"))
  if (iboca <= 200)      return(list(color = "#E63527", nivel = "Alto",         emoji = "🔴"))
  if (iboca <= 300)      return(list(color = "#8F3F97", nivel = "Peligroso",    emoji = "🟣"))
  return(                 list(color = "#66329A", nivel = "Muy Peligroso",      emoji = "⛔"))
}
