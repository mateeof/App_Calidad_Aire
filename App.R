library(shiny)
library(bslib)

ui <- page_navbar(
  title = "Calidad Aire Bogotá",
  theme = bs_theme(
    base_font = font_google("Inter"),
    navbar_bg ="#93BCFA"
  ),
  nav_panel("¿Como varian los contaminantes con el tiempo?", "dentro?"),
  
)



server <- function (input, output, session){}

shinyApp(ui, server)
