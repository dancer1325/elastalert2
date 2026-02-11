.
* _writingalerts:

# How to add a NEW Alerter?
====================

* Alerters
  * == subclasses of [`Alerter`](../../../elastalert/alerts.py)
  * how does it work?
    * if there are matches fit -> ElastAlert calls `alert()`
    * | start ElastAlert,
      * alerter is instantiated
    * ElastAlert writes back alert info | ElasticSearch
      * == information / is obtained -- through -- `get_info`
  * requirements
    * implement 2 member functions
  * how to import alert types?
    * specify the type -- as -- `pythonModuleName.pythonFileNameContainingTheAlerter.SubClassAlertName`
  * alerters trigger ordering
    * == order / defined | rule file
  * _Example:_
  
    ```python
    class AwesomeNewAlerter(Alerter):
        required_options = set(['some_config_option'])
        def alert(self, matches):
            ...
        def get_info(self):
            ...
    ```

## 's member properties

* `self.required_options`
  * == configuration options names / MUST be present
  * if any are missing -> ElastAlert 2 will NOT instantiate the alert 

* `self.rule`
  * == dictionary / 
    * contains the rule configuration
      * include alert-options specific

* `self.pipeline`
  * == dictionary /
    * transfer information BETWEEN alerts
  * | trigger an alert,
    * NEW empty pipeline object is created
    * EACH alerter can add OR receive information -- from -- the pipeline
  * _Example:_ 
    * [Jira alerter](../alerts.md#jira) add its ticket number | pipeline
    * [email alerter](../alerts.md#email) reads the pipeline /
      * if there is Jira information -> add the link | email's body

## `alert(self, match)`

* uses
  * send an alert
* `matches`
  * == list of dictionary objects /
    * contain information -- about the -- match
* if you want to get a nice string representation of the match -> call `self.rule['type'].get_match_str(match, self.rule)`
* if this method raises an exception -> 
  * caught by ElastAlert 2
  * alert is marked as unsent
  * | next iteration, retrigger it

## `get_info(self)`

* uses
  * get alert's information 
* 's return
  * dictionary / uploaded DIRECTLY | Elasticsearch
    * _Example:_ 
      * alert's type
      * alert's recipients
      * alert's parameters
      * etc.
