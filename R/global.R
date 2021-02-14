# Base de datos

db_leer_data <- function(tabla){
  conn <- RSQLite::dbConnect(RSQLite::SQLite(), "data/chimbote.db")
  data <- DBI::dbReadTable(conn, tabla)
  DBI::dbDisconnect(conn)
  data
}
