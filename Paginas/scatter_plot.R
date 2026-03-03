# Scatter_plot.R
ui_scatter <- nav_panel_hidden(
  "pagina_scatter", # ID de esta pagina
  layout_sidebar(
    sidebar = sidebar(
      title = "Correlación Bivariada",
      bg ="#f5f5f5",
      
      dateRangeInput("dates_scatter",
                     "Rango de fechas",
                     start = Sys.Date() - 7,
                     end=Sys.Date()),
      hr(),
      
      selectInput("Pollutant_x",
                  "Contaminante eje X:",
                  choices= NULL),
      
      selectInput("Pollutant_y",
                  "Contaminante eje Y:",
                  choices= NULL),
      selectInput("station_scatter",
                  "Estación:",
                  choices = NULL),
      hr(),
      div(class="text-center mb-3",
          uiOutput("control_scatter_ui")),
      hr(),
      #Boton para el analisis
      actionButton("btn_analizar_tv", "Analizar Gráfica",
                   icon=bs_icon("robot"),
                   class="btn-success w-100"),
      hr(),
      #boton para volver al inicio
      actionButton("volver_inicio5",
                   "Volver al menú",
                   icon = bs_icon("arrow-left"),
                  style= "background-color:#476152;
                  bt-success;
                  border: 1px solid #CFD8DC;
                  width: 100%;
                  margin-top: 10px;")
      
    ),
    card(
      card_header("Diagrama de Dispersión"),
      plotOutput("plot_scatter",height="600px")
    )
  )
)

