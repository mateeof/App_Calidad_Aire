library(shiny)
library(bslib)
library(bsicons)
library(leaflet)
library(ggplot2)
library(shinycssloaders)
library(bogotAIR)
library(gganimate)
library(magick)
library(httr2)
library(jsonlite)
library(dplyr)
library(lubridate)
#library(osmdata)
library(sf)
library(png)
library(maptiles)

source("Scripts/data_download_processing.R")
source("Scripts/plots.R")
source("Scripts/analisis_ia.R")
source("Paginas/time_variation.R")
source("Paginas/rose_pollution.R")
source("Paginas/cor_plot.R")
source("Paginas/gif_maker.R")
source("Paginas/Scatter_plot.R")
source("Paginas/teoria.R")


# Dataset de Estaciones (Coordenadas aproximadas RMCAB)
# --- Dataset de Estaciones Completo (RMCAB) ---
estaciones_bog <- rmcab_aqs[,c("aqs","lat","lon")]
names(estaciones_bog)<-c("nombre","lat","lng")

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
  
  #Para que al darle click a los botones salga arriba de la pagina, actualiza el scroll
  tags$script("
  Shiny.addCustomMessageHandler('scroll-top', function(message) {
    window.scrollTo({top: 0, behavior: 'smooth'});
  });
"),
  theme = my_theme,
  
  # BARRA SUPERIOR
  div(class = "d-flex justify-content-between align-items-center p-3", 
      style = "background-color: #E0F2F1; border-bottom: 2px solid #B2DFDB;",
      div(class="d-flex align-items-center gap-3",
      h3("Calidad de Aire Bogotá", style = "margin: 0; color: #2E8B57; font-weight: 700;"),
      actionLink("volver_teoria", "Ver Teoría",
                 icon= icon("book-open"),
                 style="color #4682b4;text-decoration:none; font-weight:600"),
      actionLink("empezar_app2", "Ver Analisís",
                 icon= icon("rocket"),
                 style="color #4682b4;text-decoration:none; font-weight:600")),
      
      tags$img(src = "Logo Unal Sin Fondo.png", height = "45px")
  ),
  
  navset_hidden(
    id = "paginas_app",
    
    nav_panel_hidden("teoria", ui_teoria),
    
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
                             )
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
                             # Estilo de la card: Bordes redondeados y sombra sutil para que flote sobre el fondo #f5f5f5
                             style = "border-radius: 15px; border: none; box-shadow: 0 4px 15px rgba(0,0,0,0.05); overflow: hidden; transition: transform 0.3s ease;",
                             
                             card_header(
                               div(class = "d-flex align-items-center",
                                   bs_icon("clock-history", size = "1.5rem", class = "me-2"),
                                   span("Dinámica Temporal", style = "font-weight: 700; font-size: 1.25rem;")
                               ),
                               # Cambiamos el azul primario por un Slate-Blue más profesional
                               style = "background-color: #2c3e50; color: white; border: none; padding: 15px;"
                             ),
                             
                             card_body(
                               style = "padding: 20px; background-color: white;",
                               
                               # Texto superior
                               div(style = "min-height: 90px; text-align: center;",
                                   p("¿En qué momentos se alcanzan los picos críticos de polución?", 
                                     style = "font-size: 1.1rem; color: #2E8B57; font-weight: 700; margin-bottom: 8px; line-height: 1.2;"),
                                   p("Identifica ciclos horarios y patrones semanales mediante modelos de variación estadística avanzada.", 
                                     style = "font-size: 0.95rem; color: #7f8c8d; font-weight: 400;")
                               ),
                               
                               # Contenedor de Imagen con efecto de marco
                               div(class = "text-center my-3",
                                   style = "border-radius: 10px; padding: 10px; border: 1px solid #edf2f7;",
                                   tags$img(
                                     src = "timeVariation.png", 
                                     style = "width: 100%; max-height: 180px; object-fit: contain; filter: drop-shadow(0 2px 4px rgba(0,0,0,0.1));"
                                   )
                               )
                             ),
                             
                             card_footer(
                               style = "background: white; border-top: 1px solid #f1f1f1; padding: 15px;",
                               # El botón ahora es sólido para invitar a la acción (Call to Action)
                               actionButton(
                                 "ir_analisis", 
                                 "Explorar Análisis Temporal", 
                                 icon = bs_icon("arrow-right-circle"),
                                 style = "background-color: #1A73E8; color: white; border: none; width: 100%; font-weight: 700; padding: 12px; border-radius: 8px; transition: 0.3s;",
                                 class = "btn-hover-effect" # Puedes añadir una clase para efectos CSS
                               )
                             )
                           ),
                           
                           # Tarjeta 2
                           card(
                             # Mantenemos el radio de 15px y la sombra suave para consistencia visual
                             style = "border-radius: 15px; border: none; box-shadow: 0 4px 15px rgba(0,0,0,0.05); overflow: hidden; transition: transform 0.3s ease;",
                             
                             card_header(
                               div(class = "d-flex align-items-center",
                                   bs_icon("compass", size = "1.5rem", class = "me-2"),
                                   span("Origen y Dispersión", style = "font-weight: 700; font-size: 1.25rem;")
                               ),
                               # Usamos un azul profundo pero vibrante para el tema de vientos
                               style = "background-color: #0369A1; color: white; border: none; padding: 15px;"
                             ),
                             
                             card_body(
                               style = "padding: 20px; background-color: white;",
                               
                               # Texto superior: Pregunta gancho
                               div(style = "min-height: 90px; text-align: center;",
                                   p("¿Desde qué dirección provienen las masas de aire más contaminadas?", 
                                     style = "font-size: 1.1rem; color: #0284C7; font-weight: 700; margin-bottom: 8px; line-height: 1.2;"),
                                   p("Cruza datos de velocidad y dirección del viento para localizar fuentes de emisión potenciales en la ciudad.", 
                                     style = "font-size: 0.95rem; color: #7f8c8d; font-weight: 400;")
                               ),
                               
                               # Contenedor de Imagen con marco celeste suave
                               div(class = "text-center my-3",
                                   style = "border-radius: 10px; padding: 10px; border: 1px solid #E0F2FE;",
                                   tags$img(
                                     src = "pollutionRose.png", 
                                     style = "width: 100%; max-height: 180px; object-fit: contain; filter: drop-shadow(0 2px 4px rgba(0,0,0,0.08));"
                                   )
                               )
                             ),
                             
                             card_footer(
                               style = "background: white; border-top: 1px solid #f1f1f1; padding: 15px;",
                               # Botón Call to Action unificado con el estilo de la app
                               actionButton(
                                 "ir_rosa", 
                                 "Analizar Procedencia", 
                                 icon = bs_icon("wind"),
                                 style = "background-color: #0369A1; color: white; border: none; width: 100%; font-weight: 700; padding: 12px; border-radius: 8px;",
                                 class = "btn-hover-effect"
                               )
                             )
                           ),
                           
                           # Tarjeta 3
                           card(
                             # Mantenemos el estándar de 15px de radio y sombra suave para consistencia
                             style = "border-radius: 15px; border: none; box-shadow: 0 4px 15px rgba(0,0,0,0.05); overflow: hidden; transition: transform 0.3s ease;",
                             
                             card_header(
                               div(class = "d-flex align-items-center",
                                   bs_icon("grid-3x3-gap", size = "1.5rem", class = "me-2"),
                                   span("Relación Multivariada", style = "font-weight: 700; font-size: 1.25rem;")
                               ),
                               # Usamos un tono pizarra oscuro para denotar seriedad analítica
                               style = "background-color: #34495e; color: white; border: none; padding: 15px;"
                             ),
                             
                             card_body(
                               style = "padding: 20px; background-color: white;",
                               
                               # Texto superior
                               div(style = "min-height: 90px; text-align: center;",
                                   p("¿Cómo influye el clima en la concentración de partículas?", 
                                     style = "font-size: 1.1rem; color: #2c3e50; font-weight: 700; margin-bottom: 8px; line-height: 1.2;"),
                                   p("Analiza la dependencia lineal entre variables meteorológicas y contaminantes críticos mediante matrices de Pearson.", 
                                     style = "font-size: 0.95rem; color: #7f8c8d; font-weight: 400;")
                               ),
                               
                               # Contenedor de Imagen con marco gris técnico
                               div(class = "text-center my-3",
                                   style = "border-radius: 10px; padding: 10px; border: 1px solid #e2e8f0;",
                                   tags$img(
                                     src = "correlation.png", 
                                     style = "width: 100%; max-height: 180px; object-fit: contain; filter: drop-shadow(0 2px 4px rgba(0,0,0,0.08));"
                                   )
                               )
                             ),
                             
                             card_footer(
                               style = "background: white; border-top: 1px solid #f1f1f1; padding: 15px;",
                               # Botón sólido para mantener la jerarquía de botones principales
                               actionButton(
                                 "ir_cor", 
                                 "Visualizar Matriz", 
                                 icon = bs_icon("table"),
                                 style = "background-color: #34495e; color: white; border: none; width: 100%; font-weight: 700; padding: 12px; border-radius: 8px;",
                                 class = "btn-hover-effect"
                               )
                             )
                           ),
                           # Tarjeta 4: Mapa Animado (GIF)
                           card(
                             style = "border-radius: 15px; border: none; box-shadow: 0 4px 15px rgba(0,0,0,0.05); overflow: hidden; transition: transform 0.3s ease;",
                      
                             card_header( div(class = "d-flex align-items-center", bs_icon("map", size = "1.5rem", class = "me-2"), span("Evolución Espacial", style = "font-weight: 700; font-size: 1.25rem;") ),
                               style = "background-color: #F9A825; color: black; border: none; padding: 15px;" ),
                          
                             card_body(style = "padding: 20px; background-color: white;",
                               div(style = "min-height: 90px; text-align: center;",
                                   p("¿Cómo ha cambiado la contaminación con el paso del tiempo?", 
                                     style = "font-size: 1.1rem; color: #2c3e50; font-weight: 700; margin-bottom: 8px; line-height: 1.2;"),
                                   p("Genera un mapa animado donde a partir del IBOCA se logra identificar la evolución mensual de los niveles de contaminación en la ciudad.", 
                                     style = "font-size: 0.95rem; color: #7f8c8d; font-weight: 400;")),
                               
                               div(class = "text-center my-3",
                                   style = "border-radius: 10px; padding: 10px; border: 1px solid #e2e8f0;",
                                   tags$img(
                                     src = "MapaGif.png", 
                                     style = "width: 100%; max-height: 180px; object-fit: contain; filter: drop-shadow(0 2px 4px rgba(0,0,0,0.08));"   )
                               ) ),
                             
                             card_footer(
                               style = "background: white; border-top: 1px solid #f1f1f1; padding: 15px;",
                               actionButton( "ir_gif", "Generar Mapa Animado", icon = bs_icon("play-circle"), style = "background-color: #F9A825; color: black; border: none; width: 100%; font-weight: 700; padding: 12px; border-radius: 8px;",  class = "btn-hover-effect"
                               ) ) ),
                           # Tarjeta 5:Correlacion entre dos contaminantes
                           card(
                             # Consistencia total: radio de 15px, sin borde y sombra sutil
                             style = "border-radius: 15px; border: none; box-shadow: 0 4px 15px rgba(0,0,0,0.05); overflow: hidden; transition: transform 0.3s ease;",
                             
                             card_header(
                               div(class = "d-flex align-items-center",
                                   bs_icon("graph-up-arrow", size = "1.5rem", class = "me-2"),
                                   span("Correlación Bivariada", style = "font-weight: 700; font-size: 1.25rem;")
                               ),
                               # Usamos un color Índigo/Púrpura Profundo para análisis de variables
                               style = "background-color: #4F46E5; color: white; border: none; padding: 15px;"
                             ),
                             
                             card_body(
                               style = "padding: 20px; background-color: white;",
                               
                               # Texto superior: Pregunta gancho
                               div(style = "min-height: 90px; text-align: center;",
                                   p("¿Cómo se relacionan dos contaminantes entre sí?", 
                                     style = "font-size: 1.1rem; color: #4338CA; font-weight: 700; margin-bottom: 8px; line-height: 1.2;"),
                                   p("Explora la dependencia estadística mediante diagramas de dispersión y detecta patrones de emisión simultánea.", 
                                     style = "font-size: 0.95rem; color: #7f8c8d; font-weight: 400;")
                               ),
                               
                               # Contenedor de Imagen con marco púrpura muy tenue
                               div(class = "text-center my-3",
                                   style = "border-radius: 10px; padding: 10px; border: 1px solid #EDE9FE;",
                                   tags$img(
                                     src = "CorrelacionBivariada.png", 
                                     style = "width: 100%; max-height: 180px; object-fit: contain; filter: drop-shadow(0 2px 4px rgba(0,0,0,0.08));"
                                   )
                               )
                             ),
                             
                             card_footer(
                               style = "background: white; border-top: 1px solid #f1f1f1; padding: 15px;",
                               # Botón sólido unificado
                               actionButton(
                                 "ir_scatter", 
                                 "Analizar Dispersión", 
                                 icon = bs_icon("activity"),
                                 style = "background-color: #4F46E5; color: white; border: none; width: 100%; font-weight: 700; padding: 12px; border-radius: 8px;",
                                 class = "btn-hover-effect"
                               )
                             )
                           )
                           
                         ),
                         br(),
                         
                         # --- BOTÓN DE ENTRADA ---
                         div(class = "text-center my-5",
                             actionButton("volver_teoria2", "Ver teoria", 
                                          class = "btn-success btn-lg", 
                                          style = "padding: 20px 80px; font-weight: 800; border-radius: 10px; font-size: 1.5rem; transition: 0.3s;",
                                          icon = icon("book-open"))
                         )
                     )
    ),
    
    # 1. REFERENCIA A TUS UI EXTERNAS
    # Estos IDs deben coincidir con los que usas en nav_select en el server
    nav_panel_hidden("pagina_analisis", ui_time_variation),
    nav_panel_hidden("pagina_rosa", ui_rose_pollution),
    nav_panel_hidden("pagina_cor", ui_corplot),
    nav_panel_hidden("pagina_gif", ui_gif_maker),
    nav_panel_hidden("pagina_scatter", ui_scatter)
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
                p(strong("Desarrollado por:"), " Andres Franco - Natalia Lopez", style = "margin-bottom: 5px;"),
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
  
  observeEvent(input$empezar_app,{nav_select("paginas_app","inicio")
    session$sendCustomMessage("scroll-top", list())})
  observeEvent(input$empezar_app2,{nav_select("paginas_app","inicio")
    session$sendCustomMessage("scroll-top", list())})
  
  
  
  # El ID "paginas_app" es el del navset_hidden. 
  # El segundo argumento es el valor del nav_panel_hidden definido arriba.
  observeEvent(input$ir_analisis,{nav_select("paginas_app","pagina_analisis")})
  
  observeEvent(input$ir_analisis, { nav_select("paginas_app", "pagina_analisis") })
  observeEvent(input$ir_rosa, { nav_select("paginas_app", "pagina_rosa") })
  observeEvent(input$ir_cor, { nav_select("paginas_app", "pagina_cor") })
  observeEvent(input$ir_gif, { nav_select("paginas_app", "pagina_gif") })
  observeEvent(input$ir_scatter,{nav_select("paginas_app", "pagina_scatter")})
  
  
  # Lógica para botones de "Volver" 
  observeEvent(input$volver_teoria,{nav_select("paginas_app","teoria")})
  observeEvent(input$volver_teoria2,{nav_select("paginas_app","teoria")})
  
  observeEvent(input$volver_inicio, { nav_select("paginas_app", "inicio") })
  observeEvent(input$volver_inicio2, { nav_select("paginas_app", "inicio") })
  observeEvent(input$volver_inicio3, { nav_select("paginas_app", "inicio") })
  observeEvent(input$volver_inicio4, { nav_select("paginas_app", "inicio") })
  observeEvent(input$volver_inicio5, { nav_select("paginas_app", "inicio") })
  
  #INICIADORES
  observe({
    req(rmcab_aqs)
    #ESTACIONES
    updateSelectInput(session, "station", choices = rmcab_aqs$aqs)
    updateSelectInput(session, "station_rose", choices = rmcab_aqs$aqs)
    updateSelectInput(session, "station_corplot", choices = rmcab_aqs$aqs)
    updateSelectInput(session, "station_scatter", choices = rmcab_aqs$aqs)
    #CONTAMINANTES
    lista_contaminantes <- c("pm10", "pm2.5", "co", "no", "no2", "nox", "so2", "ozono")
    updateSelectInput(session, "pollutant", choices = lista_contaminantes)
    updateSelectInput(session, "pollutant_rose", choices = lista_contaminantes)
    updateSelectInput(session, "pollutant_gif", choices = lista_contaminantes)
    updateSelectInput(session, "Pollutant_x", choices = lista_contaminantes)
    updateSelectInput(session, "Pollutant_y", choices = lista_contaminantes)
  })
  
  
  
  #--- MAPA BOGOTÁ CON LAS 10 ESTACIONES -----
  
  output$mapa_bogota <- renderLeaflet({
    #Icono estacion
    icono_estacion <- makeIcon(
      iconUrl = "broadcasting.png",
      iconWidth = 20, iconHeight = 20,
      iconAnchorX = 17, iconAnchorY = 35
    )
    
    leaflet(estaciones_bog) %>%
      addProviderTiles(providers$CartoDB.Positron) %>%
      setView(lng = -74.10, lat = 4.65, zoom =10.5) %>%
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

#Variables IA
v_res_tv_objeto <- reactiveVal(NULL) #Guarda el objeto de openar
texto_analisis_ia <- reactiveVal("") #Guarda la respuesta
esta_analizando_ia <- reactiveVal(FALSE) #Estado de carga de la ia


#Control Dinamico Boton
output$control_time_ui <- renderUI({
  if(esta_cargando_time()){
    div(
      style= "padding:10px; background: #E8F5E9; border-radius: 8px; border: 1px solid #C8E6C9;",
      p("Descargando datos de la RMCAB...", style="font-weight:bold; color: #2e7d32; margin_bottom: 5px"),
      textOutput("mensaje_carga_time")
    )
  }else{
    actionButton("generar_time", "Generar Gráfica",
    icon=icon("chart-line"),
    class="btn-primary",style="width: 100%;font-weight:700;")
  }
})
#Logica descarga al presionar boton
observeEvent(input$generar_time,{
  req(input$dates, input$station)
  
  texto_analisis_ia("")
  v_res_tv_objeto(NULL)
  esta_cargando_time(TRUE)
  
  #Limpiar analisis previo al generar nueva grafica
  texto_analisis_ia("")
  
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
    if(inherits(resultado, "try-error") || is.null(resultado) || nrow(resultado)==0){
      message("Error o datos vacíos en:", input$station)
      
      # Notificación visual para el usuario 
      showNotification(
        "La estación seleccionada no reporta datos en este periodo. Por favor, intenta con otra estación o rango de fechas.",
        type = "warning",
        duration = 10
      )
      datos_time_historicos(NULL) 
    }else{
      datos_time_historicos(resultado)
    }
  })
  esta_cargando_time(FALSE)
})
#Renderizar la grafica
output$time_variation_plot<-renderPlot({
  input$generar_time
  
  df<-datos_time_historicos()
  if(is.null(df)){
    return(NULL)
  }
  
  p_sel <- (input$pollutant)
  s_sel <- (input$station)
  
  shiny::validate(
    shiny::need(!is.null(df), "Por favor, selecciona una estación y haz clic en 'Generar Gráfica'"),
    shiny::need(is.data.frame(df), "Hubo un problema técnico al procesar los datos"),
    shiny::need(nrow(df)>0,"La RMCAB no devolvió datos para esta estación en estas fechas."),
    shiny::need(input$pollutant %in% names (df), paste("La estacion", s_sel, "no mide", p_sel))
  )
  #Intentat graficas
  tryCatch({
    res<-plot_time_variation(data = df,pollutant = p_sel)
    v_res_tv_objeto(res)
    return(res)
  }, error= function(e){
    v_res_tv_objeto(NULL)
    validate("Error de graficación: No hay suficientes datos válidos para este contaminante")
  })
  
})

