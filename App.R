library(shiny)
library(bslib)
library(bsicons)
library(leaflet)
library(ggplot2)
library(shinycssloaders)
library(bogotAIR)


source("Scripts/data_download_processing.R")
source("Scripts/plots.R")
source("Paginas/time_variation.R")
source("Paginas/rose_pollution.R")
source("Paginas/cor_plot.R")

# Dataset de Estaciones (Coordenadas aproximadas RMCAB)
# --- Dataset de Estaciones Completo (RMCAB) ---
estaciones_bog <- data.frame(
  nombre = c(
    "Guaymaral", "Suba", "Fontibón", "Las Ferias", "Puente Aranda", 
    "Kennedy", "Carvajal - Sevillana", "Tunal", "Usme", "Centro de Alto Rendimiento",
    "MinAmbiente", "Jazmin", "Usaquen", "San Cristobal", "Movil 7ma", 
    "Bolivia", "Ciudad Bolivar", "Colina", "Movil Fontibon"
  ),
  lat = c(
    4.783, 4.761, 4.670, 4.690, 4.630, 
    4.625, 4.595, 4.576, 4.530, 4.658,
    4.625, 4.608, 4.710, 4.573, 4.628,
    4.712, 4.560, 4.750, 4.675
  ),
  lng = c(
    -74.043, -74.093, -74.141, -74.086, -74.117, 
    -74.161, -74.148, -74.130, -74.120, -74.085,
    -74.066, -74.125, -74.030, -74.083, -74.065,
    -74.128, -74.150, -74.068, -74.145
  )
)

# Tema profesional con tonos pasteles
my_theme <- bs_theme(
  version = 5,
  bootswatch = "minty",
  primary = "#2E8B57",  
  secondary = "#4682B4", 
  base_font = font_google("Manrope"),
  heading_font = font_google("Montserrat")
)
#--- UI ---

