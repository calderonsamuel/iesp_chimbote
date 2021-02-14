lista_cotejoUI <- function(id) {
    ns <- NS(id)
    tagList(
        uiOutput(ns("tabla"))
    )
}

lista_cotejoServer <- function(id) {
    moduleServer(id, function(input, output, session) {
        # data <- reactive(db_leer_data("lista_cotejo"))
        
        data <- reactive({
            readxl::read_excel("data/lista de cotejo.xlsx")
        })
        
        output$tabla <- renderUI({
            data <- data()
            
            header <- readxl::read_excel("data/lista de cotejo.xlsx", sheet = "reference")
            
            data %>% 
                as_grouped_data("group") %>% 
                as_flextable() %>% 
                set_header_df(header) %>% 
                merge_v(part = "header") %>% 
                merge_h(part = "header") %>% 
                bold(j = 1, i = ~ !is.na(group), bold = TRUE, part = "body" ) %>% 
                bg(j = 1, i = ~ !is.na(group), bg = "grey90", part = "body" ) %>% 
                bg(j = "MPA", i = ~str_detect(MPA, "No"),bg = "#FADBD8", part = "body" ) %>% 
                bg(bg = "#e2efd9", part = "header") %>% 
                merge_v(j = c("gestion1", "gestion2")) %>% 
                merge_h(i = ~ is.na(group)) %>% 
                theme_box() %>% 
                autofit() %>% 
                align(align = "center", part = "header") %>% 
                htmltools_value()
        })
    })  
}

lista_cotejoApp <- function(){
    ui <- fluidPage(
        lista_cotejoUI("myTestId")
    ) 
    server <- function(input, output, session) {
        lista_cotejoServer("myTestId")
    }
    shinyApp(ui, server)
} 

# lista_cotejoApp() 

