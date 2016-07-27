#
# Cookbook Name:: nginx
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

include_recipe 'apt'
include_recipe 'ntp'
include_recipe 'openssh'
include_recipe 'user'

package 'nginx' do
	action :install
end

service 'nginx' do
	action [ :enable, :start ]
end

