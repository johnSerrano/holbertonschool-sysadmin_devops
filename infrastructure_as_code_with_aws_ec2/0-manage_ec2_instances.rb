#!/usr/bin/env ruby
require 'optparse'
require 'yaml'
require 'pp'
require 'aws-sdk'

def load_from_yaml
  begin
    config = YAML::load(File.open('config.yaml'))
  rescue
    puts "Unable to open or parse file 'config.yaml' in current directory."
    return false
  end
  return config
end

def launch_ec2(config)
  # TODO
  puts "Launching EC2 instance (but not really)"
  instance = ec2.instances.create({
  :image_id           => config["image_id"],
  :instance_type      => config["image_type"],
  :key_name           => config["key_pair"],
  :security_group_ids => config["security_group_ids"],
  :count              => 1,

  :block_device_mappings => [
    {
     :device_name => "/dev/sda1",
     :ebs         => { :volume_size => 25, :delete_on_termination => true }
    }
  ]
  })
end

def stop_ec2(config, instance_id)
  @aws_i = Aws::EC2::Instance.new(instance_id)
  @aws_i.stop
end

def start_ec2(config, instance_id)
  @aws_i = Aws::EC2::Instance.new(instance_id)
  @aws_i.start
end

def terminate_ec2(config, instance_id)
  @aws_i = Aws::EC2::Instance.new(instance_id)
  @aws_i.terminate
end

config = load_from_yaml

if config == false
  exit 1
end

Aws.config.update ({
           access_key_id:      config["access_key_id"],
           secret_access_key:  config["secret_access_key"],
           region:             config["availability-zone"]
         })

options = {}


optparse = OptionParser.new do |opts|
  opts.on('-h', '--help', 'Display this screen') do
    puts opts
    exit
  end

  opts.on('-i', '--server_id SERVER_ID', 'Provides the server ID') do |server_id|
    options["server_id"] = server_id
  end

  opts.on('-a', '--action ACTION', 'Values: launch, stop, start, terminate') do |action|
    options["action"] = action
  end

  opts.on('-v', '--verbose', 'Provides additional information') do
    options["verbose"] == true
  end
end

optparse.parse!


if options["action"] == "launch"
  launch_ec2 config
elsif options["action"] == "stop"
  stop_ec2 config, options["server_id"]
elsif options["action"] == "start"
  start_ec2 config, options["server_id"]
elsif options["action"] == "terminate"
  terminate_ec2 config, options["server_id"]
else
  puts "Action not recognized."
end
