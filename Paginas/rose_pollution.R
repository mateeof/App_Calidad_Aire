# rose_pollution.R
library(shinycssloaders)
library(bsicons)

ui_rose_pollution <- nav_panel_hidden(
  "pagina_rosa",style="margin-top:50px;",
  layout_sidebar(
    sidebar = sidebar(
      title = span(bs_icon("compass"), " Análisis de Vientos"),
      # Un azul muy suave para la sidebar que combina con el tema meteorológico
      bg = "#F0F9FF", 
      
      selectInput("year_rose", "Año:", 
                     choices = rev(2018:2026),
                    selected = as.integer(format(Sys.Date(),"%Y"))),
      selectInput("station_rose", "Estación:", choices = NULL),
      selectInput("pollutant_rose", "Contaminante:", choices = NULL),
      
      hr(style = "border-top: 1px solid #BAE6FD;"),
      
      # Botón de Generar (Asegúrate de ponerle un azul medio en el server)
      div(class="text-center mb-3",
          uiOutput("control_rose_ui")),
      
      # Botón de Análisis IA (Azul Profundo Tecnológico)
      actionButton(
        "btn_analizar_rp", 
        "Interpretar Rosa",
        icon = bs_icon("magic"), 
        class = "w-100",
        style = "background-color: #0369A1; color: white; border: none; font-weight: 700; padding: 12px; border-radius: 8px; box-shadow: 0 4px 6px rgba(3, 105, 161, 0.2);"
      ),
      
      hr(style = "border-top: 1px solid #BAE6FD;"),
      
      div(
        style = "background-color: white; border-radius: 12px; padding: 15px; border: 1px solid #E0F2FE; box-shadow: 0 2px 4px rgba(0,0,0,0.05);",
        h6(style = "color: #0369A1; font-weight: 700; display: flex; align-items: center; gap: 8px;",
           bs_icon("patch-question"), "¿Cómo leer la rosa?"),
        
        p(style = "font-size: 0.85rem; color: #475569; margin-bottom: 8px;", 
          "Esta gráfica muestra de dónde viene el aire contaminado:"),
        
        tags$ul(
          style = "font-size: 0.8rem; color: #64748b; padding-left: 1.2rem; margin-bottom: 0;",
          tags$li(tags$b("Dirección:"), " Los 'pétalos' apuntan hacia la fuente (de dónde viene el viento)."),
          tags$li(tags$b("Frecuencia:"), " Entre más largo el pétalo, más tiempo sopló el viento desde ahí."),
          tags$li(tags$b("Color:"), " Colores ", span("naranjas y rojos", style="color:#e11d48; font-weight:bold;"), " indican niveles altos de contaminación.")
        )
      ),
      hr(style="border-top:1px solid #BAE6FD;"),
      # Botón Volver con estilo "Ghost"
      actionButton(
        "volver_inicio2", 
        "Volver al Menú", 
        icon = bs_icon("arrow-left-short"),
        style = "background-color: transparent; color: #0369A1; border: 1px solid #BAE6FD; width: 100%; font-weight: 600; border-radius: 6px;"
      ),
    ),
    
    # Área Principal
    card(
      card_header(
        div(class="d-flex justify-content-between align-items-center",
            span(bs_icon("wind"), " Rosa de Contaminación Atmosférica - 4 Trimestres"),
            span(class="badge", style="background-color: #E0F2FE; color: #0369A1;", 
                 textOutput("badge_year_rose", inline = TRUE)))
      ),
      card_body(
        #Grid 2x2 de rosas
        fluidRow(
          column(6,
                 div(style="text-align:center; font-weight:700; color: #0369A1; margin-bottom:5px",
                     "Q1 - Enero a Marzo"),
                 withSpinner(plotOutput("plot_rose_q1", height ="320px"), color="#0369A1", type=6)),
          column(6,
                 div(style="text-align:center; font-weight:700; color:#0369A1; margin-bottom:5px",
                     "Q2 - Abril a Junio"),
                 withSpinner(plotOutput("plot_rose_q2", height ="320px"), color="#0369A1", type=6))
        ),
        fluidRow(
          column(6,
                 div(style="text-align:center; font-weight:700; color: #0369A1; margin-bottom:5px",
                     "Q3 - Julio a Septiembre"),
                 withSpinner(plotOutput("plot_rose_q3", height ="320px"), color="#0369A1", type=6)),
          column(6,
                 div(style="text-align:center; font-weight:700; color:#0369A1; margin-bottom:5px",
                     "Q4 - Octubre a Diciembre"),
                 withSpinner(plotOutput("plot_rose_q4", height ="320px"), color="#0369A1", type=6))
        ),
        hr(),
        # Análisis de la IA
        accordion(
          open = TRUE,
          accordion_panel(
            "Análisis de Procedencia de Contaminantes",
            icon = bs_icon("robot"),
            withSpinner(uiOutput("analisis_ia_out_rp"),type = 4,color = "#0369A1",size = 0.7)
          )
        )
      ),
      style = "border-radius: 15px; border: 1px solid #E0F2FE;"
    )
  ),
  # CSS adicional para efectos de 'Hover'
  tags$style(HTML("
   #btn_analizar_rp:hover,#volver_inicio2:hover,#generar_rose:hover {
      transform: translateY(-5px);
      box-shadow: 0 15px 30px rgba(3, 105, 161, 0.4) !important;
      filter: brightness(1.1);
   }
  "))
)