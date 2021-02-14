inputs_PAT_UI <- function(id) {
    ns <- NS(id)
    tagList(
        add_inputs_UI(ns("inputs")),
        guardar_matriz_UI(ns("guardar"))
    )
}

inputs_PAT_Server <- function(id) {
    moduleServer(id, function(input, output, session) {
        
    })
}

inputs_PAT_App <- function(){
    ui <- fluidPage(
        inputs_PAT_UI("myTestId")
    )
    server <- function(input, output, session) {
        inputs_PAT_Server("myTestId")
    }
    shinyApp(ui, server)
}

# inputs_PAT_App()