ui <- page_fillable(
  theme = my_theme,
  
  # BARRA SUPERIOR
  div(class = "d-flex justify-content-between align-items-center p-3", 
      style = "background-color: #E0F2F1; border-bottom: 2px solid #B2DFDB;",
      h3("Calidad de Aire Bogotá", style = "margin: 0; color: #2E8B57; font-weight: 700;"),
      tags$img(src = "Logo Unal Sin Fondo.png", height = "45px")
  ),
  
  navset_hidden(
    id = "paginas_app",
    
    # --- PÁGINA 1: INICIO ---
    nav_panel_hidden("inicio",
                     div(style = "width: 100%; padding: 20px;",
                         
                         # FILA SUPERIOR: MAPA Y BLOQUE 
                         layout_column_wrap(
                           width = 1/2,
                           heights_equal = "row",
                           
                           card(
                             card_header(class = "bg-light", strong("Estaciones de Monitoreo RMCAB")),
                             leafletOutput("mapa_bogota", height = "400px")
                           ),
                           
                           # BLOQUE DERECHO:
                           card(
                             style= "padding:20px; border-radius: 15px;",
                             div(class= "text-center mb-3",
                                 h4("Estado Actual de la Calidad del Aire", style= "font-weight:600")
                                 ),
                             div(class="d-flex justify-content-around align-items-center mb-4",
                                 uiOutput("ica_box_ui"),
                                 uiOutput("contaminante_ui")
                                 ),
                             div(class = "text-center mb-4",
                                 actionButton("generar_estado"," Generar Estado Actual",
                                              icon = icon("play"), class="btn-success btn-lg")
                                 ),
                             div(style = "background-color: #F8F9FA; padding: 15px; border-radius: 10px; border: 1px solid #eee;",
                                 p(strong("Nota técnica:"), " Los valores corresponden al promedio de la red monitoreada el día anterior.", 
                                   style = "font-size: 0.85rem; color: #555; text-align: center;")
                             ),
                           )
                         ),
                         
                         br(),
                         h4("Módulos de Análisis Avanzado", style = "text-align: center; margin: 20px 0;"),
                         
                         # FILA INFERIOR: TARJETAS CON TEXTO/IMG Y BOTÓN ANCHO
                         layout_column_wrap(
                           width = 1/3,
                           heights_equal = "row",
                           
                           # Tarjeta 1
                           card(
                             card_header("Dinámica Temporal", class = "bg-primary text-white",style="font-size:1.2rem"),
                             card_body(
                               #Texto arriba
                              div(style = "min-height: 100px;",
                                p(strong("¿En qué momentos del día o la semana se alcanzan los picos críticos de polución?"), 
                                  style = "font-size: 1rem; color: #2E8B57; margin-bottom: 5px;text-align:center"),
                                p("Explora ciclos horarios, diarios y mensuales mediante modelos de variación estadística.", 
                                  style = "font-size: 1rem; color: #666;")
                              ),
                              #Imagen debajo
                              div(class= "text-center my-3",
                                  tags$img(src="timeVariation.png", style = "width: 100%; max-height: 200px; object-fit: contain; border-radius: 5px;")
                              )
                               ),
                             card_footer(
                               actionButton("ir_analisis", "Abrir Análisis Temporal", class = "btn-outline-primary w-100")
                             )
                             ),
                           
                           # Tarjeta 2
                           card(
                             card_header("Origen y Dispersión", class = "bg-info text-white",style="font-size:1.2rem"),
                             card_body(
                               div(style = "min-height: 100px;",
                                   p(strong("¿Desde qué dirección provienen las masas de aire más contaminadas hacia la estación?"), 
                                     style = "font-size: 1rem; color: #007BFF; margin-bottom: 5px;text-align:center"),
                                   p("Cruza datos de velocidad y dirección del viento para localizar fuentes de emisión potenciales.", 
                                     style = "font-size: 1rem; color: #666;")
                               ),
                               div(class = "text-center my-3",
                                   tags$img(src = "pollutionRose.png", 
                                            style = "width: 100%; max-height: 200px; object-fit: contain; border-radius: 5px;")
                               )
                             ),
                             card_footer(
                               actionButton("ir_rosa", "Generar Rosa de Vientos", class = "btn-outline-info w-100")
                             )
                           ),
                           
                           # Tarjeta 3
                           card(
                             card_header("Relación Multivariada", class = "bg-dark text-white",style="font-size:1.2rem"),
                             card_body(
                               div(style = "min-height: 100px;",
                                   p(strong("¿Cómo influye la humedad o la temperatura en la concentración de material particulado?"), 
                                     style = "font-size: 1rem; color: #343a40; margin-bottom: 5px;text-align:center"),
                                   p("Analiza la dependencia lineal entre variables meteorológicas y contaminantes críticos.", 
                                     style = "font-size: 1rem; color: #666;")
                               ),
                               div(class = "text-center my-3",
                                   tags$img(src = "correlation.png", 
                                            style = "width: 100%; max-height: 200px; object-fit: contain; border-radius: 5px;")
                               )
                             ),
                             card_footer(
                               actionButton("ir_cor", "Ver Matriz de Correlación", class = "btn-outline-dark w-100")
                             )
                           )
                         )
                     )
    ),
    
    # 1. REFERENCIA A TUS UI EXTERNAS
    # Estos IDs deben coincidir con los que usas en nav_select en el server
    nav_panel_hidden("pagina_analisis", ui_time_variation),
    nav_panel_hidden("pagina_rosa", ui_rose_pollution),
    nav_panel_hidden("pagina_cor", ui_corplot)
  ),
  # --- FOOTER (AÑADIR AL FINAL DE TU UI) ---
  tags$footer(
    style = "background-color: #f8f9fa; padding: 30px 0; border-top: 1px solid #dee2e6; margin-top: 20px;",
    div(class = "container",
        div(class = "row align-items-center",
            # Columna Izquierda: Información de la Red
            div(class = "col-md-4 text-center text-md-start",
                p(strong("Datos RMCAB"), style = "margin-bottom: 5px;"),
                p("Red de Monitoreo de Calidad del Aire de Bogotá.", 
                  style = "font-size: 0.85rem; color: #666;")
            ),
            # Columna Central: Créditos
            div(class = "col-md-4 text-center",
                p(strong("Desarrollado por:"), " Andres Franco", style = "margin-bottom: 5px;"),
                p("© 2026 - Universidad Nacional de Colombia", 
                  style = "font-size: 0.8rem; color: #999; font-style: italic;")
            ),
            # Columna Derecha: Enlaces rápidos (Opcional)
            div(class = "col-md-4 text-center text-md-end",
                a("Manual de Usuario", href = "#", style = "color: #2E8B57; text-decoration: none; font-size: 0.9rem;"),
                br(),
                a("Contacto Soporte", href = "mailto:anfrancor@unal.edu.co", style = "color: #2E8B57; text-decoration: none; font-size: 0.9rem;")
            )
        )
    )
  )
)

