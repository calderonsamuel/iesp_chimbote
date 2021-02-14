inputs_lista_cotejo_UI <- function(id) {
    ns <- NS(id)
    tagList(
        add_inputs_UI(ns("inputs")),
        guardar_matriz_UI(ns("guardar"))
    )
}

inputs_lista_cotejo_Server <- function(id) {
    moduleServer(id, function(input, output, session) {
        
    })
}

inputs_lista_cotejo_App <- function(){
    ui <- fluidPage(
        inputs_lista_cotejo_UI("myTestId")
    )
    server <- function(input, output, session) {
        inputs_lista_cotejo_Server("myTestId")
    }
    shinyApp(ui, server)
}

# inputs_lista_cotejo_App()