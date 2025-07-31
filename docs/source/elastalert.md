Overview
========

* required stack
  * == data platform + ElastAlert

* ElastAlert 2's
  * design
    * [reliable](#reliability)
    * [modular](#modularity)
    * easy to setup
  * configuration
    * == configure rules /
      * 1 rule == query + rule type + set of alerts
  * alerts features
    - Alerts link -- to -- Kibana Discover searches
    - Aggregate counts | arbitrary fields
    - Combine alerts | periodic reports
    - Separate alerts -- via -- unique key field
    - Intercept & enhance match data 

* built-in
  * rule types
    - ``frequency`` type
      - if there are X events | Y time -> match 
    - ``spike`` type
      - if the rate of events increases or decreases -> match 
    - ``flatline`` type
      - if | Y time, there are < X events -> match
    - ``blacklist`` & ``whitelist`` type
      - "Match when a certain field matches a blacklist/whitelist"
    - ``any`` type
      - "Match on any event matching a given filter"
    - ``change`` type
      - "Match when a field has two different values within some time"
  * alert types
    - Alerta
    - Alertmanager
    - AWS SES (Amazon Simple Email Service)
    - AWS SNS (Amazon Simple Notification Service)
    - Chatwork
    - Command
    - Datadog
    - Debug
    - Dingtalk
    - Discord
    - Email
    - Exotel
    - Flashduty
    - Gitter
    - GoogleChat
    - Graylog GELF
    - HTTP POST
    - HTTP POST 2
    - Indexer
    - Iris
    - Jira
    - Lark
    - Line Notify
    - Matrix Hookshot
    - Mattermost
    - Microsoft Teams
    - Microsoft Power Automate
    - OpsGenie
    - PagerDuty
    - PagerTree
    - Rocket.Chat
    - Squadcast
    - ServiceNow
    - Slack
    - SMSEagle
    - Splunk On-Call (Formerly VictorOps)
    - Stomp
    - Telegram
    - Tencent SMS
    - TheHive
    - Twilio
    - Webex Incoming Webhook
    - WorkWechat  
    - Zabbix

* write your own
  * [rule types](recipes/adding_rules.md)
  * [alerts](recipes/adding_alerts.md)

* [tutorial](running_elastalert.md)

Reliability
===========

* ElastAlert 2's features / 
  * | Elasticsearch restarts or Elasticsearch unavailability, make MORE reliable
    - ElastAlert 2 saves [its state | Elasticsearch](elastalert_status.md)
      - -> | restart, will resume -- from -- PREVIOUSLY stopped
    - if Elasticsearch is unresponsive -> | TILL it recovers BEFORE continuing, ElastAlert 2 will wait 
    - alerts / throw errors,
      - | period of time, can be AUTOMATICALLY retried 

Modularity
==========

* ElastAlert 2
  * == 3 main components / may be 
    * imported -- as a -- module 
    * customized

Rule types
----------

* responsible -- for -- processing data / returned from Elasticsearch
* initialized with 
  * rule configuration
  * passed data / returned -- from -- querying Elasticsearch + rule's filters
* outputs matches -- based on -- this data
* [here](recipes/adding_rules.md)

Alerts
------

* responsible -- for -- taking action
  * based on a match

* match
  * == dictionary / 
    * contain Elasticsearch's document's values
    * may contain arbitrary data / added -- by the -- rule type
* [here](recipes/adding_alerts.md)

Enhancements
------------

* allows
  * intercepting an alert
  * modifying or enhancing an alert
* how does it work?
  * BEFORE given to the alerter, pass the match dictionary
* [here](recipes/adding_enhancements.md)