observeEvent(input$btn_analizar_tv, {
  req(v_res_tv_objeto()) 
  texto_analisis_ia(NULL)
  
  # Aislamos para evitar reactividad no deseada
  p_ia <- isolate(input$pollutant)
  s_ia <- isolate(input$station)
  
  texto_analisis_ia("Estableciendo conexión segura con Google...")
  
  # Preparar datos
  res_obj <- v_res_tv_objeto()
  datos_df <- as.data.frame(res_obj$data$day.hour[, c("hour", "Mean")])
  datos_json <- jsonlite::toJSON(datos_df)
  
  tryCatch({
    api_key <- Sys.getenv("GEMINI_API_KEY")
    
    # URL MODIFICADA (Usando gemini-pro que es la ruta más compatible)
    url_ia <- "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent"
    
    # Construcción manual del cuerpo para asegurar compatibilidad total
    cuerpo <- list(
      contents = list(
        list(parts = list(list(text = paste(
          "Analiza como experto en aire de Bogotá el contaminante", p_ia, 
          "en la estación", s_ia, "con estos datos:", datos_json
        ))))
      )
    )
    
    # Petición usando el método de tubería (pipeline) de httr2
    resp <- httr2::request(url_ia) %>%
      httr2::req_url_query(key = api_key) %>%
      httr2::req_body_json(cuerpo) %>%
      httr2::req_method("POST") %>%
      httr2::req_perform()
    
    # Procesar respuesta
    resultado <- httr2::resp_body_json(resp)
    
    # Extraer texto (con validación de existencia)
    if (!is.null(resultado$candidates)) {
      texto_final <- resultado$candidates[[1]]$content$parts[[1]]$text
      texto_analisis_ia(texto_final)
    } else {
      texto_analisis_ia("El servidor respondió pero no generó texto. Intenta de nuevo.")
    }
    
  }, error = function(e) {
    # Si sigue saliendo 404, el mensaje nos dirá exactamente qué URL falló
    texto_analisis_ia(paste("Error en la ruta del modelo:", e$message))
    message("Error 404 detectado. URL intentada: ", url_ia)
  })
})

