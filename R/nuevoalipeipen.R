nuevoalipeipenUI <- function(id) {
    ns <- NS(id)
    tagList(
        uiOutput(ns("tabla"))
    )
}

nuevoalipeipenServer <- function(id) {
    moduleServer(id, function(input, output, session) {
        data <- readxl::read_excel("data/ali pei pen 1.xlsx")
        
        output$tabla <- renderUI({
            data_color <- data
            data <- select(data, !contains("hili"))
            data %>% 
                flextable() %>% 
                highlight(j = "PROPUESTA DE MEJORA OE", color = data_color$hili2) %>% 
                highlight(j = "PROPUESTA DE MEJORA LE", color = data_color$hili3) %>% 
                merge_v(names(data)) %>% 
                theme_box() %>%
                htmltools_value()
        })
    })
}

nuevoalipeipenApp <- function(){
    ui <- fluidPage(
        nuevoalipeipenUI("myTestId")
    )
    server <- function(input, output, session) {
        nuevoalipeipenServer("myTestId")
    }
    shinyApp(ui, server)
}

# nuevoalipeipenApp()
