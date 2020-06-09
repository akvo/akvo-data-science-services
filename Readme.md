# Readme

This repo contains an example approach of setting a R webserver with akvo auht0 authorization.
It uses a default data-science akvo email account in auth0 dev and prod envs

## Final Purpose

The target idea is to import data from lumen using this webserver. Internally the R code can also connect to flumen to get flow-lumen data, transform it and then return a new dataset. 


So the expected end is set up a new entrypoint that returns csv data so flumen can import it using the UI 

[[file:https://github.com/akvo/akvo-data-science-services/blob/master/docs/flumen-import-link.png]],

then use the R entrypoint

[[file:https://github.com/akvo/akvo-data-science-services/blob/master/docs/flumen-import-link-url.png]]


## How to use it?

`docker-compose up --build`

once you get these 2 lines

```
auth_1  | Starting server to listen on port 8000
api_1   | Starting server to listen on port 8000
```


now you'll be able to get flumen data with this entrypoint


http://localhost:7001/lumen-dataset/<LUMEN_INSTANCE>/<DATASET_UUID>

eg: http://localhost:7001/lumen-dataset/lumen/5ebbf42e-1e52-43f5-b3fd-edd1dee86002






## workflow


You'll need an .env file with env vars in your project folder

Example auth values needed in `projects/example-lumen/.env` file 

```
AUTH_USER_PASSWORD=XXXX
AUTH_USER_EMAIL=yyyyy
AUTH_CLIENT_ID=zzzzzz
AUTH_CLIENT_PASSWORD=wwwwww
AUTH_ISSUER=qqqqqq

```


## TODO 
https://github.com/akvo/akvo-data-science-services/issues



http://akvo-data-science-example-lumen/data
