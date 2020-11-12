library(here)
library(httr)
library(jsonlite)
library(readr)
library(dplyr); library(tidyr)
library(reshape2)

lumen_dataset_url<- function(lumen_instance, dataset_id){
     paste0("https://", lumen_instance, ".", Sys.getenv("LUMEN_DOMAIN"), ".org/api/datasets/", dataset_id)
}

#* Function to authenticate with auth0 using default data-science auth0 account 
auth_headers <- function(){
    add_headers(Authorization = paste0("Bearer ", content(GET("http://akvo-data-science-auth:8000/id_token"))))    
}

#* Example of using/returning the lumen dataset rows
#* @serializer contentType list(type="text/plain")
#* @get /lumen-dataset/<lumen_instance>/<dataset_id>
function(lumen_instance, dataset_id){
     dataset <- GET(lumen_dataset_url(lumen_instance, dataset_id), auth_headers())
     rows <- content(dataset, as="text")
     result <- jsonlite::fromJSON(rows)
     Data <- as.data.frame(result$rows)
     names(Data) <- result$columns$title
     
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
     
     model_data <- Data 
     format_delim(model_data, delim=",")
}


#* Example of using/returning data csv 
#* @serializer contentType list(type="text/plain")
#* @get /data
function(){
    "A,B,C
a1,b1,10
a1,b1,11
a1,b2,9
a1,b2,10
a2,b1,12
a2,b1,10
a2,b2,11
a2,b2,10
"
}


#* @serializer contentType list(type="text/plain")
#* @get /demo
function(){
    "A,B, H
a1,b1,1
a1,b1,2
a1,b2,3
"
}
