#
# Cookbook Name:: monit-rpm
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

RPM_FILE='logstash-2.3.3-1.noarch.rpm'
RPM_FILE_PATH="/tmp/#{RPM_FILE}"
RPM_URL="https://download.elastic.co/logstash/logstash/packages/centos/#{RPM_FILE}"


bash 'logstash install' do
  user "root"
  cwd "/tmp"
  code <<-EOC
  wget #{RPM_URL}
  rpm -ivh #{RPM_FILE_PATH}
  EOC
end

service "logstash" do
  action [:enable]
  supports :start => true, :status => true, :restart => true
end
