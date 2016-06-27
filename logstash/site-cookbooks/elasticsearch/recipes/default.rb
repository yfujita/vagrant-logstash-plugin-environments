es_version = "2.3.2"

service "elasticsearch" do
    supports :status => true, :restart => true, :reload => true
end

case node['platform']
when "ubuntu", "debian"
  filename = "elasticsearch-#{es_version}.deb"
  remote_uri = "https://download.elastic.co/elasticsearch/release/org/elasticsearch/distribution/deb/elasticsearch/#{es_version}/#{filename}"

  remote_file "/tmp/#{filename}" do
      source "#{remote_uri}"
      mode 00644
  end

  package "elasticsearch" do
      action :install
      source "/tmp/#{filename}"
      provider Chef::Provider::Package::Dpkg
  end
when "centos", "redhat"
  filename = "elasticsearch-#{es_version}.rpm"
  remote_uri = "https://download.elastic.co/elasticsearch/release/org/elasticsearch/distribution/rpm/elasticsearch/#{es_version}/#{filename}"

  remote_file "/tmp/#{filename}" do
      source "#{remote_uri}"
      mode 00644
  end

  package "elasticsearch" do
      action :install
      source "/tmp/#{filename}"
      provider Chef::Provider::Package::Rpm
  end
end

bash "es_config_org" do
 only_if { !File.exists?("/etc/elasticsearch/elasticsearch.yml_org") }
 user "root"
 cwd "/tmp"
 code <<-EOH
 cp /etc/elasticsearch/elasticsearch.yml /etc/elasticsearch/elasticsearch.yml_org
 EOH
end

bash "update_es_yml" do
  user "root"
  cwd "/tmp"
  code <<-EOH
  cat /etc/elasticsearch/elasticsearch.yml_org > /tmp/elasticsearch.yml.tmp
  echo "cluster.name: elasticsearch" >> /tmp/elasticsearch.yml.tmp
  echo "node.name: \"ES Node 1\"" >> /tmp/elasticsearch.yml.tmp
  echo "index.number_of_shards: 1" >> /tmp/elasticsearch.yml.tmp
  echo "index.number_of_replicas: 0" >> /tmp/elasticsearch.yml.tmp
  echo "http.cors.enabled: true" >> /tmp/elasticsearch.yml.tmp
  echo 'http.cors.allow-origin: "*"' >> /tmp/elasticsearch.yml.tmp
  echo 'network.host: "0"' >> /tmp/elasticsearch.yml.tmp
  echo "configsync.config_path: /var/lib/elasticsearch/config" >> /tmp/elasticsearch.yml.tmp
  echo "script.engine.groovy.inline.update: on" >> /tmp/elasticsearch.yml.tmp
  mv -f /tmp/elasticsearch.yml.tmp /etc/elasticsearch/elasticsearch.yml
  EOH
end

bash "install_plugins" do
  user "root"
  cwd "/tmp"
  code <<-EOH
  /usr/share/elasticsearch/bin/plugin install lmenezes/elasticsearch-kopf/master
  EOH
  notifies :restart, resources(:service => "elasticsearch"), :immediately
end

directory '/etc/elasticsearch/templates' do
  owner "elasticsearch"
  group "elasticsearch"
  mode "0755"
  action :create
end

cookbook_file '/etc/elasticsearch/templates/template_dstat.json' do
  source "template_dstat.json"
  owner "elasticsearch"
  group "elasticsearch"
  mode "0755"
end

cookbook_file '/etc/elasticsearch/templates/template_applog.json' do
  source "template_applog.json"
  owner "elasticsearch"
  group "elasticsearch"
  mode "0755"
end

bash "index_templates" do
  user "root"
  cwd "/tmp"
  code <<-EOH
  sleep 10
  curl -XPUT localhost:9200/_template/template_dstat --data-binary @/etc/elasticsearch/templates/template_dstat.json;
  curl -XPUT localhost:9200/_template/template_applog --data-binary @/etc/elasticsearch/templates/template_applog.json;
  EOH
end
