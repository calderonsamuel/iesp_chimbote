inputsPCI_UI <- function(id) {
    ns <- NS(id)
    tagList(
        add_inputs_UI(ns("add_inputs_PCI")),
        guardar_matriz_UI(ns("guardar"))
    )
}

inputsPCI_Server <- function(id) {
    moduleServer(id, function(input, output, session) {
        matriz <- readxl::read_excel("data/ali pei pci.xlsx", trim_ws = FALSE)
        
        from_imputs <- add_inputs_Server("add_inputs_PCI", 
                          choices_fila = 1:5,
                          choices_columna = c("Marco conceptual y metodológico" = "texto_conceptual",
                              "Enfoques pedagogicos" = "texto_pedagogico",
                              "Enfoques transversles del DCBN" = "texto_transversal",
                              "Principios pedagogicos" = "texto_principios",
                              "Principios metodologicos" = "texto_metodologicos",
                              "Valores institucionales" = "texto_valores",
                              "Filosofia institucional" = "texto_filosofia"))
        
        datos <- reactive({
            filas <- from_imputs()$filas
            columnas <- from_imputs()$columnas
            textos <- from_imputs()$textos
            
            for (i in seq_along(filas)) {
                filtrado_1 <- filter(matriz, numero == filas[i])
                filtrado_n <- filter(matriz, !numero == filas[i])
                
                matriz <- filtrado_1 %>% 
                    mutate(across(contains(columnas[i]),
                           ~if_else(row_number() == 1, textos[i], ""))) %>% 
                    bind_rows(filtrado_n) %>% 
                    arrange(numero)
            }
            matriz
        })
        
        guardar_matriz_Server("guardar", datos, "ali-PEI-PCI")
        
        datos
    })
}

inputsPCI_App <- function(){
    ui <- fluidPage(
        sidebarLayout(
            sidebarPanel(
                inputsPCI_UI("myTestId")
            ),
            mainPanel(
                tableOutput("tabla")
            )
        )
    )
    server <- function(input, output, session) {
        datos <- inputsPCI_Server("myTestId")
        
        output$tabla <- renderTable(datos())
    }
    shinyApp(ui, server)
}

# inputsPCI_App()
