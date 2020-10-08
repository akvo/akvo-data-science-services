library(here)
library(httr)

#* Function to authenticate with auth0 using default data-science auth0 account 
auth_headers <- function(){
    add_headers(Authorization = paste0("Bearer ", content(GET("http://akvo-data-science-auth:8000/id_token"))))    
}

#* Example of using/returning the lumen dataset rows
#* @serializer contentType list(type="text/plain")
#* @get /lumen-dataset/<lumen_instance>/<dataset_id>
function(lumen_instance, dataset_id){
    ## lumen_domain <- "akvotest"
    ## flumen_url <- paste0("https://", lumen_instance, ".", lumen_domain, ".org/api/datasets/", dataset_id)
    ## dataset <- GET(flumen_url, auth_headers())
    ## content(dataset)$rows
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