output$analisis_ia_out<- renderUI({
  if(texto_analisis_ia()==""){
    p("Haz clic en 'Analizar Gráfica' para generar una interpretacion automática.",
      style = "color: #888; font-style:italic; padding:10px")
  }else{
    div(
      class="analisis-container",
      style="background-color:#f8f9fa; border-left:4px solid #0d6efd; padding:15px; border-radius:px",
      markdown(texto_analisis_ia())
    )
  }
})




#----LOGICA PAGINA: Rosa de Contaminantes----

datos_rose <- reactiveVal(NULL)
esta_cargando_rose <- reactiveVal(FALSE)

#Variables IA
v_res_rp_objeto <- reactiveVal(NULL) #Guarda el objeto de openar
texto_analisis_ia_rp <- reactiveVal("") #Guarda la respuesta
esta_analizando_ia_rp <- reactiveVal(FALSE) #Estado de carga de la ia


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
  
  datos_rose(NULL)
  texto_analisis_ia_rp("")
  v_res_rp_objeto(NULL)
  esta_cargando_rose(TRUE)
  
  
  withProgress(message = "Obteniendo datos meteorologicos...", value=0.5,{
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
    if(inherits(df, "try-error") || is.null(df) || (is.data.frame(df) && nrow(df)==0)){
      showNotification(
        paste("La estación seleccionada no reporta datos en este periodo. Por favor, intenta con otra estación o rango de fechas."),
        type = "warning",
        duration = 10
      )
      datos_rose(NULL)
    }else{
      datos_rose(df)
    }
  })
  esta_cargando_rose(FALSE)
})
#Renderizar la grafica
output$plot_rose<-renderPlot({
  input$generar_rose
  
  df<-datos_rose()
  if(is.null(df)){
    return(NULL)
  }
  
  p_sel<- (input$pollutant_rose)
  s_sel <- (input$station_rose)
  
  shiny::validate(
    shiny::need(is.data.frame(df), "Datos no válidos."),
    shiny::need(nrow(df) > 0, "La RMCAB no devolvió datos."),
    
    # Verifica que el contaminante tenga datos numéricos reales
    shiny::need(p_sel %in% names(df) && sum(!is.na(df[[p_sel]])) > 0, 
                paste("La estación", s_sel, "registra el sensor de", toupper(p_sel), 
                      "pero todos los valores en este rango de fechas son nulos (NAs).")),
    
    # Verifica que el viento tenga datos reales
    shiny::need(sum(!is.na(df$ws)) > 0 && sum(!is.na(df$wd)) > 0,
                "Existen columnas de viento pero no hay valores numéricos válidos (NAs).")
  )
  #Intentat graficas
  tryCatch({
    df_clean <- df[!is.na(df$ws) & !is.na(df$wd) & !is.na(df[[p_sel]]), ]
    res<-plot_pollution_rose(data = df,pollutant = p_sel)
    v_res_rp_objeto(res)
    return(res)
  }, error= function(e){
    v_res_rp_objeto(NULL)
    validate("Error de graficación: No hay suficientes datos válidos para este contaminante")
  })
  
})

