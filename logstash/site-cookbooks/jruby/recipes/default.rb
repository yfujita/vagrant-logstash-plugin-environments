#
# Cookbook Name:: jruby
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

JRUBY_VERSION='1.7.23'
JRUBY_FILE="jruby-bin-#{JRUBY_VERSION}.tar.gz"
JRUBY_FILE_PATH="/tmp/#{JRUBY_FILE}"
JRUBY_URL="http://jruby.org.s3.amazonaws.com/downloads/#{JRUBY_VERSION}/#{JRUBY_FILE}"
JRUBY_PATH='/usr/local/jruby'


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
