#
# Cookbook Name:: java
# Recipe:: default
#
# Copyright 2018, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

yum_package 'java-1.8.0-openjdk' do
  action :upgrade
end