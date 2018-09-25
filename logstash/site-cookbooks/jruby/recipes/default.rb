#
# Cookbook Name:: jruby
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

JRUBY_VERSION='9.2.0.0'
JRUBY_FILE="jruby-dist-#{JRUBY_VERSION}-bin.tar.gz"
JRUBY_FILE_PATH="/tmp/#{JRUBY_FILE}"
JRUBY_URL="https://repo1.maven.org/maven2/org/jruby/jruby-dist/#{JRUBY_VERSION}/#{JRUBY_FILE}"
JRUBY_PATH='/usr/local/jruby'

yum_package 'wget' do
  action :upgrade
end

bash 'jruby install' do
  user "root"
  cwd "/tmp"
  code <<-EOC
  wget #{JRUBY_URL}
  tar zxvf #{JRUBY_FILE_PATH}
  mv jruby-#{JRUBY_VERSION} #{JRUBY_PATH}
  echo 'PATH="/usr/local/jruby/bin:$PATH"' >> "/etc/profile"
  export PATH="/usr/local/jruby/bin:$PATH"
  jruby -S gem update --system
  jruby -S gem install bundler
  EOC
end
