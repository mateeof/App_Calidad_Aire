# Paginas/gif_maker.R

ui_gif_maker <- nav_panel_hidden(
  "pagina_gif",style="margin-top:50px;",
  layout_sidebar(
    sidebar = sidebar(
      title = "Configurador de GIF",
      bg = "#FFFDE7", 
      
      # Botón dinámico que cambiará a mensaje de carga
      div(class="text-center mb-3",
          uiOutput("control_gif_ui")),
      
      hr(),
      # Botón para regresar al menú principal
      actionButton("volver_inicio4", "Volver al Menú", 
                   icon = bs_icon("arrow-left"), 
                   style = "background-color: transparent; border: 1px solid #FBC02D; color: #FBC02D; width: 100%; font-weight: 600;")
    ),
    
    card(
      card_header("Mapa Dinámico de Calidad del Aire segun IBOCA"),
      card_body(
        class = "p-0 d-flex justify-content-center",
  
        imageOutput("gif_plot_output", width = "100%", height = "auto")
      ),
      card_footer(
        p("Nota: La generación del GIF puede tardar unos minutos debido al procesamiento de imágenes.", 
          style = "font-size: 0.8rem; color: #777; text-align: center;")
      )
    ),
    card(
      card_header("¿Que es el IBOCA?"),
      card_body(
        p("El", strong("Índice Bogotano de Calidad del Aire (IBOCA)"),
          "es un instrumento que sirve para comunicar el estado de la calidad del aire en Bogota, considerando los principañes contaminantes atmosfericos por la Red de Monitoreo de Calidad del Aire de Bogota (RMCAB)",
          br(),
          # Barra de degradé
          div(style = "width:100%; height:30px; border-radius:8px;
                 background: linear-gradient(to right,
                 #68E045, #FFFE54, #ECBA41, #E63527, #8F3F97, #66329A);
                 margin-bottom:6px;")
          ,
          # Números debajo del degradé
          div(style = "display:flex; justify-content:space-between; 
                 font-size:0.8rem; color:#555; margin-bottom:12px;",
              span("0"), span("50"), span("100"), span("150"), 
              span("200"), span("300"), span("500")
          ),
          
          # Etiquetas de colores
          div(style = "display:flex; justify-content:space-between; flex-wrap:wrap; gap:8px;",
              div(style="display:flex; align-items:center; gap:6px;",
                  div(style="width:18px; height:18px; background:#68E045; border-radius:50%;"),
                  span("Bajo", style="font-size:0.85rem;")
              ),
              div(style="display:flex; align-items:center; gap:6px;",
                  div(style="width:18px; height:18px; background:#FFFE54; border-radius:50%; border:1px solid #ccc;"),
                  span("Moderado", style="font-size:0.85rem;")
              ),
              div(style="display:flex; align-items:center; gap:6px;",
                  div(style="width:18px; height:18px; background:#ECBA41; border-radius:50%;"),
                  span("Regular", style="font-size:0.85rem;")
              ),
              div(style="display:flex; align-items:center; gap:6px;",
                  div(style="width:18px; height:18px; background:#E63527; border-radius:50%;"),
                  span("Alto", style="font-size:0.85rem;")
              ),
              div(style="display:flex; align-items:center; gap:6px;",
                  div(style="width:18px; height:18px; background:#8F3F97; border-radius:50%;"),
                  span("Peligroso", style="font-size:0.85rem;")
         
              )
          )
        )
      )
    )
  ),
  # CSS adicional para efectos de 'Hover'
  tags$style(HTML("
   #volver_inicio4:hover {
      transform: translateY(-5px);
      box-shadow: 0 15px 30px rgba(251, 192, 45, 0.4) !important;
      filter: brightness(1.1);
   }
  #generar_gif:hover {
      transform: translateY(-5px);
      box-shadow: 0 15px 30px rgba(251, 192, 45, 0.4) !important;
      filter: brightness(1.1);
   }"
  )),
)

