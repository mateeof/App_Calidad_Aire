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
  return(res)
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
