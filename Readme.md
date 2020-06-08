# Readme

This repo contains an example approach of setting a R webserver with akvo auht0 authorization.
It uses a default data-science akvo email account in auth0 dev and prod envs

## Final Purpose

The target idea is to import data from lumen using this webserver. Internally the R code can also connect to flumen to get flow-lumen data, transform it and then return a new dataset. 
So the expected end is set up a new entrypoint that returns csv data so flumen can import it using the UI [[import-ui](https://github.com/akvo/akvo-data-science-docker/blob/master/docs/flumen-import-link.png), [link-ui](https://github.com/akvo/akvo-data-science-docker/blob/master/docs/flumen-import-link-url.png)]


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

In development you can use any [data](https://github.com/akvo/akvo-data-science-docker/blob/master/data/example.csv#L1) from /data folder in api.R [logic](https://github.com/akvo/akvo-data-science-docker/blob/master/api/api.R#L25), once that you're happy with the results then change static csv data with a call to flumen [api](https://github.com/akvo/akvo-data-science-docker/blob/master/api/api.R#L12-L15). [Plumber](https://www.rplumber.io/) is really easy to use, and here a simple [greeting](https://github.com/akvo/akvo-data-science-docker/blob/master/api/api.R#L28-L32) example 



## TODO 
https://github.com/akvo/akvo-data-science-docker/issues

