# time_variation.R
library(shinycssloaders)
library(bsicons)

ui_time_variation <- nav_panel_hidden(
  "pagina_time_variation",style="margin-top:50px;",
  layout_sidebar(
    sidebar = sidebar(
      title = span(bs_icon("clock-history"), " Análisis Temporal"),
      bg = "#F7F9F7", # Un verde/grisáceo casi imperceptible
      
      selectInput("anio", "Año:", 
                  choices = as.character(seq(format(Sys.Date(), "%Y"), 2016, by = -1)),
                  selected = format(Sys.Date(), "%Y")),
      
      selectInput("station", "Estación de Monitoreo:", choices = NULL),
      selectInput("pollutant", "Contaminante:", choices = NULL),
      
      hr(style = "border-top: 1px solid #C8E6C9;"),
      
      # Botón de Generar (Dinamizado por Server - Sugerencia: usar verde #2E8B57)
      div(class="text-center mb-3",
          uiOutput("control_time_ui")),
      
      # Botón de Análisis IA (Azul Tecnológico Unificado)
      actionButton(
        "btn_analizar_tv", 
        "Interpretación IA",
        icon = bs_icon("cpu-fill"), 
        class = "w-100",
        style = "background-color: #1A73E8; color: white; border: none; font-weight: 700; padding: 12px; border-radius: 8px; box-shadow: 0 4px 6px rgba(26, 115, 232, 0.2);"
      ),
      
      hr(style = "border-top: 1px solid #C8E6C9;"),
      
      # Botón Volver (Estilo minimalista)
      actionButton(
        "volver_inicio", 
        "Volver al Menú", 
        icon = bs_icon("arrow-left-circle"),
        style = "background-color: transparent; color: #455A64; border: 1px solid #CFD8DC; width: 100%; font-weight: 500; border-radius: 6px;"
      ),
      div(
        style = "background-color: white; border-radius: 12px; padding: 15px; border: 1px solid #E0F2FE; box-shadow: 0 2px 4px rgba(0,0,0,0.05);",
        h6(style = "color: #0369A1; font-weight: 700; display: flex; align-items: center; gap: 8px;",
           bs_icon("info-circle"), "¿Cómo leer esta gráfica?"),
        
        p(style = "font-size: 0.85rem; color: #475569; margin-bottom: 8px;",
          "Esta gráfica resume el comportamiento típico del contaminante analizando tres dimensiones temporales:"),
        
        tags$ul(
          style = "font-size: 0.8rem; color: #64748b; padding-left: 1.2rem; margin-bottom: 8px;",
          tags$li(tags$b("Por hora:"), " variación a lo largo del día."),
          tags$li(tags$b("Por día:"), " variación a lo largo de la semana."),
          tags$li(tags$b("Por mes:"), " variación a lo largo del año.")
        ),
        
        p(style = "font-size: 0.8rem; color: #475569; margin-bottom: 0;",
          "Los valores que ves no son de un solo día, sino el resultado de promediar muchos días juntos para encontrar el comportamiento típico del contaminante. La ",
          tags$b("línea del centro"), " muestra ese promedio, y las ",
          tags$b("bandas sombreadas"), " que la rodean nos dicen qué tan seguros estamos de ese valor: si las bandas son delgadas, significa que casi siempre pasa lo mismo; si son anchas, significa que hay días muy diferentes entre sí.")
      )
    ),
    
    # Área Principal
    card(
      full_screen = TRUE,
      card_header(
        div(class="d-flex justify-content-between align-items-center",
            span(bs_icon("calendar3"), " Comportamiento de Contaminantes en el Tiempo"),
            span(class="badge", style="background-color: #BED7F9; color: #8c96a3;", "Tendencias Históricas"))
      ),
      card_body(
        withSpinner(
          plotOutput("time_variation_plot", height = "580px"),
          color = "#BED7F9", # Verde para la carga de datos ambientales
          type = 7
        ),
        hr(),
        h6(style = "color: #0369A1; font-weight: 700; padding: 10px 0;",
           bs_icon("graph-up"), " PM10 y PM2.5"),
        withSpinner(
          plotOutput("time_variation_pm", height = "580px"),
          color = "#BED7F9", type = 7
        ),
        
        hr(),
        h6(style = "color: #0369A1; font-weight: 700; padding: 10px 0;",
           bs_icon("graph-up"), " O3 y NO2"),
        withSpinner(
          plotOutput("time_variation_o3no2", height = "580px"),
          color = "#BED7F9", type = 7
        ),
        
        hr(),
        
        # Análisis de la IA con Acordeón
        accordion(
          open = TRUE,
          accordion_panel(
            "Análisis de Ciclos y Patrones",
            icon = bs_icon("graph-up-arrow"),
            div(
            withSpinner(
              uiOutput("analisis_ia_out"),
              type = 4,
              color = "#1A73E8", # Azul para la carga de IA
              size = 0.7,
            )
            )
          )
        )
      ),
      style = "border-radius: 12px; border: 1px solid #BED7F9;"
    )
    
  ),
  # CSS adicional para efectos de 'Hover'
  tags$style(HTML("
   #btn_analizar_tv:hover {
      transform: translateY(-5px);
      box-shadow: 0 15px 30px rgba(26, 115, 232, 0.4) !important;
      filter: brightness(1.1);
   }
   #volver_inicio:hover {
      transform: translateY(-5px);
      box-shadow: 0 15px 30px rgba(69, 90, 100, 0.4) !important;
      filter: brightness(1.1);
   }
  #generar_time:hover {
      transform: translateY(-5px);
      box-shadow: 0 15px 30px rgba(69, 90, 100, 0.4) !important;
      filter: brightness(1.1);
   }"
                  )),
)