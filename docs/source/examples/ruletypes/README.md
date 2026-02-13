# TODO:
* TODO:

# How to test your rule?
* requirements
  - Docker
  - Docker Compose
  - curl 
## `elastalert ... --debug`
* TODO:
## `elastalert-test-rule`
* structure
    ```
    ruletypes/
    ├── docker-compose.yaml          # Docker Compose configuration
    ├── elastalert_config.yaml       # ElastAlert2 configuration
    ├── populate_test_data.sh        # Script to populate test data
    ├── rules/
    │   └── rule1.yaml              # Example rule to test
    ```
* steps
  * `docker compose up -d elasticsearch kibana`
    * start Elasticsearch & Kibana
  * `./populate_test_data.sh`
    * create 5 test documents | `logs-test` index
  * `docker compose up elastalert_test`
    * check the message 
      * "Got ..."
      * "Available terms .."
      * `alert_text` == "An ERROR log was detected"

# Notes
## how to view | Kibana?
* steps
  * http://localhost:5601
  * Management > Stack Management > Index Patterns
  * create index pattern: `logs-test`
  * Discover
