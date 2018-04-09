require 'nexpose'
require 'yaml'
include Nexpose


## Variables to Configure
$settings = YAML::load_file 'settings.yml'

NexposeIP = $settings[:nexpose][:host]
NexposeUN = $settings[:nexpose][:user]
NexposePW = $settings[:nexpose][:pass]

## New Nexpose Connection -> Requirements are Device IP, Username, Password
nsc = Nexpose::Connection.new(NexposeIP, NexposeUN, NexposePW)
nsc.login

##Load reports list to a variable and iterate through. 
reportlist = nsc.list_reports
reportlist.each do |xray|
	puts ("#{xray.name},#{xray.config_id}")
end

##Disconnect from console. 
nsc.logout
