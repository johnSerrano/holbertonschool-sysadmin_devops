#!/usr/bin/env ruby
require 'optparse'
require 'yaml'
require 'pp'

def load_from_yaml
  begin
    config = YAML::load(File.open('config.yaml'))
  rescue
    puts "Unable to open or parse file 'config.yaml' in current directory."
    return false
  end
  return config
end

def launch_ec2
  puts "Launching EC2 instance (but not really)"
end

def stop_ec2
  puts "Stopping EC2 instance (but not really)"
end

def start_ec2
  puts "Starting EC2 instance (but not really)"
end

def terminate_ec2
  puts "Terminating EC2 instance (but not really)"
end

config = load_from_yaml

if config == false
  exit 1
else
  # pp config
end

optparse = OptionParser.new do |opts|
  opts.on('-h', '--help', 'Display this screen') do
    puts opts
    exit
  end

  opts.on('-a', '--action ACTION', 'Values: launch, stop, start, terminate') do |action|
    if action == "launch"
      launch_ec2
    elsif action == "stop"
      stop_ec2 #more params TODO
    elsif action == "start"
      start_ec2 #more params TODO
    elsif action == "terminate"
      terminate_ec2 #more params TODO
    else
      puts "Action not recognized."
    end
  end

  opts.on('-i', '--server_id', 'Provides the server ID') do
    #TODO assuming this will make sense later
  end

  opts.on('-v', '--verbose', 'Provides additional information') do
    #TODO
  end
end

optparse.parse!