observeEvent(input$btn_analizar_rp, {
  req(v_res_rp_objeto())
  texto_analisis_ia_rp(NULL)
  
  p_ia <- isolate(input$pollutant_rose)
  s_ia <- isolate(input$station_rose)
  
  texto_analisis_ia_rp("Estableciendo conexión segura con Google...")
  
  # --- PREPARAR DATOS REALES DE LA ROSA ---
  res_obj <- v_res_rp_objeto()
  datos_df <- as.data.frame(res_obj$data)
  
  # Columnas de intervalos de concentración (los bins de color de la rosa)
  cols_intervalos <- grep("^Interval", names(datos_df), value = TRUE)
  
  # Construir tabla resumen: dirección + frecuencia acumulada por bin
  resumen <- datos_df[, c("wd", cols_intervalos), drop = FALSE]
  resumen$direccion_grados <- resumen$wd
  resumen$frecuencia_total_pct <- rowSums(resumen[, cols_intervalos], na.rm = TRUE)
  resumen$wd <- NULL
  
  # Renombrar intervalos con contexto
  n_bins <- length(cols_intervalos)
  for (i in seq_along(cols_intervalos)) {
    names(resumen)[names(resumen) == cols_intervalos[i]] <- paste0("bin_", i, "_de_", n_bins, "_pct")
  }
  
  # Extraer los límites de los bins desde el objeto (si están disponibles en call)
  breaks_info <- tryCatch({
    as.character(res_obj$call)
  }, error = function(e) "no disponible")
  
  datos_json <- jsonlite::toJSON(
    list(
      descripcion = paste(
        "Rosa de contaminantes para", p_ia, "en estacion", s_ia,
        "- Cada fila es un sector de direccion del viento.",
        "Los bins (bin_1 al bin_N) representan categorias de concentracion de menor a mayor.",
        "El valor es el porcentaje de observaciones en esa categoria para esa direccion.",
        "frecuencia_total_pct es el porcentaje total de vientos desde esa direccion."
      ),
      datos_por_sector = resumen
    ),
    auto_unbox = TRUE,
    pretty = FALSE,
    na = "null"
  )
  
  tryCatch({
    api_key <- Sys.getenv("GEMINI_API_KEY")
    url_ia <- "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent"
    
    prompt_texto <- paste0(
      "Eres un experto en calidad del aire de Bogotá. ",
      "Analiza los datos de una Rosa de Contaminantes para '", p_ia, 
      "' en la estación '", s_ia, "'. ",
      "Cada fila representa un sector de dirección del viento. ",
      "Los bins van de concentración baja (bin_1) a alta (bin_N) y el valor es el porcentaje de observaciones. ",
      "frecuencia_total_pct indica qué tan frecuente es el viento desde esa dirección. ",
      "Por favor: ",
      "1) Identifica las direcciones con mayor concentración del contaminante. ",
      "2) Señala si hay una fuente probable según esas direcciones en el contexto urbano de Bogotá. ",
      "3) Comenta si el viento dominante coincide o no con las mayores concentraciones. ",
      "4) Da una conclusión breve sobre el riesgo para la zona. ",
      "No uses en la descripcion los terminos bin_1 o bin_N o frecuencia_total_pct. Pues el usuario no va a saber que eso, reemplazo el nombre ent erminos que
      entienda la poblacion en general. Debe ser un analisis que cualquier persona pueda entender pero mantiendo en cierto grado lo tecnico",
      "Datos JSON: ", datos_json
    )
    
    cuerpo <- list(
      contents = list(
        list(parts = list(list(text = prompt_texto)))
      )
    )
    
    resp <- httr2::request(url_ia) %>%
      httr2::req_url_query(key = api_key) %>%
      httr2::req_body_json(cuerpo) %>%
      httr2::req_method("POST") %>%
      httr2::req_perform()
    
    resultado <- httr2::resp_body_json(resp)
    
    if (!is.null(resultado$candidates)) {
      texto_final <- resultado$candidates[[1]]$content$parts[[1]]$text
      texto_analisis_ia_rp(texto_final)
    } else {
      texto_analisis_ia_rp("El servidor respondió pero no generó texto. Intenta de nuevo.")
    }
    
  }, error = function(e) {
    texto_analisis_ia_rp(paste("Error al conectar con Gemini:", e$message))
  })
})

