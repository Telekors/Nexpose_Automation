# Nexpose_Automation

Please note that the following scripts are written for the nexpose 2.0 API and leverage the Nexpose Gem owned by Rapid7: https://github.com/rapid7/nexpose-client. The idea for settings.yml and various AssetCleanup scripts came from me seeing them in the wild, so I took that idea and am running with it. If you are the original creator please let me know so I can give you credit because you are AWESOME!!!


These small scripts are designed to aide in the administraton of the Nexpose Vulnerability Scanner:

* settings.yml - Used as a settings file to store credentials, ports, and ip addresses of the server you are working with. 
* AssetClenaup.rb - This asset will delete all the assets belonging to a specific asset group
* ListReports.rb - Outputs a list of all the reports to the command line.
* ReportsCleanup.rb - Deletes reports that are created but have never been ran. 
* DownloadReports.rb - Downloads the list of remports from reportsInput.csv and outputs them to the specified file, emails when completed. (Use this in conjunction with ListReports.rb to get a proper list of reports)
