table_sidebar <- function(...) tagList(...)
table_main <- function(...) tagList(...)
edit_sidebar <- function(...) tagList(...)
edit_main <- function(...) tagList(...)


default_page_UI <- function(#id, 
                            table_sidebar = tagList(), 
                            table_main = tagList(),
                            edit_sidebar = tagList(),
                            edit_main = tagList()) {
    # ns <- NS(id)
    tagList(
        tabsetPanel(
            tabPanel(
                title = icon("table"),
                sidebarLayout(
                    position = "right",
                    sidebarPanel(
                        width = 3,
                        table_sidebar
                    ),
                    mainPanel(
                        class = "panelconscroll",
                        width = 9,
                        table_main
                    )
                )
            ),
            tabPanel(
                title = icon("edit"),
                sidebarLayout(
                    position = "right",
                    sidebarPanel(
                        width = 3,
                        edit_sidebar
                    ),
                    mainPanel(
                        class = "panelconscroll",
                        width = 9,
                        edit_main
                    )
                )
            )
        )
    )
}

default_page_Server <- function(id) {
    moduleServer(id, function(input, output, session) {
        
    })
}

default_page_App <- function(){
    ui <- fluidPage(
        default_page_UI()
    )
    server <- function(input, output, session) {
        # default_page_Server("myTestId")
    }
    shinyApp(ui, server)
}

# default_page_App()
