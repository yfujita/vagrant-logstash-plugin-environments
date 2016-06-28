# vagrant-logstash-plugin-environments

Development environments for logstash plugin.

## host

```
$ cd ./data
$ git clone https://~~/logstash-***
```

## guest

### run plugin on logstash
```
$ jruby -S gem build /vagrant_data/logstash-***/logstash-***.gemspec
$ /opt/logstash/bin/logstash-plugin install /vagrant_data/logstash-***/logstash-***.gem
$ vim /etc/logstash/conf.d/***.conf # edit config
$ service logstash start
```

### spec
```
cd /vagrant_data/logstash-***
bundle install
bundle exec rspec
```