output$analisis_ia_out_rp <- renderUI({
  texto <- texto_analisis_ia_rp()
  if (is.null(texto) || texto == "") {
    p("Haz clic en 'Analizar Rosa' para generar una interpretación automática.",
      style = "color: #888; font-style:italic; padding:10px")
  } else {
    div(
      class = "analisis-container",
      style = "background-color:#f8f9fa; border-left:4px solid #0277BD; padding:15px; border-radius:4px",
      markdown(texto)
    )
  }
})


#----LOGICA PAGINA: Correlacion de Contaminantes----

datos_corplot <- reactiveVal(NULL)
esta_cargando_corplot <- reactiveVal(FALSE)

#Variables IA
v_res_cor_objeto <- reactiveVal(NULL) #Guarda el objeto de openar
texto_analisis_ia_cor <- reactiveVal("") #Guarda la respuesta
esta_analizando_ia <- reactiveVal(FALSE) #Estado de carga de la ia

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

  datos_corplot(NULL)
  texto_analisis_ia_cor("")
  v_res_cor_objeto(NULL)
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
    if(inherits(df, "try-error") || is.null(df) || (is.data.frame(df) && nrow(df)==0)){
      showNotification(
        paste("La estación no reporta datos suficientes para la matriz de correlación en estas fechas."),
        type = "warning",
        duration = 10
      )
      datos_corplot(NULL)
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
  
  # Verificar dataframe válido
  if(!is.data.frame(df) || nrow(df) < 5){
    plot.new()
    text(0.5, 0.5,"No hay suficientes datos para calcular correlación.",cex = 1.2)
    return()
  }
  # Variables numéricas
  variables_permitidas <- c("pm10","pm2.5","no","no2","nox","so2","co","ozono","temperatura","hr") #Contaminantes + humedad + temperatura
  
  df_num <- df[, intersect(variables_permitidas, names(df)), drop = FALSE]
  
  if(ncol(df_num) < 2){
    plot.new()
    text(0.5, 0.5,"No hay suficientes variables numéricas.",cex = 1.2)
    return()
  }
  
  # Quitar columnas con pocos datos
  df_num <- df_num[, colSums(!is.na(df_num)) > 5, drop = FALSE]
  
  # Quitar columnas constantes
  df_num <- df_num[, sapply(df_num, function(x) sd(x, na.rm = TRUE) > 0), drop = FALSE]
  
  if(ncol(df_num) < 2){
    plot.new()
    text(0.5, 0.5,"Las variables no presentan variabilidad suficiente.",cex = 1.2)
    return()
  }
  
  # Calcular matriz
  
  matriz_cor <- cor(df_num, use = "pairwise.complete.obs")
  
  # Verificar matriz válida
  if(any(is.na(matriz_cor)) || ncol(matriz_cor) < 2){
    plot.new()
    text(0.5, 0.5,"No fue posible construir una matriz de correlación válida.",cex = 1.2)
    return()
  }
  
  # Graficar
  par(bg = "white", mar = c(1,1,3,1))
  
  corrplot::corrplot(matriz_cor,method = "ellipse",type = "full",order = "hclust",addCoef.col = "black",number.cex = 0.7,tl.col = "black",tl.cex = 0.9,tl.srt = 45,col = colorRampPalette(c("#83D0A4", "#FAFFB5","#A32B50" ))(200))
  
  title(main = paste("Matriz de Correlación - Estación", input$station_corplot),line = 1)
})
#Analisis IA
observeEvent(input$btn_analizar_cor, {
  req(v_res_cor_objeto()) 
  texto_analisis_ia_cor(NULL)
  
  if(is.null(v_res_cor_objeto()$data)) {
    showNotification("Error: No hay datos en la matriz para analizar.", type = "error")
    return()
  }
  
  res_obj <- v_res_cor_objeto()
  datos_df <- as.data.frame(res_obj$data)
  
  # Aislamos para evitar reactividad no deseada

  s_ia_cor <- isolate(input$station_corplot)
  
  names(datos_df)[1]<- "var1"
  names(datos_df)[2]<- "var2"
  
  if("cor" %in% names(datos_df)){
    names(datos_df)[names(datos_df) == "cor"] <- "valor"
  } else {
    names(datos_df)[3]<-"valor"
  }
  
  
  texto_analisis_ia_cor("Analizando matriz de correalciones")
  
  # Preparar datos
 datos_df <- datos_df[as.character(datos_df$var1) != as.character(datos_df$var2), ]
 datos_df$valor <- round(as.numeric(datos_df$valor), 1)
 datos_df<- datos_df[as.numeric(factor(datos_df$var1))>as.numeric(factor(datos_df$var2)), ]
 datos_json <- jsonlite::toJSON(datos_df)
  
  tryCatch({
    api_key <- Sys.getenv("GEMINI_API_KEY")
    
    # URL MODIFICADA (Usando gemini-pro que es la ruta más compatible)
    url_ia <- "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent"
    
    # Construcción manual del cuerpo para asegurar compatibilidad total
    cuerpo <- list(
      contents = list(
        list(parts = list(list(text = paste(
          "Actúa como un experto en calidad del aire de la red RMCAB de Bogotá.",
          "Analiza la siguiente matriz de correlación de contaminantes:", datos_json,"para la estacion", s_ia_cor,
          "Explica qué significan las correlaciones más fuertes (cercanas a 1 o -1)",
          "y menciona posibles fuentes comunes o reacciones químicas (como el ciclo fotoquímico NO2-O3) en el contexto de Bogotá."
        ))))
      )
    )
    
    # Petición usando el método de tubería (pipeline) de httr2
    resp <- httr2::request(url_ia) %>%
      httr2::req_url_query(key = api_key) %>%
      httr2::req_body_json(cuerpo) %>%
      httr2::req_method("POST") %>%
      httr2::req_perform()
    
    # Procesar respuesta
    resultado <- httr2::resp_body_json(resp)
    
    # Extraer texto (con validación de existencia)
    if (!is.null(resultado$candidates)) {
      texto_final <- resultado$candidates[[1]]$content$parts[[1]]$text
      texto_analisis_ia_cor(texto_final)
    } else {
      texto_analisis_ia_cor("El servidor respondió pero no generó texto. Intenta de nuevo.")
    }
    
  }, error = function(e) {
    # Si sigue saliendo 404, el mensaje nos dirá exactamente qué URL falló
    texto_analisis_ia_cor(paste("Error en la ruta del modelo:", e$message))
    message("Error 404 detectado. URL intentada: ", url_ia)
  })
})

