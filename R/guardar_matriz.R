guardar_matriz_UI <- function(id) {
    ns <- NS(id)
    tagList(
        actionButton(ns("guardar"), "Guardar", icon("save"))
    )
}

guardar_matriz_Server <- function(id, data, dir) {
    moduleServer(id, function(input, output, session) {
        observeEvent(input$guardar, {
            showNotification("Guardando...", duration = 1, type = "warning")
            time <- lubridate::now("America/Lima") %>% 
                str_replace_all(":|-", "_")
            file <- paste0(dir, "_", time, ".xlsx")
            filename <- file.path("data", dir, file)
            writexl::write_xlsx(data(), filename)
            showNotification("Guardado con éxito", duration = 3, type = "message")
        })
    })
}

guardar_matriz_App <- function(){
    data <- reactive(tibble(a = 1, x = 2))
    dir <- "datatest"
    file <- "guardar-test"
    ui <- fluidPage(
        tags$head(
            tags$link(rel = "stylesheet", type = "text/css", href = "mystyles.css")
        ),
        guardar_matriz_UI("myTestId")
    )
    server <- function(input, output, session) {
        guardar_matriz_Server("myTestId", data, dir)
    }
    shinyApp(ui, server)
}

# guardar_matriz_App()
