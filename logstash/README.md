# vagrant-logstash-plugin-environments

Development environments for logstash plugin.

## host

```
cd ./data
git clone https://~~/logstash-***
```

## guest

```
gem build /vagrant_data/logstash-***/logstash-***.gemspec
/opt/logstash/bin/logstash-plugin install /vagrant_data/logstash-***/logstash-***.gem
```