output$analisis_ia_out_cor<- renderUI({
  if(texto_analisis_ia_cor()==""){
    p("Haz clic en 'Analizar Gráfica' para generar una interpretacion automática.",
      style = "color: #888; font-style:italic; padding:10px")
  }else{
    div(
      class="analisis-container",
      style="background-color:#f8f9fa; border-left:4px solid #0d6efd; padding:15px; border-radius:px",
      markdown(texto_analisis_ia_cor())
    )
  }
})

#------------------- PAGINA: MAPA GIF -------------------------------------------
datos_gif_path <- reactiveVal(NULL)

# Cargar datos históricos precalculados
datos_historicos_gif <- tryCatch({
  readRDS("datos/datos_gif_historicos.rds")
}, error = function(e) {
  message("Archivo histórico no encontrado")
  NULL
})

# Descargar fondo
fondo_bogota <- tryCatch({
  #si ya existe el arichivo lo lee si no lo genera
  cache_path <- "datos/fondo_bogota.rds"
  if (file.exists(cache_path)){
    readRDS(cache_path)
  } else {
    bbox_bogota <- sf::st_bbox(
      c(xmin = -74.25, ymin = 4.48, xmax = -73.95, ymax = 4.82),
      crs = sf::st_crs(4326)
    )
    tiles <- maptiles::get_tiles( x = bbox_bogota, provider = "OpenStreetMap", zoom = 11, crop= TRUE )
    
    fondo_path <- tempfile(fileext = ".png")
    ragg::agg_png(fondo_path, width = 1400, height = 1120, res = 200)
    terra::plotRGB(tiles, smooth = TRUE)
    dev.off()
    
    img <- png::readPNG(fondo_path)
    saveRDS(img, cache_path)
    img
  }
}, 
  error = function(e) {message("Error cargando calles OSM: ", e$message)
  NULL
})
# Botón dinámico
output$control_gif_ui <- renderUI({
  actionButton("generar_gif", "Generar GIF",
               icon = icon("film"),
               style="background-color:#FBC02D; color:black; font-weight:700; width:100%" )
})

