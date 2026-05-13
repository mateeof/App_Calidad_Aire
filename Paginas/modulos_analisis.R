ui_modulos_analisis<-div(
  class = "container-fluid", # Ocupa todo el ancho
  style = "padding: 40px; font-family: 'Manrope', sans-serif;",
  
      # --- SECCIÓN: GUÍA DE USUARIO ---
      h3("¿Cómo dominar la Herramienta?", class = "mb-4 mt-5 text-center", 
         style = "font-weight: 700; border-left: 5px solid #2E8B57; padding-left: 15px;"),
      
      div(class = "row g-4 justify-content-center",
          
          # Paso 1: Configurar
          div(class = "col-md-3",
              card(
                style = "border: none; border-radius: 20px; box-shadow: 0 10px 20px rgba(0,0,0,0.05); transition: transform 0.3s ease;",
                class = "h-100 text-center p-4 card-hover",
                div(style = "background: #E8F5E9; width: 60px; height: 60px; border-radius: 50%; display: flex; align-items: center; justify-content: center; margin: 0 auto 20px;",
                    bs_icon("sliders", size = "1.8rem", class = "text-success")),
                h5(strong("1. Configura"), style = "color: #2E8B57;"),
                p("Define tu zona de interés, el contaminante y el rango de fechas en el panel lateral.", 
                  style = "font-size: 0.9rem; color: #666;")
              )
          ),
          
          # Paso 2: Ejecutar
          div(class = "col-md-3",
              card(
                style = "border: none; border-radius: 20px; box-shadow: 0 10px 20px rgba(0,0,0,0.05); transition: transform 0.3s ease;",
                class = "h-100 text-center p-4 card-hover",
                div(style = "background: #E3F2FD; width: 60px; height: 60px; border-radius: 50%; display: flex; align-items: center; justify-content: center; margin: 0 auto 20px;",
                    bs_icon("play-circle-fill", size = "1.8rem", class = "text-primary")),
                h5(strong("2. Genera"), style = "color: #0d6efd;"),
                p("Haz clic en 'Generar Gráfica'. La app conectará con la RMCAB para obtener datos en tiempo real.", 
                  style = "font-size: 0.9rem; color: #666;")
              )
          ),
          
          # Paso 3: Análisis IA
          div(class = "col-md-3",
              card(
                style = "border: none; border-radius: 20px; box-shadow: 0 10px 20px rgba(0,0,0,0.05); transition: transform 0.3s ease;",
                class = "h-100 text-center p-4 card-hover",
                div(style = "background: #F3E5F5; width: 60px; height: 60px; border-radius: 50%; display: flex; align-items: center; justify-content: center; margin: 0 auto 20px;",
                    bs_icon("cpu", size = "1.8rem", style = "color: #9c27b0;")),
                h5(strong("3. Interpreta"), style = "color: #9c27b0;"),
                p("¿Dudas con los resultados? Activa el análisis de IA para obtener una explicación científica.", 
                  style = "font-size: 0.9rem; color: #666;")
              )
          ),
          
          # Paso 4: Descubrimiento
          div(class = "col-md-3",
              card(
                style = "border: none; border-radius: 20px; box-shadow: 0 10px 20px rgba(0,0,0,0.05); transition: transform 0.3s ease;",
                class = "h-100 text-center p-4 card-hover",
                div(style = "background: #FFF3E0; width: 60px; height: 60px; border-radius: 50%; display: flex; align-items: center; justify-content: center; margin: 0 auto 20px;",
                    bs_icon("search", size = "1.8rem", class = "text-warning")),
                h5(strong("4. Descubre"), style = "color: #ef6c00;"),
                p("Navega entre módulos para encontrar patrones y fuentes de emisión en la ciudad.", 
                  style = "font-size: 0.9rem; color: #666;")
              )
          )
      ),
      
      br(),hr(),br(),
  
      # --- SECCION ANALISIS ---  
      h3("Módulos de Análisis Avanzado",class = "mb-4 mt-5 text-center", 
         style = "font-weight: 700; border-left: 5px solid #2E8B57; padding-left: 15px;"),
      
      # FILA INFERIOR: TARJETAS CON TEXTO/IMG Y BOTÓN ANCHO
      layout_column_wrap(
        width = 1/3,
        heights_equal = "row",
        
        # Tarjeta 1
        card(
          # Estilo de la card: Bordes redondeados y sombra sutil para que flote sobre el fondo #f5f5f5
          style = "border-radius: 15px; border: none; box-shadow: 0 4px 15px rgba(0,0,0,0.05); overflow: hidden; transition: transform 0.3s ease;",
          
          card_header(
            div(class = "d-flex align-items-center",
                bs_icon("clock-history", size = "1.5rem", class = "me-2"),
                span("Dinámica Temporal", style = "font-weight: 700; font-size: 1.25rem;")
            ),
            # Cambiamos el azul primario por un Slate-Blue más profesional
            style = "background-color: #1A73E8; color: white; border: none; padding: 15px;"
          ),
          
          card_body(
            style = "padding: 20px; background-color: white;",
            
            # Texto superior
            div(style = "min-height: 90px; text-align: center;",
                p("¿Cómo cambia la concentracion de contaminantes a lo largo de un dia, semana, un año?", 
                  style = "font-size: 1.1rem; color: #2E8B57; font-weight: 700; margin-bottom: 8px; line-height: 1.2;"),
                p("Identifica ciclos horarios y patrones semanales mediante modelos de variación estadística avanzada.", 
                  style = "font-size: 0.95rem; color: #7f8c8d; font-weight: 400;")
            ),
            
            # Contenedor de Imagen con efecto de marco
            div(class = "text-center my-3",
                style = "border-radius: 10px; padding: 10px; border: 1px solid #edf2f7;",
                tags$img(
                  src = "timeVariation.png", 
                  style = "width: 100%; max-height: 180px; object-fit: contain; filter: drop-shadow(0 2px 4px rgba(0,0,0,0.1));"
                )
            )
          ),
          
          card_footer(
            style = "background: white; border-top: 1px solid #f1f1f1; padding: 15px;",
            # El botón ahora es sólido para invitar a la acción (Call to Action)
            actionButton(
              "ir_time_variation", 
              "Explorar Análisis Temporal", 
              icon = bs_icon("arrow-right-circle"),
              style = "background-color: #1A73E8; color: white; border: none; width: 100%; font-weight: 700; padding: 12px; border-radius: 8px; transition: 0.3s;",
              class = "btn-hover-effect" # Puedes añadir una clase para efectos CSS
            )
          )
        ),
        
        # Tarjeta 2
        card(
          # Mantenemos el radio de 15px y la sombra suave para consistencia visual
          style = "border-radius: 15px; border: none; box-shadow: 0 4px 15px rgba(0,0,0,0.05); overflow: hidden; transition: transform 0.3s ease;",
          
          card_header(
            div(class = "d-flex align-items-center",
                bs_icon("compass", size = "1.5rem", class = "me-2"),
                span("Procedencia de los contaminantes", style = "font-weight: 700; font-size: 1.25rem;")
            ),
            # Usamos un azul profundo pero vibrante para el tema de vientos
            style = "background-color: #0369A1; color: white; border: none; padding: 15px;"
          ),
          
          card_body(
            style = "padding: 20px; background-color: white;",
            
            # Texto superior: Pregunta gancho
            div(style = "min-height: 90px; text-align: center;",
                p("¿Desde qué dirección provienen las masas de aire más contaminadas?", 
                  style = "font-size: 1.1rem; color: #0284C7; font-weight: 700; margin-bottom: 8px; line-height: 1.2;"),
                p("Cruza datos de velocidad y dirección del viento para localizar fuentes de emisión potenciales en la ciudad.", 
                  style = "font-size: 0.95rem; color: #7f8c8d; font-weight: 400;")
            ),
            
            # Contenedor de Imagen con marco celeste suave
            div(class = "text-center my-3",
                style = "border-radius: 10px; padding: 10px; border: 1px solid #E0F2FE;",
                tags$img(
                  src = "pollutionRose.png", 
                  style = "width: 100%; max-height: 180px; object-fit: contain; filter: drop-shadow(0 2px 4px rgba(0,0,0,0.08));"
                )
            )
          ),
          
          card_footer(
            style = "background: white; border-top: 1px solid #f1f1f1; padding: 15px;",
            # Botón Call to Action unificado con el estilo de la app
            actionButton(
              "ir_rosa", 
              "Analizar Procedencia", 
              icon = bs_icon("wind"),
              style = "background-color: #0369A1; color: white; border: none; width: 100%; font-weight: 700; padding: 12px; border-radius: 8px;",
              class = "btn-hover-effect"
            )
          )
        ),
        
        # Tarjeta 3
        card(
          # Mantenemos el estándar de 15px de radio y sombra suave para consistencia
          style = "border-radius: 15px; border: none; box-shadow: 0 4px 15px rgba(0,0,0,0.05); overflow: hidden; transition: transform 0.3s ease;",
          
          card_header(
            div(class = "d-flex align-items-center",
                bs_icon("grid-3x3-gap", size = "1.5rem", class = "me-2"),
                span("Relación Multivariada", style = "font-weight: 700; font-size: 1.25rem;")
            ),
            # Usamos un tono pizarra oscuro para denotar seriedad analítica
            style = "background-color: #34495e; color: white; border: none; padding: 15px;"
          ),
          
          card_body(
            style = "padding: 20px; background-color: white;",
            
            # Texto superior
            div(style = "min-height: 90px; text-align: center;",
                p("¿Cómo influye el clima en la concentración de partículas?", 
                  style = "font-size: 1.1rem; color: #2c3e50; font-weight: 700; margin-bottom: 8px; line-height: 1.2;"),
                p("Analiza la dependencia lineal entre variables meteorológicas y contaminantes críticos mediante matrices de Pearson.", 
                  style = "font-size: 0.95rem; color: #7f8c8d; font-weight: 400;")
            ),
            
            # Contenedor de Imagen con marco gris técnico
            div(class = "text-center my-3",
                style = "border-radius: 10px; padding: 10px; border: 1px solid #e2e8f0;",
                tags$img(
                  src = "correlation.png", 
                  style = "width: 100%; max-height: 180px; object-fit: contain; filter: drop-shadow(0 2px 4px rgba(0,0,0,0.08));"
                )
            )
          ),
          
          card_footer(
            style = "background: white; border-top: 1px solid #f1f1f1; padding: 15px;",
            # Botón sólido para mantener la jerarquía de botones principales
            actionButton(
              "ir_cor", 
              "Visualizar Matriz", 
              icon = bs_icon("table"),
              style = "background-color: #34495e; color: white; border: none; width: 100%; font-weight: 700; padding: 12px; border-radius: 8px;",
              class = "btn-hover-effect"
            )
          )
        ),
        # Tarjeta 4: Mapa Animado (GIF)
        card(
          style = "border-radius: 15px; border: none; box-shadow: 0 4px 15px rgba(0,0,0,0.05); overflow: hidden; transition: transform 0.3s ease;",
          
          card_header( div(class = "d-flex align-items-center", bs_icon("map", size = "1.5rem", class = "me-2"), span("Evolución Espacial", style = "font-weight: 700; font-size: 1.25rem;") ),
                       style = "background-color: #F9A825; color: black; border: none; padding: 15px;" ),
          
          card_body(style = "padding: 20px; background-color: white;",
                    div(style = "min-height: 90px; text-align: center;",
                        p("¿Que zonas de bogota fueron las mas contaminadas en las ultimas horas?", 
                          style = "font-size: 1.1rem; color: #2c3e50; font-weight: 700; margin-bottom: 8px; line-height: 1.2;"),
                        p("Genera un mapa animado donde a partir del IBOCA se logra identificar los niveles de contaminación en la ciudad.", 
                          style = "font-size: 0.95rem; color: #7f8c8d; font-weight: 400;")),
                    
                    div(class = "text-center my-3",
                        style = "border-radius: 10px; padding: 10px; border: 1px solid #e2e8f0;",
                        tags$img(
                          src = "MapaGif.png", 
                          style = "width: 100%; max-height: 180px; object-fit: contain; filter: drop-shadow(0 2px 4px rgba(0,0,0,0.08));"   )
                    ) ),
          
          card_footer(
            style = "background: white; border-top: 1px solid #f1f1f1; padding: 15px;",
            actionButton( "ir_gif", "Generar Mapa Animado", icon = bs_icon("play-circle"), style = "background-color: #F9A825; color: black; border: none; width: 100%; font-weight: 700; padding: 12px; border-radius: 8px;",  class = "btn-hover-effect"
            ) ) ),
        # Tarjeta 5:Correlacion entre dos contaminantes
        card(
          # Consistencia total: radio de 15px, sin borde y sombra sutil
          style = "border-radius: 15px; border: none; box-shadow: 0 4px 15px rgba(0,0,0,0.05); overflow: hidden; transition: transform 0.3s ease;",
          
          card_header(
            div(class = "d-flex align-items-center",
                bs_icon("graph-up-arrow", size = "1.5rem", class = "me-2"),
                span("Correlación Bivariada", style = "font-weight: 700; font-size: 1.25rem;")
            ),
            # Usamos un color Índigo/Púrpura Profundo para análisis de variables
            style = "background-color: #4F46E5; color: white; border: none; padding: 15px;"
          ),
          
          card_body(
            style = "padding: 20px; background-color: white;",
            
            # Texto superior: Pregunta gancho
            div(style = "min-height: 90px; text-align: center;",
                p("¿Cómo se relacionan dos contaminantes entre sí?", 
                  style = "font-size: 1.1rem; color: #4338CA; font-weight: 700; margin-bottom: 8px; line-height: 1.2;"),
                p("Explora la dependencia estadística mediante diagramas de dispersión y detecta patrones de emisión simultánea.", 
                  style = "font-size: 0.95rem; color: #7f8c8d; font-weight: 400;")
            ),
            
            # Contenedor de Imagen con marco púrpura muy tenue
            div(class = "text-center my-3",
                style = "border-radius: 10px; padding: 10px; border: 1px solid #EDE9FE;",
                tags$img(
                  src = "CorrelacionBivariada.png", 
                  style = "width: 100%; max-height: 180px; object-fit: contain; filter: drop-shadow(0 2px 4px rgba(0,0,0,0.08));"
                )
            )
          ),
          
          card_footer(
            style = "background: white; border-top: 1px solid #f1f1f1; padding: 15px;",
            # Botón sólido unificado
            actionButton(
              "ir_scatter", 
              "Analizar Dispersión", 
              icon = bs_icon("activity"),
              style = "background-color: #4F46E5; color: white; border: none; width: 100%; font-weight: 700; padding: 12px; border-radius: 8px;",
              class = "btn-hover-effect"
            )
          )
        ),
        # Tarjeta 6:Estado Actual
        card(
          # Consistencia total: radio de 15px, sin borde y sombra sutil
          style = "border-radius: 15px; border: none; box-shadow: 0 4px 15px rgba(0,0,0,0.05); overflow: hidden; transition: transform 0.3s ease;",
          
          card_header(
            div(class = "d-flex align-items-center",
                bs_icon("graph-up-arrow", size = "1.5rem", class = "me-2"),
                span("Estado Actual", style = "font-weight: 700; font-size: 1.25rem;")
            ),
            # Usamos un color Índigo/Púrpura Profundo para análisis de variables
            style = "background-color: #FF8C8C; color: white; border: none; padding: 15px;"
          ),
          
          card_body(
            style = "padding: 20px; background-color: white;",
            
            # Texto superior: Pregunta gancho
            div(style = "min-height: 90px; text-align: center;",
                p("¿Cómo estamos actualmente?", 
                  style = "font-size: 1.1rem; color: #FF8C8C; font-weight: 700; margin-bottom: 8px; line-height: 1.2;"),
                p("Conoce el contaminante predominante del día anterior y la ubicación de las estaciones de monitoreo en Bogotá.", 
                  style = "font-size: 0.95rem; color: #7f8c8d; font-weight: 400;")
            ),
            
            # Contenedor de Imagen con marco púrpura muy tenue
            div(class = "text-center my-3",
                style = "border-radius: 10px; padding: 10px; border: 1px solid #EDE9FE;",
                tags$img(
                  src = "estadoActual.png", 
                  style = "width: 100%; max-height: 180px; object-fit: contain; filter: drop-shadow(0 2px 4px rgba(0,0,0,0.08));"
                )
            )
          ),
          
          card_footer(
            style = "background: white; border-top: 1px solid #f1f1f1; padding: 15px;",
            # Botón sólido unificado
            actionButton(
              "ir_estado_actual", 
              "Ver Estado Actual", 
              icon = bs_icon("activity"),
              style = "background-color: #FF8C8C; color: white; border: none; width: 100%; font-weight: 700; padding: 12px; border-radius: 8px;",
              class = "btn-hover-effect"
            )
          )
        ),
        
        #Tarjeta #7
        card(
          style = "border-radius: 15px; border: none; box-shadow: 0 4px 15px rgba(0,0,0,0.05); overflow: hidden; transition: transform 0.3s ease;",
          
          card_header(
            div(class = "d-flex align-items-center",
                bs_icon("calendar3", size = "1.5rem", class = "me-2"),
                span("Distribución Diaria", style = "font-weight: 700; font-size: 1.25rem;")
            ),
            style = "background-color: #0D9488; color: white; border: none; padding: 15px;"
          ),
          
          card_body(
            style = "padding: 20px; background-color: white;",
            
            div(style = "min-height: 90px; text-align: center;",
                p("¿Qué días del mes fueron los más contaminados?",
                  style = "font-size: 1.1rem; color: #0D9488; font-weight: 700; margin-bottom: 8px; line-height: 1.2;"),
                p("Visualiza la concentración diaria de contaminantes en formato calendario para identificar episodios críticos de contaminación.",
                  style = "font-size: 0.95rem; color: #7f8c8d; font-weight: 400;")
            ),
            
            div(class = "text-center my-3",
                style = "border-radius: 10px; padding: 10px; border: 1px solid #CCFBF1;",
                tags$img(
                  src = "calendarPlot.png",
                  style = "width: 100%; max-height: 180px; object-fit: contain; filter: drop-shadow(0 2px 4px rgba(0,0,0,0.08));"
                )
            )
          ),
          
          card_footer(
            style = "background: white; border-top: 1px solid #f1f1f1; padding: 15px;",
            actionButton(
              "ir_calendar",
              "Ver Calendar Plot",
              icon = bs_icon("calendar3"),
              style = "background-color: #0D9488; color: white; border: none; width: 100%; font-weight: 700; padding: 12px; border-radius: 8px;",
              class = "btn-hover-effect"
            )
          )
        ),
      ),
  # CSS adicional para efectos de 'Hover'
  tags$style(HTML("
   #ir_time_variation:hover {
      transform: translateY(-5px);
      box-shadow: 0 15px 30px rgba(26, 115, 232, 0.4) !important;
      filter: brightness(1.1);
   }
   #ir_rosa:hover {
      transform: translateY(-5px);
      box-shadow: 0 15px 30px rgba(3, 105, 161, 0.4) !important;
      filter: brightness(1.1);
   }
   #ir_cor:hover {
      transform: translateY(-5px);
      box-shadow: 0 15px 30px rgba(52, 73, 94, 0.4) !important;
      filter: brightness(1.1);
    }
    #ir_gif:hover {
      transform: translateY(-5px);
      box-shadow: 0 15px 30px rgba(249, 168, 37, 0.4) !important;
      filter: brightness(1.1);
    }
    #ir_scatter:hover {
      transform: translateY(-5px);
      box-shadow: 0 15px 30px rgba(79, 70, 229, 0.4) !important;
      filter: brightness(1.1);
    }
     #ir_estado_actual:hover {
      transform: translateY(-5px);
      box-shadow: 0 15px 30px rgba(255, 140, 140, 0.4) !important;
      filter: brightness(1.1);
     }
    #ir_calendar:hover {
  transform: translateY(-5px);
  box-shadow: 0 15px 30px rgba(13, 148, 136, 0.4) !important;
  filter: brightness(1.1);
}
  "))
      )