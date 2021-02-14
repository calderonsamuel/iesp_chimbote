aliPEI_PATUI <- function(id) {
  ns <- NS(id)
  tagList(
    uiOutput(ns("tabla"))
  )
}

aliPEI_PATServer <- function(id) {
  moduleServer(id, function(input, output, session) {
    
      matriz <- readxl::read_excel("data/ali pei pat.xlsx", trim_ws = FALSE)
      
      header <- readxl::read_excel("data/ali pei pat reference.xlsx", sheet = "reference2")
    
      color_data <- pivot_color(matriz, num_actividad)
    
      output$tabla <- renderUI({
        color_data %>%
          select(-contains(c("shading", "color"))) %>%
          select(`Num OE`, num_actividad, ends_with("_1")) %>%
          rename_with(.fn = ~str_remove(.x, "_1$")) %>%
          relocate(num_actividad, .before = texto_actividad) %>%
          flextable() %>%
          set_header_df(mapping = header) %>% 
          merge_h(part = "header") %>%
          compose_quick_all(color_data, c("OE", "LE", "indicador", "actividad")) %>%
          merge_v() %>%
          autofit() %>%
          theme_box() %>%
          align(align = "center",part = "header") %>% 
          htmltools_value()
      })

  })
}

aliPEI_PATApp <- function(){
  ui <- fluidPage(
    aliPEI_PATUI("myTestId")
  )
  server <- function(input, output, session) {
    aliPEI_PATServer("myTestId")
  }
  shinyApp(ui, server)
}

# aliPEI_PATApp()
