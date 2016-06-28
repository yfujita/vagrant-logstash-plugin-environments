#
# Cookbook Name:: vim
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

yum_package 'vim' do
  action :upgrade
end
