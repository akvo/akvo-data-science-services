library(httr)

user_password <- Sys.getenv("AUTH_USER_PASSWORD")
user_email <- Sys.getenv("AUTH_USER_EMAIL")

auth_client_id <- Sys.getenv("AUTH_CLIENT_ID")
auth_client_password <- Sys.getenv("AUTH_CLIENT_PASSWORD")

issuer <- Sys.getenv("AUTH_ISSUER")

token_url_api <- paste0(issuer, "oauth/token")
auth_audience <- paste0(issuer, "api/v2/")


#* @get /id_token
function(){
    r <- POST(token_url_api, body = list(client_id = auth_client_id, client_secret = auth_client_password, scope = "openid profile email", audience = auth_audience, grant_type = "password", password = user_password, username = user_email), encode = "json")

    content(r)$id_token
    
}
