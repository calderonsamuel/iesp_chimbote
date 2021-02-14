inputs_PEI_PEN_UI <- function(id) {
    ns <- NS(id)
    tagList(
        add_inputs_UI(ns("inputs"))
    )
}

inputs_PEI_PEN_Server <- function(id, 
                                  choices_fila = as.character(1:21), 
                                  choices_columna = c("PEI - OBJETIVO ESTRATÉGICO" = "texto_OE",
                                                      "PEI - LÍNEA ESTRATÉGICA" = "texto_LE")) {
    moduleServer(id, function(input, output, session) {
        inputs <- add_inputs_Server("inputs", choices_fila, choices_columna)
    })
}

inputs_PEI_PEN_App <- function(){
    choices_fila <- as.character(1:21)
    choices_columna <- c("PEI - OBJETIVO ESTRATÉGICO" = "texto_OE",
                         "PEI - LÍNEA ESTRATÉGICA" = "texto_LE")
    ui <- fluidPage(
        sidebarLayout(
            sidebarPanel(
                inputs_PEI_PEN_UI("myTestId")
            ),
            mainPanel()
        )
    )
    server <- function(input, output, session) {
        inputs_PEI_PEN_Server("myTestId", choices_fila, choices_columna)
    }
    shinyApp(ui, server)
}

inputs_PEI_PEN_App()
