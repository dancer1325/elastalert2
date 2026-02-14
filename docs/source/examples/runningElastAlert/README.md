# how to run ElastAlert 2?
## -- as a -- Docker container
### ways to start
#### -- via -- Docker Hub
* `docker compose up -d`
* `ES_NETWORK=$(docker inspect -f '{{range $key, $value := .NetworkSettings.Networks}}{{$key}}{{end}}' elasticsearch_test)`
* 
    ```
    docker run --net=$ES_NETWORK -d --name elastalert --restart=always \
      -v $(pwd)/elastalert.yaml:/opt/elastalert/config.yaml \
      -v $(pwd)/rules:/opt/elastalert/rules \
      jertel/elastalert2 --verbose
    ```
* `docker logs -f elastalert`
#### -- via -- GitHub Container Registry
* `docker compose up -d`
* `ES_NETWORK=$(docker inspect -f '{{range $key, $value := .NetworkSettings.Networks}}{{$key}}{{end}}' elasticsearch_test)`
* 
    ```
    docker run --net=es_default -d --name elastalert --restart=always \
      -v $(pwd)/elastalert_config.yaml:/opt/elastalert/config.yaml \
      -v $(pwd)/rules:/opt/elastalert/rules \
      ghcr.io/jertel/elastalert2/elastalert2 --verbose
    ```
* `docker logs -f elastalert`

## -- as a -- Kubernetes deployment
* [here](../../../../chart/elastalert2)

## -- as a -- Python package
* `docker compose up -d`
* [download python & pip](https://www.python.org/downloads/)
* [download OpenSSL](https://openssl-library.org/source/)
  * built-in MacOs

### how to download?
* `pip list | grep elastalert2`
  * check it's installed

### how to MANUALLY create the ElastAlert2 indices?

* `curl -X GET "localhost:9200/_cat/indices?v"`
  * check that there is NO "elastalert_*" indices
* `elastalert-create-index`
  * about prompts
    * "Enter Elasticsearch host: localhost"
    * "Enter Elasticsearch port: 9200"
    * "Use SSL? t/f: f"
* `curl -X GET "localhost:9200/_cat/indices?v"`
  * check that appear "elastalert_*" indices

### how to run ElastAlert2 ?
#### -- via -- [Supervisor](http://supervisord.org/)
* TODO: 
#### -- via -- Python
* `python -m elastalert.elastalert --config elastalert_config.yaml --rule rules/rule1.yaml --verbose`
  * check "INFO:elastalert:"
#### -- via -- entry point
* `elastalert --config elastalert_config.yaml --rule rules/rule1.yaml --verbose`
  * check "INFO:elastalert:"


# how to create a rule?
* TODO:
