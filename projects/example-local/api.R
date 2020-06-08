library(here)

#* Example of using/returning data csv from data folder
#* @get /data
function(){
    read.csv2(
        here(
            "/data/example.csv"), 
        sep=',')
}

#* Example of using plumber routing
#* @get /say-hello/<your_name>
function(your_name){
   paste0("Hello ", your_name)
}
