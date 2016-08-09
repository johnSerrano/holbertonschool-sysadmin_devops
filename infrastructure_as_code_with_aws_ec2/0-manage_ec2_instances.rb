#!/usr/bin/env ruby
require 'optparse'
require 'yaml'
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
  ec2 = Aws::EC2::Client.new({
  		access_key_id:     config['access_key_id'],
  		secret_access_key: config['secret_access_key'],
      region:            'us-west-1',
  })
  resp = ec2.run_instances({
      key_name:           config["key_pair"],
      image_id:           config["image_id"],
      instance_type:      config["instance_type"],
      security_group_ids: config["security_group_ids"],
      min_count:          1,
      max_count:          1,
      placement: {
				  availability_zone: config["availability-zone"]
			}
    })
  instance_id = resp.instances[0].instance_id
	resp = ec2.wait_until(:instance_running, instance_ids:[instance_id])
	puts instance_id, resp.reservations[0].instances[0].public_dns_name
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
           region:             'us-west-1'
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
