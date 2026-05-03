ui_estado_actual <- nav_panel_hidden(
  "pagina_estado_actual",style="margin-top:100px;",
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
                     icon = icon("play"), class="btn-success btn-lg",
                     style = "
        width: 100%;
        font-weight: 700;
        padding: 15px;
        border-radius: 12px;
        border: none;
        background: #FF8C8C;
        color: white;
        box-shadow: 0 4px 15px rgba(40, 167, 69, 0.2);
        transition: all 0.3s ease; /* CLAVE para el hover */
        cursor: pointer;
      ")
    ),
    div(style = "background-color: #F8F9FA; padding: 15px; border-radius: 10px; border: 1px solid #eee;",
        p(strong("Nota técnica:"), " Los valores corresponden al promedio de la red monitoreada el día anterior.", 
          style = "font-size: 0.85rem; color: #555; text-align: center;")
    )
  )
),
# Botón volver
actionButton(
  "volver_inicio6", "Volver al menú",
  icon = bs_icon("arrow-left-short"),
  style = "background-color: transparent; color: #FF8C8C; border: 1px solid #DDD6FE; width: 100%; margin-top: 10px; font-weight: 500;"
),
# CSS adicional para efectos de 'Hover'
tags$style(HTML("
   #generar_estado:hover {
      transform: translateY(-5px);
      box-shadow: 0 15px 30px rgba(255, 140, 140, 0.4) !important;
      filter: brightness(1.1);
   }
   #volver_inicio6:hover {
      transform: translateY(-5px);
      box-shadow: 0 15px 30px rgba(255, 140, 140, 0.4) !important;
      filter: brightness(1.1);
   }"
)),
)