aliPEI_PEN_UI <- function(id) {
  ns <- NS(id)
  tagList(
    uiOutput(ns("tabla"))
  )
}

aliPEI_PEN_Server <- function(id) {
  moduleServer(id, function(input, output, session) {
    output$tabla <- renderUI({
      matriz <- readxl::read_xlsx("data/ali pei pen.xlsx", trim_ws = FALSE)
      
      color_data <- pivot_color(matriz, `Num OE`)
      
      color_data %>%
        select(-contains(c("shading", "color"))) %>%
        select(COMPONENTES, `Num OE`, ends_with("_1")) %>%
        rename_with(.fn = ~str_remove(.x, "_1$")) %>% 
        relocate(`Num OE`, .after = texto_relacion) %>%
        flextable() %>%
        compose_quick_all(color_data, c("relacion", "OE", "LE")) %>% 
        merge_v() %>%
        autofit() %>%
        set_header_labels(`Num OE` = "Nº OE",
                          texto_OE = "PEI - OBJETIVO ESTRATÉGICO",
                          texto_LE = "PEI - LINEA ESTRATÉGICA",
                          texto_relacion = "RELACIÓN PEN-PER") %>%
        theme_box() %>% 
        htmltools_value()
    })
  })
}

aliPEI_PEN_App <- function(){
  ui <- fluidPage(
    aliPEI_PEN_UI("myTestId")
  )
  server <- function(input, output, session) {
    aliPEI_PEN_Server("myTestId")
  }
  shinyApp(ui, server)
}

# aliPEI_PEN_App()
