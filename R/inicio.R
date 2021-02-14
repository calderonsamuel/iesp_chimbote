inicioUI <- function(id) {
    ns <- NS(id)
    tagList(
        fluidRow(
            column(2),
            column(
                width = 8,
                fluidRow(
                    column(3, 
                       tags$div(
                            tags$img(src = "images/logo-iespp.png", alt = "logo", style = "width:160px")), 
                            style = "text-align:center"),
                    column(6, tags$h1("INSTITUTO DE EDUCACIÓN SUPERIOR PEDAGÓGICO PÚBLICO", class = "texto-inicio")),
                    column(3)
                ),
                tags$h2("APLICATIVO DE GESTIÓN INSTITUCIONAL", class = "texto-inicio"),
                tags$p("El IESPP Chimbote, institución que promueve el desarrollo tecnológico en la región, presenta su aplicativo de Gestión institucional, el cual garantiza un alineamiento total entre sus herramientas de gestión. ", class = "texto-inicio"),
                tags$p("Para ello, se empleará las siguientes técnicas: ", class = "texto-inicio"),
                fluidRow(
                    column(
                        width = 6, 
                        actionButton(ns("coloreado"), 
                                     label = HTML("Técnica del <br>coloreado"), 
                                     style = "width:100%;background-color:#FFC000;color:#000000"),
                        uiOutput(ns("ui_coloreado"))
                    ),
                    column(
                        width = 6, 
                        actionButton(ns("alineamiento"), 
                                     label = HTML("Técnica de matrices <br>de alineamiento"), 
                                     style = "width:100%;background-color:#DB1717;color:#000000"),
                        uiOutput(ns("ui_alineamiento"))
                    )
                )
            ),
            column(2)
        )
    )
}

inicioServer <- function(id) {
    moduleServer(id, function(input, output, session) {
        output$ui_alineamiento <- renderUI({
            if(input$alineamiento %% 2 == 1) {
                x <- tagList(
                    wellPanel(
                        tags$p("Técnica de organización de la información, en la que las ideas se presentan en función de un criterio organizador común para garantizar un trabajo coordinado y ordenado, que no genere contradicciones durante su proceso de construcción.", class = "texto-inicio")
                    )
                )
            } else {
                x <- tagList()
            }
            x
        })
        
        output$ui_coloreado <- renderUI({
            if(input$coloreado %% 2 == 1) {
                x <- tagList(
                    wellPanel(
                        tags$p("Técnica que permite la identificación de ideas centrales y comunes en diferentes enunciados, mediante la aplicación de un color particular para cada idea que sea identificada, repitiendo el color en todos los casos en que se vuelva a reconocer la misma idea.", class = "texto-inicio")
                    )
                )
            } else {
                x <- tagList()
            }
            x
        })
        
    })
}

inicioApp <- function(){
    ui <- fluidPage(
        inicioUI("myTestId")
    )
    server <- function(input, output, session) {
        inicioServer("myTestId")
    }
    shinyApp(ui, server)
}

# inicioApp()