library(here)
library(httr)

#* Function to authenticate with auth0 using default data-science auth0 account 
auth_headers <- function(){
    add_headers(Authorization = paste0("Bearer ", content(GET("http://akvo-data-science-auth:8000/id_token"))))    
}

#* Example of using/returning the lumen dataset rows
#* @get /lumen-dataset/<lumen_instance>/<dataset_id>
function(lumen_instance, dataset_id){
    lumen_domain <- "akvotest"
    flumen_url <- paste0("https://", lumen_instance, ".", lumen_domain, ".org/api/datasets/", dataset_id)
    dataset <- GET(flumen_url, auth_headers())
    content(dataset)$rows
}
