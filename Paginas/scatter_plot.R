# Scatter_plot.R
library(shinycssloaders)
library(bsicons)

ui_scatter <- nav_panel_hidden(
  "pagina_scatter",style="margin-top:50px;",
  layout_sidebar(
    sidebar = sidebar(
      title = span(bs_icon("graph-up-arrow"), " Correlación Bivariada"),
      bg = "#F5F3FF", # Fondo lila muy tenue para la sidebar
      
      dateRangeInput("dates_scatter", "Rango de fechas",
                     start = Sys.Date() - 7, end = Sys.Date(),
                     language = "es"),
      hr(style = "border-top: 1px solid #DDD6FE;"),
      
      selectInput("station_scatter", "Estación:", choices = NULL),
      selectInput("Pollutant_x", "Contaminante eje X:", choices = NULL),
      selectInput("Pollutant_y", "Contaminante eje Y:", choices = NULL),
      
      hr(style = "border-top: 1px solid #DDD6FE;"),
      
      # Botón Generar (Asegúrate de ponerle #4F46E5 en el server)
      div(class="text-center mb-3",
          uiOutput("control_scatter_ui")),
      
      # Botón para el análisis IA (Morado/Índigo Unificado)
      actionButton(
        "btn_analizar_scatter", 
        "Analizar Gráfica",
        icon = bs_icon("robot"),
        class = "w-100",
        style = "background-color: #4F46E5; color: white; border: none; font-weight: 700; padding: 12px; border-radius: 8px; box-shadow: 0 4px 6px rgba(79, 70, 229, 0.2);"
      ),
      
      hr(style = "border-top: 1px solid #DDD6FE;"),
      div(
        style = "background-color: white; border-radius: 12px; padding: 15px; border: 1px solid #EDE9FE; box-shadow: 0 2px 4px rgba(0,0,0,0.05);",
        h6(style = "color: #4338CA; font-weight: 700; display: flex; align-items: center; gap: 8px;",
           bs_icon("patch-question"), "¿Cómo leer la grafica 'Análisis de Dispersión Atmosférica'?"),
        
        p(style = "font-size: 0.85rem; color: #475569; margin-bottom: 8px;",
          "Este diagrama muestra la relación entre dos contaminantes seleccionados:"),
        
        tags$ul(
          style = "font-size: 0.8rem; color: #64748b; padding-left: 1.2rem; margin-bottom: 0;",
          tags$li(tags$b("Cada punto:"), " Representa una medición en un momento específico. Entre más puntos, más datos disponibles."),
          tags$li(tags$b("Tendencia:"), " Si los puntos forman una línea hacia arriba, los dos contaminantes suben juntos (correlación positiva). Si la línea va hacia abajo, cuando uno sube el otro baja (correlación negativa)."),
          tags$li(tags$b("Dispersión:"), " Si los puntos están muy dispersos sin forma clara, los dos contaminantes no tienen una relación directa."),
          tags$li(tags$b("Agrupaciones:"), " Grupos de puntos separados pueden indicar diferentes condiciones atmosféricas o fuentes de emisión.")
        )
      ),
      hr(style = "border-top: 1px solid #DDD6FE;"),
      div(
        style = "background-color: white; border-radius: 12px; padding: 15px; border: 1px solid #E0F2FE; box-shadow: 0 2px 4px rgba(0,0,0,0.05);",
        h6(style = "color: #0369A1; font-weight: 700; display: flex; align-items: center; gap: 8px;",
           bs_icon("patch-question"), "¿Cómo leer la 'Matriz de Correlación de Pearson' ?"),
        
        p(style = "font-size: 0.85rem; color: #475569; margin-bottom: 8px;",
          "Esta matriz muestra qué tan relacionados están todos los contaminantes entre sí al mismo tiempo:"),
        
        tags$ul(
          style = "font-size: 0.8rem; color: #64748b; padding-left: 1.2rem; margin-bottom: 0;",
          tags$li(tags$b("Número:"), " El valor entre -1 y 1 indica la fuerza de la relación. Cercano a ", 
                  tags$b("1"), " significa que suben juntos, cercano a ", tags$b("-1"), " que cuando uno sube el otro baja, y cercano a ", tags$b("0"), " que no hay relación."),
          tags$li(tags$b("Color:"), " Colores ", span("verdes", style = "color:#83D0A4; font-weight:bold;"), 
                  " indican correlación negativa y colores ", span("rojos", style = "color:#A32B50; font-weight:bold;"), " correlación positiva."),
          tags$li(tags$b("Elipse:"), " Una elipse muy alargada indica una correlación fuerte. Una elipse casi circular indica poca o ninguna relación."),
          tags$li(tags$b("Diagonal:"), " La diagonal siempre muestra correlación perfecta (1.0) porque es cada variable consigo misma.")
        )
      ),
      hr(style = "border-top: 1px solid #DDD6FE;"),
      # Botón volver
      actionButton(
        "volver_inicio5", "Volver al menú",
        icon = bs_icon("arrow-left-short"),
        style = "background-color: transparent; color: #4F46E5; border: 1px solid #DDD6FE; width: 100%; margin-top: 10px; font-weight: 500;"
      )
    ),
    
    # Área Principal
    card(
      full_screen = TRUE,
      card_header(
        div(class="d-flex justify-content-between align-items-center",
            span(bs_icon("diagram-3"), " Análisis de Dispersión Atmosférica"),
            # Badge en color morado
            span(class="badge", style="background-color: #EDE9FE; color: #4338CA;", "Relación Bivariada"))
      ),
      card_body(
        # Spinner en color índigo
        withSpinner(plotOutput("plot_scatter", height = "550px"), color = "#4F46E5"),
        hr(),
        
        # Sección de IA con Acordeón estilizado
        accordion(
          open = TRUE,
          accordion_panel(
            "Interpretación Experta (IA)",
            icon = bs_icon("stars"), 
            div(
            withSpinner(
              uiOutput("analisis_ia_scatter_out"),
              type = 4,
              color = "#4F46E5",
              size = 0.7
            )
            )
          )
        )
      ),
      style = "border-radius: 15px; border: 1px solid #EDE9FE;"
    ),
    card(
      full_screen = TRUE,
      card_header(
        div(class="d-flex justify-content-between align-items-center",
            span(bs_icon("table"), " Matriz de Correlación de Pearson"),
            span(class="badge rounded-pill", style="background-color: #e8f0fe; color: #1a73e8;", "Multivariado"))
      ),
      card_body(
        withSpinner(
          plotOutput("plot_corplot_scatter", height = "580px"),
          color = "#0369A1",
          type = 5
        ),
        hr(),
        
        # Acordeón de Análisis IA con estilo moderno
        accordion(
          open = TRUE,
          accordion_panel(
            "Interpretación Científica de la Matriz",
            icon = bs_icon("stars"), # Icono de 'brillo/IA'
            div(
              withSpinner(
                uiOutput("analisis_ia_out_cor"),
                type = 4,
                color = "#0369A1",
                size = 0.7
              )
            )
          )
        )
      ),
      style = "border-radius: 12px; border: 1px solid #e0e0e0; box-shadow: 0 4px 12px rgba(0,0,0,0.03);"
    )
  ),
  # CSS adicional para efectos de 'Hover'
  tags$style(HTML("
   #btn_analizar_scatter:hover {
      transform: translateY(-5px);
      box-shadow: 0 15px 30px rgba(79, 70, 229, 0.4) !important;
      filter: brightness(1.1);
   }
   #volver_inicio5:hover {
      transform: translateY(-5px);
      box-shadow: 0 15px 30px rgba(79, 70, 229, 0.4) !important;
      filter: brightness(1.1);
   }
  #generar_scatter:hover {
      transform: translateY(-5px);
      box-shadow: 0 15px 30px rgba(79, 70, 229, 0.4) !important;
      filter: brightness(1.1);
   }"
  )),
)