* goal
  * create a NEW alert / write alerts | local output file

# steps

* | ElastAlert2 root folder, 

    ```bash
    $ mkdir elastalert_modules
    # modules folder
    
    $ cd elastalert_modules
    $ touch __init__.py
    $ touch my_alerts.py
    ```
  * Reason of creating under elastalert_modules: ElastAlert imports the alert -- via -- `from elastalert_modules.my_alerts import AwesomeNewAlerter`
  * add the code to "my_alerts.py"
* | rule configuration file
  * _Example:_ "elastalert.py"
  * specify the alert

    ```yaml
    alert: "elastalert_modules.my_alerts.AwesomeNewAlerter"
    output_file_path: "/tmp/alerts.log"
    ```

# project structure

elastalert2/                                    
  ├── config.yaml                                 
  ├── rules/                                      
  │   └── my_custom_alert_rule.yaml               
  ├── elastalert_modules/                         # == custom Python modules
  │   ├── __init__.py                             #     enable the module to be imported  
  │   └── my_alerts.py
  └── [existing files] 
