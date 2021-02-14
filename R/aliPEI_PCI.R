aliPEI_PCI_UI <- function(id) {
  ns <- NS(id)
  tagList(
    uiOutput(ns("tabla"))
  )
}

aliPEI_PCI_Server <- function(id, data) {
  moduleServer(id, function(input, output, session) {
    output$tabla <- renderUI({
      # matriz <- readxl::read_excel("data/ali pei pci.xlsx", trim_ws = FALSE)
      
      matriz <- data()
      
      header <- readxl::read_excel("data/ali pei pci.xlsx", sheet = "reference")
      
      color_data <- pivot_color(matriz, numero)
      
      my_bg_color <- function(x) {
        case_when(
          x == 1 ~ "yellow",
          x == 2 ~ "limegreen",
          x == 3 ~ "cyan",
          x == 4 ~ "magenta",
          x == 5 ~ "#008080",
          TRUE ~ "transparent"
        )
      }

      color_data %>%
          select(-contains(c("shading", "color"))) %>%
          select(numero, ends_with("_1")) %>%
          rename_with(.fn = ~str_remove(.x, "_1$")) %>%
          flextable() %>%
          compose_quick_all(color_data, c("conceptual", "pedagogico", "transversal", "principios",
                                          "metodologicos", "valores", "filosofia")) %>%
          merge_v() %>%
          autofit() %>%
          set_header_df(header) %>% 
          merge_v(part = "header") %>% 
          merge_h(part = "header") %>% 
          theme_box() %>% 
          align(align = "center", part = "header") %>% 
          bg(bg = my_bg_color, source = "numero") %>% 
          bg(bg = "#FBE4D5", part = "header") %>% 
          htmltools_value()
    })
  })
}

aliPEI_PCI_App <- function(){
  ui <- fluidPage(
    aliPEI_PCI_UI("myTestId")
  )
  server <- function(input, output, session) {
    data <- reactive({
      readxl::read_excel("data/ali pei pci.xlsx", trim_ws = FALSE)
    })
    aliPEI_PCI_Server("myTestId", data)
  }
  shinyApp(ui, server)
}

# aliPEI_PCI_App()