observeEvent(input$generar_gif, {
  
  withProgress(message = "Construyendo mapa histórico...", value = 0, {
    
    incProgress(0.2, detail = "Leyendo datos historicos...")
    
    #validar que existan datos precalculados
    if(is.null(datos_historicos_gif) || nrow(datos_historicos_gif) == 0 ){
      showNotification("No se encontraron datos históricos. Ejecuta Scripts/descargar_historico.R primero.",
        type = "error", duration = 10)
      return()}
  
    datos_mensuales <- datos_historicos_gif %>%
      filter(!is.na(lat), !is.na(lon), !is.na(valor))
    if (nrow(datos_mensuales) == 0) {
      showNotification("No hay datos válidos para generar el mapa animado.",
        type = "warning", duration = 10)
      return() }
    
    incProgress(0.6, detail = "Creando mapa...")
    
    mapa <- ggplot() +
      
      { if (!is.null(fondo_bogota))
        annotation_raster( fondo_bogota, xmin = -74.3, xmax = -73.9, ymin = 4.45,  ymax = 4.85, interpolate = TRUE  )
        else
          annotate("rect",
                   xmin = -74.25, xmax = -73.95,
                   ymin = 4.48,   ymax = 4.82,
                   fill = "#EEE8DA", color = "#A5B8D1"
          ) } +
      
      geom_point(  data  = datos_mensuales,
        aes(x = lon, y = lat, color = valor, size = valor),
        alpha = 0.85  ) +
      scale_color_gradientn(
        colours = c("#68E045","#FFFE54","#ECBA41","#E63527","#8F3F97","#66329A"),
        values  = scales::rescale(c(0, 50, 100, 150, 200, 300, 500)),
        limits  = c(0, 500),
        oob     = scales::squish,
        guide   = "none" ) +
      scale_size_continuous(range = c(5, 20), guide = "none") +
      annotate("rect",
               xmin  = rep(-74.28, 6),
               xmax  = rep(-74.26, 6),
               ymin  = seq(4.82, 4.57, length.out = 6) - 0.012,
               ymax  = seq(4.82, 4.57, length.out = 6) + 0.012,
               fill  = c("#68E045","#FFFE54","#ECBA41","#E63527","#8F3F97","#66329A"),
               color = "gray40"  ) +
      annotate("text",
               x     = rep(-74.255, 6),
               y     = seq(4.82, 4.57, length.out = 6),
               label = c("Bajo (0-50)","Moderado (51-100)","Regular (101-150)",
                         "Alto (151-200)","Peligroso (201-300)","Muy Peligroso (>300)"),
               hjust = 0, size = 2.5, color = "gray20"  ) +
      annotate("text",
               x = -74.28, y = 4.845,
               label = "IBOCA", fontface = "bold", size = 3.5, hjust = 0  ) +
      
      labs(
        title    = "Evolución de la Calidad del Aire en Bogotá",
        subtitle = "Periodo: {closest_state}"  ) +
      
      theme_void() +
      theme(
        plot.title      = element_text(face = "bold", size = 14, hjust = 0.5),
        plot.subtitle   = element_text(size = 11, hjust = 0.5),
        legend.position = "none",
        plot.background = element_rect(fill = "white", color = NA)  ) +
      
      coord_cartesian(
        xlim = c(-74.2, -73.95),
        ylim = c(4.48,  4.82)  )
    
    incProgress(0.8, detail = "Generando animación...")
    
    animacion <- mapa +
      transition_states( periodo, transition_length = 0, state_length = 1, wrap              = TRUE ) +
      ease_aes("cubic-in-out") +
      enter_fade(alpha = 0.3) +
      exit_fade(alpha = 0.3)
    
    n_periodos <- length(unique(datos_mensuales$periodo))
    
    gif <- gganimate::animate( animacion, width= 900, heigh= 720,  res = 150,  fps = 10,  nframes = n_periodos * 3,  rewind = FALSE,  renderer = magick_renderer() )
    
    path <- tempfile(fileext = ".gif")
    magick::image_write(gif, path)
    datos_gif_path(path)
    
  })
})

output$gif_plot_output <- renderImage({
  path <- req(datos_gif_path())
  list(src = path, contentType = "image/gif", width = "100%")
}, deleteFile = FALSE)
#----LOGICA PAGINA: SCATTER -------------------

datos_scatter <- reactiveVal(NULL)
esta_cargando_scatter <- reactiveVal(FALSE)


#Variables IA scatter
v_res_scatter_objeto <- reactiveVal(NULL)
texto_analisis_ia_scatter <- reactiveVal("")
esta_analizando_ia_scatter <- reactiveVal (FALSE)
                                