server <- function (input, output, session){

  # --- NAVEGACIÓN ---
  
  # El ID "paginas_app" es el del navset_hidden. 
  # El segundo argumento es el valor del nav_panel_hidden definido arriba.
  observeEvent(input$ir_analisis, { nav_select("paginas_app", "pagina_analisis") })
  observeEvent(input$ir_rosa, { nav_select("paginas_app", "pagina_rosa") })
  observeEvent(input$ir_cor, { nav_select("paginas_app", "pagina_cor") })
  
  # Lógica para botones de "Volver" 
  observeEvent(input$volver_inicio, { nav_select("paginas_app", "inicio") })
  observeEvent(input$volver_inicio2, { nav_select("paginas_app", "inicio") })
  observeEvent(input$volver_inicio3, { nav_select("paginas_app", "inicio") })
  
  
  #INICIADORES
  observe({
    req(rmcab_aqs)
    #ESTACIONES
    updateSelectInput(session, "station", choices = rmcab_aqs$aqs)
    updateSelectInput(session, "station_rose", choices = rmcab_aqs$aqs)
    updateSelectInput(session, "station_corplot", choices = rmcab_aqs$aqs)
    #CONTAMINANTES
    lista_contaminantes <- c("pm10", "pm25", "co", "no", "no2", "nox", "so2", "ozono")
    updateSelectInput(session, "pollutant", choices = lista_contaminantes)
    updateSelectInput(session, "pollutant_rose", choices = lista_contaminantes)
    
  })
  
  
  
  #--- MAPA BOGOTÁ CON LAS 10 ESTACIONES -----
  
  output$mapa_bogota <- renderLeaflet({
    #Icono estacion
    icono_estacion <- makeIcon(
      iconUrl = "broadcasting.png",
      iconWidth = 35, iconHeight = 35,
      iconAnchorX = 17, iconAnchorY = 35
    )
    
    leaflet(estaciones_bog) %>%
      addProviderTiles(providers$CartoDB.Positron) %>%
      setView(lng = -74.10, lat = 4.65, zoom = 11) %>%
      addMarkers(
        lng = ~lng, lat = ~lat,
        icon = icono_estacion,
        popup = ~nombre,
        label = ~nombre
      )
  })

  
  #---- Contaminante Dominante con Botón y Progreso -----
  
  # 1. Creamos una variable reactiva vacía
  resumen_data <- reactiveVal(NULL)
  
  # 2. Lógica al presionar el botón
  observeEvent(input$generar_estado, {
    
    # Mostramos la barra de progreso en la UI
    withProgress(message = 'Iniciando conexión con RMCAB...', value = 0.1, {
      
      # Llamamos a la función enviándole el objeto de progreso
      res <- get_rmcab_summary(update=setProgress) 
      
      # Guardamos el resultado final
      resumen_data(res)
    })
  })
  
  # 3. Recuadro con el valor del contaminante (Reactivo al botón)
  output$ica_box_ui <- renderUI({
    res <- req(resumen_data()) # Solo aparece cuando le das al botón
    
    div(style= paste0("background-color: ", res$color, "; padding: 15px 35px; border-radius: 12px; text-align: center; border: 1px solid #FDD835;"),
        h1(res$val, style="font-size: 3.5rem; font-weight:800; margin:0;"), # Corregida coma por punto y coma en style
        span("µg/m³ (Promedio)", style = "font-weight: 600; font-size: 1.1rem;")
    )
  })
  
  # 4. Texto del contaminante dominante
  output$contaminante_ui <- renderUI({
    res <- req(resumen_data())
    
    div(class="text-center",
        p("Contaminante Dominante", style = "color: #666; margin-bottom:0; font-size:1.1rem;"),
        h2(res$pol, style = "font-weight:800; font-size: 3rem; color:#333")
    )
  })
  
  # 5. Actualizar estaciones activas
  output$estaciones_count <- renderText({
    res <- resumen_data() 
    if(is.null(res)) return("0 / 19")
    paste0(res$active, " / 19")
  })

  
  #----LOGICA PAGINA: Variacion Temporal----

datos_time_historicos <- reactiveVal(NULL)
esta_cargando_time <- reactiveVal(FALSE)
#Control Dinamico Boton
output$control_time_ui <- renderUI({
  if(esta_cargando_time()){
    div(
      style= "padding:10px; background: #E8F5E9; border-radius: 8px; border: 1px solid #C8E6C9;",
      p("Descargando datos de la RMCAB...", style="font-weight:bold; color: #2e7d32; margin_bottom: 5px"),
      textOutput("mensaje_carga_time")
    )
  }else{
    actionButton("generar_time", "Generar Gráfica Temporal",
    icon=icon("chart-line"),
    class="btn-primary",style="width: 100%;font-weight:700;")
  }
})
#Logica descarga al presionar boton
observeEvent(input$generar_time,{
  req(input$dates, input$station)
  esta_cargando_time(TRUE)
  
  withProgress(message = "Conectando con servidor RMCAB...", value=0,{
    #Ejecutamos descarga
    resultado <- try({
      get_data_clean(
        aqs=input$station,
        start_date = format(input$dates[1],"%d-%m-%Y"),
        end_date = format(input$dates[2], "%d-%m-%Y")
      )
    },silent = TRUE)
    
    #Detectar error
    if(inherits(resultado, "try-error")){
      message("Error detectado en get_data_clean:",resultado)
      datos_time_historicos(NULL) 
    }else{
      datos_time_historicos(resultado)
    }
  })
  esta_cargando_time(FALSE)
})
#Renderizar la grafica
output$time_variation_plot<-renderPlot({
  df<-datos_time_historicos()
  if(is.null(df)){
    return(NULL)
  }
  validate(
    need(is.data.frame(df), "Hubo un problema técnico al procesar los datos"),
    need(nrow(df)>0,"La RMCAB no devolvió datos para esta estación en estas fechas."),
    need(input$pollutant %in% names (df), paste("La estacion", input$station, "no mide", input$pollutant))
  )
  #Intentat graficas
  tryCatch({
    plot_time_variation(data = df,pollutant = input$pollutant)
  }, error= function(e){
    validate("Error de graficación: No hay suficientes datos válidos para este contaminante")
  })
  
})

#----LOGICA PAGINA: Rosa de Contaminantes----

datos_rose <- reactiveVal(NULL)
esta_cargando_rose <- reactiveVal(FALSE)
#Control Dinamico Boton
output$control_rose_ui <- renderUI({
  if(esta_cargando_rose()){
    div(
      style= "padding:10px; background: #E8F5E9; border-radius: 8px; border: 1px solid #C8E6C9;",
      p("Descargando datos de la RMCAB...", style="font-weight:bold; color: #2e7d32; margin_bottom: 5px"),
      textOutput("mensaje_carga_rose")
    )
  }else{
    actionButton("generar_rose", "Generar Rosa de Contaminantes",
                 icon=icon("wind"),
                 style = "background-color: #0277BD; color: white; border: none; width: 100%; font-weight:700; padding: 10px; border-radius: 5px;")
  }
})
#Logica descarga al presionar boton
observeEvent(input$generar_rose,{
  req(input$dates_rose, input$station_rose)
  esta_cargando_rose(TRUE)
  
  withProgress(message = "Obteniendo datos meteorologicos...", value=0.1,{
    output$mensaje_carga_rose <- renderText({ 
      paste("Descargando:", input$station_rose) 
    })
    #Ejecutamos descarga
    df <- try({
      get_data_clean(
        aqs=input$station_rose,
        start_date = format(input$dates_rose[1],"%d-%m-%Y"),
        end_date = format(input$dates_rose[2], "%d-%m-%Y")
      )
    },silent = TRUE)
    
    #Detectar error
    if(inherits(df, "try-error")){
      message("Error detectado en get_data_clean:",df)
      datos_rose("error_api") 
    }else{
      datos_rose(df)
    }
  })
  esta_cargando_rose(FALSE)
})
#Renderizar la grafica
output$plot_rose<-renderPlot({
  df<-datos_rose()
  if(is.null(df)){
    return(NULL)
  }
  validate(
    need(!inherits(df, "character"), 
         paste("La estación", input$station_rose, "no reporta sensores activos en la RMCAB.")),
    need(is.data.frame(df), "Hubo un problema técnico al procesar los datos"),
    need(nrow(df)>0,"La RMCAB no devolvió datos para esta estación en estas fechas."),
    need(any(!is.na(df$ws)) && any(!is.na(df$wd)), 
         "Esta estación no cuenta con datos de viento (velocidad/dirección) para este periodo."),
    need(input$pollutant_rose %in% names (df), paste("La estacion", input$station_rose, "no mide", toupper(input$pollutant_rose)))
  )
  #Intentat graficas
  tryCatch({
    plot_pollution_rose(data = df,pollutant = input$pollutant_rose)
  }, error= function(e){
    validate("Error de graficación: No hay suficientes datos válidos para este contaminante")
  })
  
})

#----LOGICA PAGINA: Correlacion de Contaminantes----

#----LOGICA PAGINA: Correlacion de Contaminantes----

datos_corplot <- reactiveVal(NULL)
esta_cargando_corplot <- reactiveVal(FALSE)

# Control Dinámico Botón
output$control_corplot_ui <- renderUI({
  if(esta_cargando_corplot()){
    div(
      style= "padding:10px; background: #E8F5E9; border-radius: 8px; border: 1px solid #C8E6C9;",
      p("Descargando datos de la RMCAB...", style="font-weight:bold; color: #2e7d32; margin_bottom: 5px"),
      textOutput("mensaje_carga_corplot")
    )
  } else {
    actionButton("generar_corplot", "Generar Correlación de Contaminantes",
                 icon=icon("table"), 
                 style = "background-color: #455A64; color: white; border: none; width: 100%; font-weight:700; padding: 10px;")
  }
})

# Lógica descarga al presionar botón
observeEvent(input$generar_corplot, {
  req(input$dates_corplot, input$station_corplot)
  esta_cargando_corplot(TRUE)
  
  withProgress(message = "Obteniendo datos para matriz...", value=0.2, {
    output$mensaje_carga_corplot <- renderText({ 
      paste("Analizando estación:", input$station_corplot) 
    })
    
    # Ejecutamos descarga
    df <- try({
      get_data_clean(
        aqs = input$station_corplot,
        start_date = format(input$dates_corplot[1], "%d-%m-%Y"),
        end_date = format(input$dates_corplot[2], "%d-%m-%Y")
      )
    }, silent = TRUE)
    
    # Detectar error técnico (Bosa/Usme/API)
    if(inherits(df, "try-error")){
      datos_corplot("error_api") 
    } else {
      datos_corplot(df)
    }
  })
  esta_cargando_corplot(FALSE)
})

# Renderizar la gráfica
output$plot_corplot <- renderPlot({
  df <- datos_corplot()
  
  if(is.null(df)) return(NULL)
  
  # 1. Validaciones de integridad
  validate(
    need(!inherits(df, "character"), 
         paste("La estación", input$station_corplot, "no reporta sensores activos en la RMCAB.")),
    need(is.data.frame(df) && nrow(df) > 0, 
         "La RMCAB no devolvió datos para esta estación en estas fechas.")
  )
  
  # 2. FILTRO DE CONTAMINANTES: Aquí quitamos ws, wd, etc.
  lista_blanca <- c("pm10", "pm25", "co", "no", "no2", "nox", "so2", "ozono")
  df_contaminantes <- df[, names(df) %in% lista_blanca, drop = FALSE]
  
  # 3. Validación de columnas suficientes para correlación
  validate(
    need(ncol(df_contaminantes) >= 2, 
         "Esta estación no tiene suficientes contaminantes diferentes para establecer una correlación.")
  )
  
  # Intentar graficar
  tryCatch({
    # Usamos el dataframe filtrado
    plot_correlation(data = df_contaminantes)
  }, error = function(e){
    validate("Error de graficación: Los datos actuales no permiten generar la matriz (posibles NAs masivos).")
  })
})

  
}
shinyApp(ui, server)
