library(openair)
library(gganimate)
library(magick)
library(transformr)
library(ggplot2)

plot_time_variation <- function(data, pollutant){
  
  fecha_ini <- format(min(as.Date(data$date), na.rm = TRUE), "%d/%m/%Y")
  fecha_fin <- format(max(as.Date(data$date), na.rm = TRUE), "%d/%m/%Y")
  periodo   <- paste0("Período: ", fecha_ini, " - ", fecha_fin)
  
  res <- timeVariation(
    data,
    pollutant = pollutant,
    main = periodo,
    ylab = pollutant,
    xlab = c("Dia y hora de la semana", "Hora", "Mes", "Semana")
  )
  invisible(res)
}

plot_time_variation_pm <- function(data){
  fecha_ini <- format(min(as.Date(data$date), na.rm = TRUE), "%d/%m/%Y")
  fecha_fin <- format(max(as.Date(data$date), na.rm = TRUE), "%d/%m/%Y")
  periodo   <- paste0("PM10 y PM2.5 | Período: ", fecha_ini, " - ", fecha_fin)
  contaminantes <- intersect(c("pm10", "pm2.5"), names(data))
  timeVariation(
    data,
    pollutant = contaminantes,
    normalise = TRUE,
    main      = periodo,
    xlab      = c("Dia y hora de la semana", "Hora", "Mes", "Semana"),
    ylab= "Nivel normalizado"
  )
}

plot_time_variation_o3no2 <- function(data){
  fecha_ini <- format(min(as.Date(data$date), na.rm = TRUE), "%d/%m/%Y")
  fecha_fin <- format(max(as.Date(data$date), na.rm = TRUE), "%d/%m/%Y")
  periodo   <- paste0("O3 y NO2   |   Período: ", fecha_ini, " - ", fecha_fin)
  contaminantes <- intersect(c("ozono", "no2"), names(data))
  timeVariation(
    data,
    pollutant = contaminantes,
    normalise = TRUE,
    main = periodo,
    xlab = c("Dia y hora de la semana", "Hora", "Mes", "Semana"),
    ylab= "Nivel normalizado"
  )
}

plot_pollution_rose <- function(data, pollutant){
  res<-pollutionRose(
    data, 
    pollutant = pollutant,
    sub="Frecuencia de registros por dirección del viento (%)",
    labels=c("Norte", "NE", "Oriente", "SE", "Sur", "SO", "Occidente", "NO"),
    key=list(
      header= "Niveles de \nconcentración",
      footer= paste("Unidades", toupper(pollutant))
    ),
    annotate=FALSE
    )
  return(res)
}

plot_correlation <- function (data){
  res<-corPlot(data)
  return(res)
}

plot_scatter <- function (data, x,y){
  res <- scatterPlot(data,x,y,method = "scatter")
}

plot_calendar <- function(data, pollutant, anio, mes){
  calendarPlot(
    data,
    pollutant = pollutant,
    year = as.integer(anio),
    par.settings = list( fontsize = list(text = 10, points = 10),par.main.text = list(cex = 1.2) )
  )
  title(nombre_mes, cex.main=10)
  invisible(res)
}

