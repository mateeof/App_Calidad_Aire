# rose_pollution.R
ui_rose_pollution <- nav_panel_hidden(
  "pagina_rosa", # ID de esta página
  layout_sidebar(
    sidebar = sidebar(
      title = "Rosa de Contaminantes",
      bg = "#E1F5FE", 
      dateRangeInput("dates_rose", "Rango de fechas:", 
                     start = Sys.Date() - 7, end = Sys.Date()),
      selectInput("station_rose", "Estación:", choices = NULL),
      selectInput("pollutant_rose", "Contaminante:", choices = NULL),
      hr(),
      div(class="text-center mb-3",
          uiOutput("control_rose_ui")),
      hr(),
      actionButton("volver_inicio2", "Volver al Menú", icon = bs_icon("arrow-left"),
                   style = "background-color: #E1F5FE; color: #01579B; border: 1px solid #81D4FA; width: 100%; margin-top: 10px; font-weight: 600;")
    ),
    card(
      card_header("Rosa de Vientos y Contaminación"),
      plotOutput("plot_rose", height = "600px") # ID ÚNICO AQUÍ
    )
  )
)