# ---- Botón dinámico ----
output$control_scatter_ui <- renderUI({
  if (esta_cargando_scatter()) {
    div(
      style = "padding:10px; background: #E8F5E9; border-radius: 8px; border: 1px solid #C8E6C9;",
      p("Descargando datos de la RMCAB...",
        style = "font-weight:bold; color: #2e7d32; margin-bottom: 5px"),
      textOutput("mensaje_carga_scatter")
    )
  } else {
    actionButton(
      "generar_scatter",
      "Generar Diagrama",
      icon = icon("chart-line"),
      style = "background-color: #A7AAAB; color: white; border: none; width: 100%; font-weight:700; padding: 10px;"
    )
  }
})
# ---- Descarga al presionar botón ----
observeEvent(input$generar_scatter, {
  req(input$dates_scatter, input$station_scatter)
  esta_cargando_scatter(TRUE)
  withProgress(message = "Descargando datos de la RMCAB...", value = 0.3, {
    output$mensaje_carga_scatter <- renderText({
      paste("Procesando estación:", input$station_scatter)
    })
    df <- try({
      get_data_clean(
        aqs = input$station_scatter,
        start_date = format(input$dates_scatter[1], "%d-%m-%Y"),
        end_date   = format(input$dates_scatter[2], "%d-%m-%Y")
      )
    }, silent = TRUE)
    if (inherits(df, "try-error")) {
      datos_scatter("error_api")
    } else {
      datos_scatter(df)
    }
  })
  esta_cargando_scatter(FALSE)
})
# ---- Renderizado del diagrama ----
output$plot_scatter <- renderPlot({
  df <- datos_scatter()
  req(df,input$Pollutant_x,input$Pollutant_y)
  
  if (is.character(df)&& df=="error_api") return (NULL)
  
  
  shiny::validate(
    shiny::need(input$Pollutant_x %in% names(df), paste("La estación no mide", input$Pollutant_x)),
    shiny::need(input$Pollutant_y %in% names(df), paste("La estación no mide", input$Pollutant_y))
  )
  
  # Intentar graficar
  tryCatch({
    # Usamos el dataframe filtrado
    resultado<- plot_scatter(df,input$Pollutant_x, input$Pollutant_y)
    v_res_scatter_objeto(resultado)
    return (resultado)
    
  }, error = function(e){
    v_res_scatter_objeto(NULL)
    validate(paste("Error de graficación:", e$message))
  })
  
})

#Analisis IA
observeEvent(input$btn_analizar_scatter,{
  req(datos_scatter())
  df_completo <- datos_scatter()
  
  p_x <- isolate(input$Pollutant_x)
  p_y <- isolate(input$Pollutant_y)
  s_ia <- isolate(input$station_scatter)
  
  df_subset<- df_completo[, c(p_x,p_y), drop=FALSE]
  df_subset <- na.omit(df_subset)
  
  #Validamos que hayan datos
  if(nrow(df_subset)<5){
    texto_analisis_ia_scatter("No hay suficientes datos válidos para calcular la relación entre estos contaminantes")
    return()
  }
  texto_analisis_ia_scatter("Analizando correlacion y tendencias ...")
  
  datos_json<- jsonlite::toJSON(df_subset)
  
  tryCatch({
    api_key <- Sys.getenv("GEMINI_API_KEY")
    url_ia <- "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent"
    
    cuerpo <- list(
      contents = list(
        list(parts=list(list(text=paste(
          "Eres un Especialista en Calidad del Aire y Análisis Estadístico de la Red de Monitoreo (RMCAB) en Bogotá. ",
          "Tu objetivo es interpretar un Diagrama de Dispersión (Scatter Plot) generado para la estación '", s_ia, "'.\n\n",
          
          "VARIABLES DEL GRÁFICO:\n",
          "- Eje X (Variable Independiente): ", p_x, "\n",
          "- Eje Y (Variable Dependiente): ", p_y, "\n\n",
          
          "DATOS DEL SCATTER PLOT (JSON):\n", datos_json, "\n\n",
          
          "TAREAS DE ANÁLISIS:\n",
          "1. CORRELACIÓN: Determina la fuerza y dirección de la relación (positiva, negativa, nula). ¿Es una relación lineal o existen clusters (agrupamientos)?\n",
          "2. FENOMENOLOGÍA: Explica si estos dos contaminantes comparten una fuente de emisión común en Bogotá (ej. tráfico vehicular si es NO2/PM2.5, o resuspensión si es PM10). ",
          "Considera si uno es un contaminante primario y el otro secundario.\n",
          "3. VALORES ATÍPICOS: Identifica si hay puntos que se alejan significativamente de la tendencia y qué podrían indicar.\n",
          "4. CONCLUSIÓN TÉCNICA: Resume el estado de la calidad del aire para este par de variables en 3 puntos clave.\n\n",
          
          "REGLAS DE FORMATO: Usa Markdown, negritas para términos técnicos y un tono profesional y científico, sin embargo, que una persona sin muchos conocimientos texnicos pueda entender."
        ))))
      )
    )
    resp <- httr2::request(url_ia) %>%
      httr2::req_url_query(key=api_key) %>%
      httr2::req_body_json(cuerpo) %>%
      httr2::req_method("POST") %>%
      httr2::req_perform()
    
    resultado <- httr2::resp_body_json(resp)
    if(!is.null(resultado$candidates)){
      texto_final <- resultado$candidates[[1]]$content$parts[[1]]$text
      texto_analisis_ia_scatter(texto_final)
    } else{
      texto_analisis_ia_scatter("La IA no pudo generar uan respuesta. Intenta de nuevo")
    }
    
  }, error= function(e){
      texto_analisis_ia_scatter(paste("Error en la conexión", e$message))
    
  })
  
  })
output$analisis_ia_scatter_out <- renderUI({
  if(texto_analisis_ia_scatter() == ""){
    p("Haz clic en 'Analizar Relación' para obtener una interpretación experta",
      style="color:#888; font-style:italic; padding:10px")
  } else{
    div(
      class="analisis_container",
      style="background-color:#f0f7ff; border-left:4px solid #2E8B57; padding:15px; border-radius:4px",
      markdown(texto_analisis_ia_scatter())
    )
  }
  
})




}

shinyApp(ui, server)
  
