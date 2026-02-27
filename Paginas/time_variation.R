# time_variation.R

ui_time_variation <- nav_panel_hidden(
  "pagina_analisis", # Este es el ID al que saltará el botón
  layout_sidebar(
    sidebar = sidebar(
      title = "Parámetros de Consulta",
      bg = "#F1F8E9",
      dateRangeInput("dates", "Rango de fechas:", 
                     start = Sys.Date() - 7, end = Sys.Date()),
      selectInput("station", "Estación:", 
                  choices = NULL),
      selectInput("pollutant", "Contaminante:", 
                  choices = NULL),
      hr(),
      div(class="text-center mb-3",
          uiOutput("control_rose_ui")),
      
      hr(),
      actionButton("volver_inicio", "Volver al Menú", 
                   icon = bs_icon("arrow-left"))
    ),
    card(
      card_header("Resultado del Análisis Temporal"),
      card_body(
        plotOutput("time_variation_plot", height = "600px")
      )
    )
  )
)