add_inputs_UI <- function(id) {
    ns <- NS(id)
    tagList(
        numericInput(ns("cantidad"), "Cantidad de modificaciones", 
                     value = 1, min = 1),
        uiOutput(ns("inputs"))
    )
}

add_inputs_Server <- function(id, choices_fila, choices_columna) {
    moduleServer(id, function(input, output, session) {
        seq_cantidad <- reactive(seq_len(input$cantidad))
        filas_id <- reactive(paste0("fila_", seq_cantidad()))
        columnas_id <- reactive(paste0("columna_", seq_cantidad()))
        textos_id <- reactive(paste0("texto_", seq_cantidad()))
        
        output$inputs <- renderUI({
            
            validate(need(seq_cantidad(), message = "Cantidad sin determinar"))
            ns <- session$ns
            
            # esta función genera dos selectInput seguidos de un textAreaInput
            inputs_fun <- function(fila_id, columna_id, texto_id) {
                tagList(
                    wellPanel(
                        fluidRow(
                            splitLayout(
                                selectInput(
                                    inputId = ns(fila_id),
                                    label =  "Fila",
                                    choices = choices_fila,
                                    selected = isolate(input[[fila_id]])
                                ),
                                selectInput(
                                    inputId = ns(columna_id),
                                    label = "Columna",
                                    choices = choices_columna,
                                    selected = isolate(input[[columna_id]])
                                )
                            )
                        ),
                        textAreaInput(
                            inputId = ns(texto_id), 
                            label = NULL, 
                            placeholder = "Ingresa el texto",
                            value = isolate(input[[texto_id]])
                        )
                    )
                )
            }
            
            # se obtienen inputs segun se pida en input$cantidad
            pmap(list(filas_id(), columnas_id(), textos_id()), inputs_fun)
            
        })
        
        # el output del modulo es todo lo recogido en formato tibble
        reactive({
            filas <- map_chr(filas_id(), ~input[[.x]])
            columnas <- map_chr(columnas_id(), ~input[[.x]])
            textos <- map_chr(textos_id(), ~input[[.x]])
            tibble(filas, columnas, textos)
        })
    })
}

add_inputs_App <- function(){
    choices_fila <- as.character(1:6)
    choices_columna <- as.character(1:6)
    
    ui <- fluidPage(
        # splitlayout no permite ver las opciones en selectinput
        # se solucionó con css personalizado para aplicativo general
        sidebarLayout(
            sidebarPanel(
                add_inputs_UI("myTestId")
            ),
            mainPanel(
                tableOutput("tabla")
            )
        )
    )
    server <- function(input, output, session) {
        datos <- add_inputs_Server("myTestId", choices_fila, choices_columna)
        output$tabla <- renderTable(datos())
    }
    shinyApp(ui, server)
}

# add_inputs_App()
