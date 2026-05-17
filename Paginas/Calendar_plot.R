# calendar_plot.R
library(shinycssloaders)
library(bsicons)

ui_calendar_plot <- nav_panel_hidden(
  "pagina_calendar_plot", style = "margin-top:50px;",
  layout_sidebar(
    sidebar = sidebar(
      title = span(bs_icon("calendar3"), " Calendar Plot"),
      bg = "#F7F9F7",
      
      selectInput("anio_cal", "Año:",
                  choices = c("2026", "2025", "2024", "2023", "2022", "2021",
                              "2020", "2019", "2018", "2017", "2016"),
                  selected = "2026"),
      
      selectInput("station_cal", "Estación de Monitoreo:", choices = NULL),
      selectInput("pollutant_cal", "Contaminante:", choices = NULL),
      
      hr(style = "border-top: 1px solid #C8E6C9;"),
      
      div(class = "text-center mb-3",
          uiOutput("control_cal_ui")),
      
      hr(style = "border-top: 1px solid #C8E6C9;"),
      div(
        style = "background-color: white; border-radius: 12px; padding: 15px; border: 1px solid #E0F2FE; box-shadow: 0 2px 4px rgba(0,0,0,0.05);",
        h6(style = "color: #0369A1; font-weight: 700; display: flex; align-items: center; gap: 8px;",
           bs_icon("info-circle"), "¿Cómo leer esta gráfica?"),
        p(style = "font-size: 0.85rem; color: #475569; margin-bottom: 8px;",
          "Cada panel representa un mes del año seleccionado. Dentro de cada panel, cada cuadro corresponde a un día:"),
        tags$ul(
          style = "font-size: 0.8rem; color: #64748b; padding-left: 1.2rem; margin-bottom: 0;",
          tags$li(tags$b("Número:"), " El número en cada cuadro indica la ", tags$b("fecha"), " del día dentro del mes."),
          tags$li(tags$b("Color intenso:"), " Colores ", span("rojos y oscuros", style = "color:#e11d48; font-weight:bold;"), " indican concentraciones altas del contaminante."),
          tags$li(tags$b("Color claro:"), " Colores ", span("amarillos y crema", style = "color:#ca8a04; font-weight:bold;"), " indican concentraciones bajas."),
          tags$li(tags$b("Cuadros sin color:"), " Días sin datos disponibles en la estación.")
        )
      ),
      hr(style = "border-top: 1px solid #C8E6C9;"),
      actionButton(
        "volver_inicio7",
        "Volver al Menú",
        icon = bs_icon("arrow-left-circle"),
        style = "background-color: transparent; color: #455A64; border: 1px solid #CFD8DC; width: 100%; font-weight: 500; border-radius: 6px;"
      )
      
    ),
    
    card(
      full_screen = TRUE,
      card_header(
        div(class = "d-flex justify-content-between align-items-center",
            span(bs_icon("calendar3"), " Distribución Diaria de Contaminantes"),
            span(class = "badge",
                 style = "background-color: #0D9488; color: white; font-size: 0.75rem; padding: 5px 10px; border-radius: 20px; font-weight: 600; letter-spacing: 0.5px;",
                 "Calendar Plot"))
      ),
      card_body(
        withSpinner(
          plotOutput("calendar_plot", height = "580px"),
          color = "#BED7F9",
          type = 7
        ),
        hr(),
      ),
      style = "border-radius: 12px; border: 1px solid #BED7F9;"
    )
  ),
  
  tags$style(HTML("
    #volver_inicio7:hover {
      transform: translateY(-5px);
      box-shadow: 0 15px 30px rgba(69, 90, 100, 0.4) !important;
      filter: brightness(1.1);
    }
    #generar_cal:hover {
  transform: translateY(-5px);
  box-shadow: 0 15px 30px rgba(13, 148, 136, 0.4) !important;
  filter: brightness(1.1);
}
  "))
)