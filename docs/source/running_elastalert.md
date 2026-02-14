# how to run ElastAlert 2?
  * as [docker container](#as-a-docker-container)
    * 👀if you do NOT want to modify the ElastAlert 2's internals -> recommended option👀 
  * | [your machine](#as-a-python-package)

## -- as a -- Docker container

* pre-built elastalert2 Docker container image
  * find | 
    * [DockerHub](https://hub.docker.com/r/jertel/elastalert2)
    * [GitHub Container Registry](https://github.com/jertel/elastalert2/pkgs/container/elastalert2%2Felastalert2)
      * 👀if you are running into Docker Hub usage limits -> recommended option👀
  * "latest" tag == latest commit | master branch

* requirements
  * start up Elasticsearch container
  * | container startup, 
    * mount
      * "config.yaml"   
        * [template](/examples/config.yaml.example)
      * "rule/"
        * == directory / contains "ruleFiles.yaml"
        * _Example:_ [here](/examples/rules)
      * _Example of structure:_ [here](/examples/volumeToMountInContainerStartup)

  * Elasticsearch container & ElastAlert2 container use the default Docker network -- `es_default` --

### how to build the image?

* | root path,
  * `docker build . -t elastalert2`
    * == use [Dockerfile](../../Dockerfile)
  * `docker image list`
    * check you find it

### ways to start
#### -- via -- Docker Hub

* `ES_NETWORK=$(docker inspect -f '{{range $key, $value := .NetworkSettings.Networks}}{{$key}}{{end}}' <ELASTICSEARCH_CONTAINER_NAME_OR_ID>)`
  * get ES' network
* 
    ```
    docker run --net=$ES_NETWORK -d --name elastalert --restart=always \
      -v $(pwd)/elastalert_config.yaml:/opt/elastalert/config.yaml \
      -v $(pwd)/rules:/opt/elastalert/rules \
      jertel/elastalert2 --verbose
    ```

#### -- via -- GitHub Container Registry
* `ES_NETWORK=$(docker inspect -f '{{range $key, $value := .NetworkSettings.Networks}}{{$key}}{{end}}' <ELASTICSEARCH_CONTAINER_NAME_OR_ID>)`
  * get ES' network
* 
    ```
    docker run --net=es_default -d --name elastalert --restart=always \
    -v $(pwd)/elastalert_config.yaml:/opt/elastalert/config.yaml \
    -v $(pwd)/rules:/opt/elastalert/rules \
    ghcr.io/jertel/elastalert2/elastalert2 --verbose
    ```

## -- as a -- Kubernetes deployment

* ways
  * -- via -- creating MANUALLY the Kubernetes manifests & use image: elastalert2
  * -- via -- [helm chart](../../chart)

## -- as a -- Python package

* audience
  * advanced users

### requirements

* Elasticsearch 7, 8, or 9 OR OpenSearch 1, 2, or 3
* ISO8601 OR Unix timestamped data
* Python 3.13
* OpenSSL v3.0.8+
* pip
* | 
  * Ubuntu 24.04: build-essential python3-pip python3.13 python3.13-dev libffi-dev libssl-dev
  * CentOS: install python 3.13 -- from the -- source code

### how to download?

* ways
  * -- via -- `pip install elastalert2`
  * -- from -- source code

    ```bash
    $ git clone https://github.com/jertel/elastalert2.git
    $ pip install -r requirements.txt
    $ pip install "setuptools>=11.3"
    $ python setup.py install
    ```

### how to MANUALLY create the ES's indices ElastAlert2-related?

* if you run ElastAlert2  
  * -- as a -- container -> AUTOMATICALLY uses it
  * -- as a -- python package -> run `elastalert-create-index`
    * ⚠️MANDATORY to run MANUALLY ⚠️

* [MORE](elastalert_status.md) 

### how to run ElastAlert2 ?

* ways
  * -- via -- [Supervisor](http://supervisord.org/)
    * TODO: 
  * -- via -- Python
    ```bash
    python -m elastalert.elastalert --config examples/config.yaml --rule examples/rules/example_frequency.yaml --verbose
    ```
  * -- via -- entry point
    ```bash
    elastalert --config examples/config.yaml --rule examples/rules/example_frequency.yaml --verbose
    ```

# how to create a rule?

* rule
  * == query to perform + parameters | trigger a match + alerts to fire / EACH match
  * _Example:_ ["example_frequency.yaml"](/examples/rules/example_frequency.yaml)
  * POSSIBLE fields -- to -- specify
    * `es_host` & `es_port`
      * == Elasticsearch cluster / we want to query
    * `name`
      * this rule's unique name 
      * ❌if 2 rules have the SAME name -> ElastAlert 2 will NOT start❌
    * `type`
      * DIFFERENT typeS / EACH rule
      * can take DIFFERENT parameters
      * built-in
        * `frequency` type
          * if there are > `num_events` | `timeframe` -> match
        * [list](ruletypes.md)
    * `index`
      * == index(es)' name -- to -- query
      * if you are using Logstash -> by default,`"logstash-*"`
    * `num_events`
      * ⚠️requirements⚠️
        * `frequency` type
        * `num_events`
      * == threshold | alert is triggered
    * `timeframe`
      * == time period | `num_events` MUST occur
    * `filter`
      * == list of Elasticsearch filters / filter results
        * ⚠️if you do NOT need it -> set `filter: []`⚠️
      * [here](recipes/writing_filters.md)
    * `alert`
      * == list of alerts / run | EACH match
      * [alert types](alerts.md#alert-types)
      * The email alert requires an SMTP server
for sending mail
* By default, it will attempt to use localhost
* This can be
changed with the ``smtp_host`` option.

``email`` is a list of addresses to which alerts will be sent.

There are many other optional configuration options, see :ref:`Common
configuration options <commonconfig>`.

All documents must have a timestamp field
* ElastAlert 2 will try to use
``@timestamp`` by default, but this can be changed with the ``timestamp_field``
option
* By default, ElastAlert 2 uses ISO8601 timestamps, though unix timestamps
are supported by setting ``timestamp_type``.

As is, this rule means "Send an email to elastalert@example.com when there are
more than 50 documents with ``some_field == some_value`` within a 4 hour
period."

See :ref:`the testing section for more details <testing>` on how to test a specific rule file without sending alerts.

# Operational Review

When ElastAlert 2 starts and output is configured to be sent to the console, it will resemble the following::

    No handlers could be found for logger "Elasticsearch"
    INFO:root:Queried rule Example rule from 1-15 14:22 PST to 1-15 15:07 PST: 5 hits
    INFO:Elasticsearch:POST http://elasticsearch.example.com:14900/elastalert_status/elastalert_status?op_type=create [status:201 request:0.025s]
    INFO:root:Ran Example rule from 1-15 14:22 PST to 1-15 15:07 PST: 5 query hits (0 already seen), 0 matches, 0 alerts sent
    INFO:root:Sleeping for 297 seconds

Let's break down the response to see what's happening.

``Queried rule Example rule from 1-15 14:22 PST to 1-15 15:07 PST: 5 hits``

ElastAlert 2 periodically queries the most recent ``buffer_time`` (default 45
minutes) for data matching the filters
* Here we see that it matched 5 hits:

.
* code-block::

    POST http://elasticsearch.example.com:14900/elastalert_status/elastalert_status?op_type=create [status:201 request:0.025s]

This line showing that ElastAlert 2 uploaded a document to the elastalert_status
index with information about the query it just made:

.
* code-block::

    Ran Example rule from 1-15 14:22 PST to 1-15 15:07 PST: 5 query hits (0 already seen), 0 matches, 0 alerts sent

The line means ElastAlert 2 has finished processing the rule
* For large time
periods, sometimes multiple queries may be run, but their data will be processed
together
* ``query hits`` is the number of documents that are downloaded from
Elasticsearch, ``already seen`` refers to documents that were already counted in
a previous overlapping query and will be ignored, ``matches`` is the number of
matches the rule type outputted, and ``alerts sent`` is the number of alerts
actually sent
* This may differ from ``matches`` because of options like
``realert`` and ``aggregation`` or because of an error.

``Sleeping for 297 seconds``

The default ``run_every`` is 5 minutes, meaning ElastAlert 2 will sleep until 5
minutes have elapsed from the last cycle before running queries for each rule
again with time ranges shifted forward 5 minutes.

Say, over the next 297 seconds, 46 more matching documents were added to
Elasticsearch::


    INFO:root:Queried rule Example rule from 1-15 14:27 PST to 1-15 15:12 PST: 51 hits
    ...
    INFO:root:Sent email to ['elastalert@example.com']
    ...
    INFO:root:Ran Example rule from 1-15 14:27 PST to 1-15 15:12 PST: 51 query hits, 1 matches, 1 alerts sent

The body of the email will contain something like::

    Example rule

    At least 50 events occurred between 1-15 11:12 PST and 1-15 15:12 PST

    @timestamp: 2015-01-15T15:12:00-08:00

If an error occurred, such as an unreachable SMTP server, you may see:

.
* code-block::

    ERROR:root:Error while running alert email: Error connecting to SMTP host: [Errno 61] Connection refused


Note that if you stop ElastAlert 2 and then run it again later, it will look up
``elastalert_status`` and begin querying at the end time of the last query
* This
is to prevent duplication or skipping of alerts if ElastAlert 2 is restarted.

By using the ``--debug`` flag instead of ``--verbose``, the body of email will
instead be logged and the email will not be sent
* In addition, the queries will
not be saved to ``elastalert_status``.

# Disabling a Rule

To stop a rule from executing, add or adjust the `is_enabled` option inside the
rule's YAML file to `false`
* When ElastAlert 2 reloads the rules it will detect
that the rule has been disabled and prevent it from executing
* The rule reload
interval defaults to 5 minutes but can be adjusted via the `run_every`
configuration option.

Optionally, once a rule has been disabled it is safe to remove the rule file, if
there is no intention of re-activating the rule
* However, be aware that removing
a rule file without first disabling it will _not_ disable the rule!

