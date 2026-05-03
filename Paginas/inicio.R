ui_inicio <- div(
  class = "container-fluid",
  style = "padding: 80px 20px; font-family: 'Manrope', sans-serif; background-color: #f8f9fa; min-height: 100vh;",
  
  # --- SECCIÓN DE BIENVENIDA / EXPLICACIÓN ---
  div(
    style = "max-width: 800px; margin: 0 auto 50px auto; text-align: center;",
    h1("Bienvenido a ###", 
       style = "font-weight: 800; color: #2E8B57; font-size: 3rem; margin-bottom: 20px;"),
    p("Te invitamos a explorar, aprender e interactuar con los datos de la calidad del aire en Bogotá. 
      Descubre qué respiramos hoy a través de herramientas interactivas y profundiza en los fundamentos técnicos
      que nos permiten entender el entorno ambiental de nuestra ciudad",
      style = "font-size: 1.2rem; color: #555; line-height: 1.6;")
  ),
  
  # --- CONTENEDOR DE BOTONES (Apilados verticalmente) ---
  div(
    style = "display: flex; flex-direction: column; align-items: center; gap: 25px;",
    
    # Botón Análisis (Principal) - Más grande
    actionButton(
      "ir_modulo_analisis",
      label = div(
        style = "display: flex; align-items: center; text-align: left; width: 100%;",
        icon("chart-line", style = "font-size: 3rem; margin-right: 30px;"),
        div(
          div("Módulos de Análisis", style = "font-size: 1.8rem; font-weight: 800;"),
          span("Accede a gráficos interactivos y reportes técnicos", style = "font-weight: 400; font-size: 1rem; opacity: 0.9;")
        )
      ),
      style = "
        width: 100%; 
        max-width: 700px; 
        padding: 45px 50px; 
        border-radius: 25px; 
        border: none;
        background: linear-gradient(145deg, #28a745, #218838);
        color: white;
        box-shadow: 0 12px 24px rgba(40, 167, 69, 0.3);
        transition: all 0.3s ease;
        cursor: pointer;
      "
    ),
    
    # Botón Teoría (Secundario) - Más grande
    actionButton(
      "ir_teoria",
      label = div(
        style = "display: flex; align-items: center; text-align: left; width: 100%;",
        icon("book-open", style = "font-size: 3rem; margin-right: 30px;"),
        div(
          div("Fundamentos Teóricos", style = "font-size: 1.8rem; font-weight: 800;"),
          span("Aprende sobre contaminantes y normatividad", style = "font-weight: 400; font-size: 1rem; opacity: 0.8;")
        )
      ),
      style = "
        width: 100%; 
        max-width: 700px; 
        padding: 45px 50px; 
        border-radius: 25px; 
        border: 2px solid #28a745;
        background: white;
        color: #28a745;
        box-shadow: 0 12px 24px rgba(0, 0, 0, 0.05);
        transition: all 0.3s ease;
        cursor: pointer;
      "
    )
  ),
  
  # CSS para efectos de movimiento
  tags$style(HTML("
    #ir_modulo_analisis:hover {
      transform: scale(1.02);
      box-shadow: 0 20px 40px rgba(40, 167, 69, 0.4) !important;
    }
    #ir_teoria:hover {
      transform: scale(1.02);
      background-color: #f0fff4 !important;
      box-shadow: 0 20px 40px rgba(0, 0, 0, 0.08) !important;
    }
  "))
)