# Base de datos

db_leer_data <- function(tabla){
  conn <- RSQLite::dbConnect(RSQLite::SQLite(), "data/chimbote.db")
  data <- DBI::dbReadTable(conn, tabla)
  DBI::dbDisconnect(conn)
  data
}

# Etiquetas de lenguaje para shinymanager
shinymanager::set_labels(
    language = "en",
    "Please authenticate" = "Introducir credenciales",
    "Username:" = "Usuario:",
    "Password:" = "Clave:",
    "Login" = "Ingresar"
)