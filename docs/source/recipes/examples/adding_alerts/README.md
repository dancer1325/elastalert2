* goal
  * create a NEW alert / write alerts | local output file

# steps

* | ElastAlert 2 folder 

    ```bash
    $ mkdir elastalert_modules
    # modules folder
    
    $ cd elastalert_modules
    $ touch __init__.py
    $ touch my_alerts.py
    ```
  * Reason of creating under elastalert_modules: ElastAlert imports the alert -- via -- `from elastalert_modules.my_alerts import AwesomeNewAlerter`
* | rule configuration file
  * _Example:_ "elastalert.py"
  * specify the alert

    ```yaml
    alert: "elastalert_modules.my_alerts.AwesomeNewAlerter"
    output_file_path: "/tmp/alerts.log"
    ```

# project structure

elastalert2/                          
├── elastalert_modules/               # == Python module
│   ├── __init__.py                   # make the module / can be imported
│   └── my_alerts.py                  
└── elastalert.py                     
