my_compose_single <- function(x, color_data, shading_col, color_col, i = NULL, j = NULL) {
    names <- names(color_data)
    color_data <- color_data[i,] # sólo se usa una fila a la vez
    
    # Los iteradores son nombres de columnas
    # siguiendo la API de fp_text
    texto <- names[str_detect(names, j)]
    shading_iterator <- names[str_detect(names, shading_col)]
    color_iterator <- names[str_detect(names, color_col)]
    args_list <- list(texto, shading_iterator, color_iterator)
    
    # chunks contiene todo el contenido de una celda
    chunks <- pmap(
        .l = args_list,
        .f = function(texto, shading, color) {
            texto <- color_data[[texto]]
            shading <- replace_na(color_data[[shading]], "NA")
            color <- replace_na(color_data[[color]], "black")
            as_chunk(
                x = texto, 
                props = fp_text(
                    shading = shading,
                    color = color
                )
            )
        }
    )
    
    # juntamos todos los chunks en un solo paragraph
    my_paragraph <- do.call(as_paragraph, chunks)
    
    # se aplica el compose
    flextable::compose(
        x = x,
        i = i,
        j = j, 
        value = my_paragraph
    )
}

my_compose_full <- function(x, color_data, shading_col, color_col, j = NULL) {
    for (i in seq_len(nrow(color_data))) {
        x <- my_compose_single(x, color_data, shading_col, color_col, i = i, j = j)
    }
    x
}

compose_quick <- function(x, color_data, variable) {
    my_compose_full(x = x, 
                    color_data = color_data,
                    shading_col = glue::glue("shading_{variable}"),
                    color_col = glue::glue("color_{variable}"),
                    j = glue::glue("texto_{variable}"))
}

compose_quick_all <- function(x, color_data, variables) {
    for (variable in variables) {
        x <- compose_quick(x, color_data, variable)
    }
    x
}

pivot_color <- function(.data, .var) {
    .data %>% 
        group_by({{.var}}) %>%
        mutate(orden = row_number()) %>%
        ungroup() %>%
        pivot_wider(
            names_from = orden,
            values_from = contains(c("texto", "shading", "color")))
}
