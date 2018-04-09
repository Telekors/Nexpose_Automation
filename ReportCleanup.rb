require 'nexpose'
require 'yaml'
include Nexpose
output = File.open("reportstodelete.csv","w")

## Variables to Configure
$settings = YAML::load_file 'settings.yml'

NexposeIP = $settings[:nexpose][:host]
NexposeUN = $settings[:nexpose][:user]
NexposePW = $settings[:nexpose][:pass]

## New Nexpose Connection -> Requirements are Device IP, Username, Password
nsc = Nexpose::Connection.new(NexposeIP, NexposeUN, NexposePW)
nsc.login

##Load all reports from nexpose console to an array and iterate through them. 
reportlist = nsc.list_reports
reportlist.each do |xray|
	begin
	if xray.generated_on == ''
		print("#{xray.name}, #{xray.generated_on},#{xray.config_id}\n")
		output << ("#{xray.name}, #{xray.generated_on},#{xray.config_id}\n")    
		report_conf = ReportConfig.load(nsc, xray.config_id)
    	puts "Loaded Report - #{report_conf.name}"
    	report_conf.delete(nsc)
	end
	rescue Nexpose::APIError => e
		puts"Failed, check output"
		output << ("#{xray.name},#{xray.generated_on},#{xray.config_id},ERROR,ERROR,ERROR\n")
	end
end
output.close

##Logout of console 
nsc.logout
