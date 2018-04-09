require 'nexpose'
require 'yaml'
include Nexpose

## Put time connected to console (This function can be disabled its just there for comfort)
puts "Production Console: #{Time.now.strftime("%d/%m/%Y %H:%M")}"

## Set $settings variable to config file
$settings = YAML::load_file 'settings.yml'

## Reference the config file 'settings.yml'
NexposeIP = $settings[:nexpose][:host]
NexposeUN = $settings[:nexpose][:user]
NexposePW = $settings[:nexpose][:pass]

## New Nexpose Connection -> Requirements are Device IP, Username, Password
nsc = Nexpose::Connection.new(NexposeIP, NexposeUN, NexposePW)
nsc.login

#puts nsc.system_information
groupid = $settings[:nexpose][:stalegroup]
ag = AssetGroup.load(nsc, groupid)  ##Change :stalegroup: id in settings.yml to match your asset group id (this can be found by browsing here https://YOURNEXPOSE:3780/asset/group/listing.jsp and hovering over the group you want to reference )



##Loads all the referenced devices into a variable and iterates through deleting them
devices = ag.devices

devices.each do |host|
  dev_id = host.id
# output << ("#{host.address}\n")
 nsc.delete_device(dev_id)
end
#output.close

## Log out of your nexpose console. 
nsc.logout
