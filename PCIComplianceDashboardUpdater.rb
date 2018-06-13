require 'RubyXL'
require 'csv'
require 'time'
require 'nexpose'
require 'csv'
require 'yaml'
include Nexpose

$settings = YAML::load_file 'settings.yml'

NexposeIP = $settings[:nexpose][:host]
NexposeUN = $settings[:nexpose][:user]
NexposePW = $settings[:nexpose][:pass]

sleep 1

#begin

	# Create a connection to the NeXpose instance
	nsc = Nexpose::Connection.new(NexposeIP, NexposeUN, NexposePW)
puts "logging in to Nexpose..."

	# Authenticate to this instance (throws an exception if this fails)
  begin 
nsc.login
  rescue 
    puts "Connection Lost, Reconnecting"
        nsc.login
        report_summary = nsc.last_report(report_id)
  rescue 
    "a random error occured"
  end 
#Download and save report by ID
t = Time.now
date = "#{t.month}-#{t.day}-#{t.year}"
reportID = 80
reportSummary = nsc.last_report(reportID)
puts "downloading report #{reportID}"
sleep 1
begin 
report = nsc.download(reportSummary.uri)
filename = 'report' + date + '.csv'
output = File.open(filename, 'w')
output << report 
output.close
rescue Errno::EACCES
  puts "File is opened by *someone"
rescue  
  puts "There appears to be an error of some sort"
 end

puts "logging out..."
nsc.logout

#create Dynamic File Name(must be ran on different days to be dynamic otherwise will overwrite file)

input_file = 'L:\SECURITY\PCI_Dashboard\DashboardFiles\DownloadedReports\report.csv'
output_file = 'L:\SECURITY\PCI_Dashboard\DashboardFiles\Dashboard\PCIDashboard-' + date + '.xlsx'

		#parses excel doc and selects worksheet to be overwritten
	  puts 'parsing dashboard...'
      workbook = RubyXL::Parser.parse("PCIDashboardV4.0.8.xlsx")
      worksheet = workbook[1]

      puts 'conversion in process...'
      options = {:encoding => 'bom|UTF-8', :skip_blanks => true, converters: :numeric}
      #doing magic with the CSV file
      CSV.foreach(input_file, options).each_with_index do |row, row_idx|
        # http://stackoverflow.com/questions/12407035/ruby-csv-get-current-line-row-number
        row.each_with_index do |item, index|
          worksheet.add_cell row_idx, index, item

          #used to find the 8th column and delete "days" from the string and then convert the string to an integer
          	if index == 7 && row_idx != 0 
          		worksheet.add_cell row_idx, index, item.gsub!(/\D/, "").to_i
          	else
          		worksheet.add_cell row_idx, index, item
          	end
        end      
    end

  begin
      puts 'saving as a new file...'
       workbook.write output_file
  rescue Errno::EACCES
  	puts "The file #{'output_file'} is open"
  rescue 
    puts "There appears to be an error :-("
  end
      puts 'saved!'
      sleep 1
