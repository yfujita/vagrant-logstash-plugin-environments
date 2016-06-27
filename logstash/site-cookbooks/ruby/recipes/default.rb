#
# Cookbook Name:: monit-rpm
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

cookbook_file "/tmp/ruby-1.9.3-p551-1.x86_64.rpm" do
  mode 00644
end

yum_package 'make' do
  action :upgrade
end

yum_package 'gcc' do
  action :upgrade
end

yum_package 'zlib-devel' do
  action :upgrade
end

yum_package 'openssl-devel' do
  action :upgrade
end

yum_package 'readline-devel' do
  action :upgrade
end

yum_package 'ncurses-devel' do
  action :upgrade
end

yum_package 'gdbm-devel' do
  action :upgrade
end

yum_package 'db4-devel' do
  action :upgrade
end

yum_package 'libffi-devel' do
  action :upgrade
end

yum_package 'tk-devel' do
  action :upgrade
end

yum_package 'libyaml-devel' do
  action :upgrade
end

rpm_package 'ruby' do
  source "/tmp/ruby-1.9.3-p551-1.x86_64.rpm"
  action :install
end

bash 'update gem' do
  user "root"
  cwd "/tmp"
  code <<-EOC
  gem update --system
  EOC
end
