require 'nexpose'
require 'yaml'
require 'csv'
require 'net/smtp'
include Nexpose

## Variables to Configure
$settings = YAML::load_file 'settings.yml'

NexposeIP = $settings[:nexpose2][:host]
NexposeUN = $settings[:nexpose2][:user]
NexposePW = $settings[:nexpose2][:pass]

## New Nexpose Connection -> Requirements are Device IP, Username, Password
nsc = Nexpose::Connection.new(NexposeIP, NexposeUN, NexposePW)
nsc.login

## Open ReportsInput.csv and iterate through downloading each one. 
CSV.foreach('reportsInput.csv', {:headers => true, :encoding => "ISO-8859-15:UTF-8"}) do |row|

  puts row['Report ID']
	report_id = row['Report ID']
	report_summary = nsc.last_report(report_id)
	puts report_summary
	report = nsc.download(report_summary.uri)
	begin
		output = File.open(row['Report Name'],'w')
	rescue Errno::EACCES
		puts "The file #{row['Report Name']} is likely open."
	rescue
		puts "There is a generic error with the file output."
	else
		output << report
		output.close
	end
end
nsc.logout

##Send an notification out with a link to the dumps folder.


##Below isnt necessary for the script to run, its just here because my users wanted to know when the reports were generated. 
puts "Sending the notification email..."
message = <<MESSAGE_END
From: Nexpose <nexpose@domain.com>
To: <telekors@domain.com>,<telekors2@domain.com>
MIME-Version: 1.0
Content-type: text/html
Subject: New reports available
<b>There are new reports available at: <a href="file://locahost/temp">C:/temp/</a></b>
MESSAGE_END

Net::SMTP.start('OpenMailRealyIP') do |smtp|  #Set mail realy ip
	smtp.send_message message, telekors@domain.com', 'telekors2@domain.com'
end
puts "done"
