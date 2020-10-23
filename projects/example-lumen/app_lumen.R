
library(shiny); library(leaflet); library(RColorBrewer)
library(here)
library(dplyr); library(tidyr)
library(reshape2)
library(htmltools); library(shinydashboard)
library(httr); library(jsonlite); library(purrr); library(data.table); library(jsonlite)

# DEVELOPMENT

# model_data <- read.csv2(
#   here(
#     # "Predictive_Maintenance_dev",
#     "prediction_model_output.csv"), 
#   sep=',')

# JSON FORMAT

# BEGINS USER AUTHENTICATION (we just need an id_token from auth0) 

# this should be a system environemnt 
client_secret_value <- "g21YQsQmgdVmETTIF54ILJwV5T34Irzc30n8VIYVKcn_hsIhdj9RmUmhmX9PeDYf"

# the user needs to have rights on the lumen tenant instance that needs to be accessed
user_password <- "Hello1234@"
user_email <- "juan@akvo.org"

r <- POST("https://akvofoundation.eu.auth0.com/oauth/token", 
          body = list(client_id = "KOgRM2Uam6FXOZdwKs3AKU7I8VtGKsiu", 
                      client_secret = client_secret_value, 
                      scope = "openid profile email", 
                      audience = "https://akvofoundation.eu.auth0.com/api/v2/", 
                      grant_type = "password", 
                      password = user_password, 
                      username = user_email), encode = "json")

id_token <- content(r)$id_token

# ENDS USER AUTHENTICATION


# BEGINS loading data from lumen instance 

# define lumen instance that we want to work with it
lumen_instance <- "akvointernal"

# https://akvointernal.akvolumen.org/dataset/5ea2bcbd-34df-4cfa-9c80-09d3907cf7f7

# the lumen dataset id, you can get it from lumen url. e.g: https://demo.akvolumen.org/dataset/5e998bb6-fd5c-4408-a5dc-5314589e9d08
dataset_id <- "5ea2bcbd-34df-4cfa-9c80-09d3907cf7f7"

dataset <- GET(paste0("https://", lumen_instance, ".akvolumen.org/api/datasets/", dataset_id),
               add_headers(Authorization = paste0("Bearer ", id_token)))

# Give the input file name to the function. 
result <- jsonlite::fromJSON(content(dataset, as="text"))

# Print the result. 
Data <- as.data.frame(result$rows)
names(Data) <- result$columns$title

# Try to get the first element of each row in the json_dataset list
# https://stackoverflow.com/questions/36454638/how-can-i-convert-json-to-data-frame-in-r

# ENDS loading data from lumen instance 

# Links related:
# - https://cran.r-project.org/web/packages/httr/vignettes/quickstart.html

model_data <- Data %>% 
  select(longitude, latitude, build_year, target_audience, region,
         prediction, `prediction in 1 year`, `prediction in 3 years`,
         photo) %>%
  mutate(longitude = as.numeric(as.character(longitude))) %>%
  mutate(latitude = as.numeric(as.character(latitude))) %>%
  mutate(build_year = as.numeric(build_year)) %>% 
  rename(`current status` = prediction,
         `status in one year` = `prediction in 1 year`,
         `status in three years` = `prediction in 3 years`) %>%
  gather("prediction", "functionality", 
         `current status`, `status in one year`, `status in three years`)

col1 <- colorRampPalette(c("red", "yellow", "#03AD8C"))
pal <- colorFactor(col1(4),
                   domain = unique(model_data$functionality))

ui <- dashboardPage(
  
  dashboardHeader(title = "Predictive Maintenance"),
  
  dashboardSidebar(
    
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "styles.css")
    ),
    
    selectInput(
      "prediction", 
      "Valeurs prédites",
      c("Statut au moment de la collecte des données" = "current status",
        "Statut prévu un an après la collecte des données" = "status in one year",
        "Statut prévu trois ans après la collecte des données" = "status in three years")),
    
    selectInput(
      "target_audience", 
      "Public cible",
      c("Public" = "public",
        "Scolaire" = "scolaire",
        "Santé" = "santé",
        "Agriculture - elevage" = "agriculture - elevage",
        "Domaine public" = "domaine public",
        "Industrie" = "industrie",
        "Administration" = "administration",
        "Infrastructure scolaire" = "infrastructure scolaire",
        "Infrastructure de santé" = "infrastructure de santé")),
    
    checkboxGroupInput("status", "État du puits d'eau:",
                       c("Fonctionnel" = "fonctionnel",
                         "En panne" = "en panne"))),
  
  dashboardBody(
    
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "styles.css")
    ),
    
    leafletOutput("map")
    
    # plotOutput("mpgPlot", height = "300px")
  )
)


server <- function(input, output, session) {
  
  # Reactive expression for the data subsetted to what the user selected
  filteredData <- reactive({
    
    model_data %>% 
      filter(functionality %in% input$status, 
             prediction %in% input$prediction,
             target_audience %in% input$target_audience)
  })
  
  
  # Use leaflet() here, and only include aspects of the map that
  # won't need to change dynamically (at least, not unless the
  # entire map is being torn down and recreated).
  output$map <- renderLeaflet({
    leaflet(model_data) %>% 
      addTiles() %>%
      fitBounds(~min(longitude) -2, ~min(latitude)-2, ~max(longitude)+2, ~max(latitude)+2) 
  })
  

  # Incremental changes to the map (in this case, replacing the
  # circles when a new color is chosen) should be performed in
  # an observer. Each independent set of things that can change
  # should be managed in its own observer.
  observe({
    leafletProxy("map", data = filteredData()) %>%
      addCircleMarkers(
        radius = 2,
        color = ~pal(functionality),
        fillOpacity = 0.5,
        popup = ~paste("<img src = ", photo, " width = 300>",
                       "Ce point d'eau est ", functionality, "<br>",
                       "ce point d'eau a été construit en ", build_year, "<br>"))
  })
  
  
}

shinyApp(ui, server)

# rsconnect::deployApp('/Users/carmenwolvius/Documents/akvo-data-science/Mali/Predictive_Maintenance_dev')

######### IMPORT

# Back to Lumen though link feature -> input should be one string "A,B,C, 1,2,3, 4,5,6"

output_csv <- format_delim(model_data, delim=",")
