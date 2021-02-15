library(shiny)
library(tidyverse)
library(flextable)
library(officer)
library(glue)
library(shinymanager)

credentials <- data.frame(
    user = c("director"), # mandatory
    password = c("director") # mandatory
)

# my_theme <- bslib::bs_theme(bootswatch = "journal", version = 3)
# sass::sass(my_theme, output = "www/mytheme.css")

ui <- tagList(
    tags$head(
        tags$link(rel = "stylesheet", type = "text/css", href = "mystyles.css")
    ),
    navbarPage(
        title = "Matrices IESPP Chimbote",
        theme = shinythemes::shinytheme("journal"),
        
        tabPanel(
              title = icon("home"),
              inicioUI("inicio")
        ),
        
        tabPanel(
            title = "Alineamiento PEI PEN",
            default_page_UI(
                table_sidebar(
                    h3("MATRIZ DE ALINEAMIENTO DEL PROYECTO EDUCATIVO INSTITUCIONAL 
                       CON EL PROYECTO EDUCATIVO NACIONAL Y REGIONAL"),
                    p("Esta matriz alinea objetivos y líneas estratégicos 
                      de la institución con los componentes de la gestión institucional, 
                      Proyecto Educativo Nacional y Proyecto Educativo Regional. 
                      Este análisis permite establecer propuestas de mejora para los objetivos 
                      y líneas estratégicos, de tal manera que sean realmente coherentes 
                      con los componentes de gestión y los proyectos educativos. ")
                ),
                table_main(
                    aliPEI_PEN_UI("aliPEI_PEN")
                ),
                edit_sidebar(
                    inputs_PEI_PEN_UI("inputs_PEI_PEN")
                ),
                edit_main(
                    aliPEI_PEN_UI("aliPEI_PEN_edit")
                )
            )
        ),
        
        tabPanel(
            title = "Alineamiento PEI PAT",
            default_page_UI(
                table_sidebar(
                    tags$h3("MATRIZ DE ALINEAMIENTO DEL PROYECTO EDUCATIVO 
                            INSTITUCIONAL CON EL PLAN ANUAL DE TRABAJO "),
                    tags$p("Esta matriz alinea las actividades e indicadores 
                           del Plan Anual de Trabajo con los objetivos y 
                           líneas estratégicos del Proyecto Educativo Institucional. 
                           Este análisis permite reformular, mediante propuestas 
                           de mejora, las actividades e indicadores de la institución, 
                           de tal manera que realmente contribuyan al logro 
                           de los objetivos y metas priorizados para el año académico")
                ),
                table_main(
                    aliPEI_PATUI("aliPEI_PAT")
                ),
                edit_sidebar(
                    inputs_PAT_UI("inputs_PAT")
                ),
                edit_main(
                    aliPEI_PATUI("aliPEI_PAT_edit")
                )
            )
        ),
        
        tabPanel(
            title = "Alineamiento PEI PCI",
            default_page_UI(
                table_sidebar(
                    tags$h3("MATRIZ DE ALINEAMIENTO DEL PROYECTO EDUCATIVO 
                            INSTITUCIONAL CON EL PROYECTO CURRICULAR INSTITUCIONAL"),
                    tags$p("Esta matriz alinea el marco conceptual y metodológico 
                           del Proyecto Educativo Institucional con la 
                           fundamentación de los principios y enfoques 
                           pedagógicos del Proyecto Curricular Institucional. 
                           Este análisis permite garantizar la consistencia de 
                           la propuesta pedagógica de la institución, la cual 
                           debe verse reflejada en cada componente del PCI.")
                ),
                table_main(
                    aliPEI_PCI_UI("aliPEI_PCI_fijo")
                ),
                edit_sidebar(
                    inputsPCI_UI("inputsPCI")
                ),
                edit_main(
                    aliPEI_PCI_UI("aliPEI_PCI_edit")
                )
            )
        ),
        
        tabPanel(
            title = "Lista de cotejo",
            default_page_UI(
                table_sidebar(
                    tags$h3("LISTA DE COTEJO PARA EL ALINEAMIENTO ENTRE EL 
                            REGLAMENTO INSTITUCIONAL Y EL MANUAL DE PROCESOS ACADÉMICOS"),
                    tags$p("Esta matriz verifica la inclusión de todos los 
                           procesos de gestión académica del Reglamento Interno 
                           en el Manual de Procesos Académicos de la institución. 
                           Este análisis permite identificar los documentos que 
                           faltan incluirse en el Manual de Procesos Académicos,
                           para luego plantear estrategias para su elaboración")
                ),
                table_main(
                    lista_cotejoUI("lista_cotejo")
                ),
                edit_sidebar(
                    inputs_lista_cotejo_UI("inputs_lista_cotejo")
                ),
                edit_main(
                    lista_cotejoUI("lista_cotejo_edit")
                )
            )
        )
    )  
)

ui <- secure_app(ui,
                 theme = shinythemes::shinytheme("darkly"))

server <- function(input, output, session) {
    
    # call the server part
    # check_credentials returns a function to authenticate users
    res_auth <- secure_server(
        check_credentials = check_credentials(credentials)
    )
    
    output$auth_output <- renderPrint({
        reactiveValuesToList(res_auth)
    })
    
    inicioServer("inicio")
    
    data_PEI_PEN <- inputs_PEI_PEN_Server("inputs_PEI_PEN")
    
    aliPEI_PEN_Server("aliPEI_PEN")
    
    aliPEI_PEN_Server("aliPEI_PEN_edit")
    
    aliPEI_PATServer("aliPEI_PAT")
    inputs_PAT_Server("inputs_PAT")
    aliPEI_PATServer("aliPEI_PAT_edit")
    
    aliPEI_PCI_Server("aliPEI_PCI_fijo", reactive(readxl::read_excel("data/ali pei pci.xlsx")))
    
    dataPCI <- inputsPCI_Server("inputsPCI")
    
    aliPEI_PCI_Server("aliPEI_PCI_edit", dataPCI)
    
    lista_cotejoServer("lista_cotejo")
    inputs_lista_cotejo_Server("inputs_lista_cotejo")
    lista_cotejoServer("lista_cotejo_edit")
    
}

shinyApp(ui, server)