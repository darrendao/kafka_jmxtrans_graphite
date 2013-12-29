#
# Cookbook Name:: kafka_jmxtrans_graphite
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

remote_file "#{Chef::Config[:file_cache_path]}/jmxtrans.rpm" do
  source "https://github.com/downloads/jmxtrans/jmxtrans/jmxtrans-20121016.145842.6a28c97fbb-0.noarch.rpm"
  action :create
end

rpm_package "jmxtrans" do
    source "#{Chef::Config[:file_cache_path]}/jmxtrans.rpm"
    action :install
end

template "/var/lib/jmxtrans/kafka.json" do
  source "kafka.json.erb"
  owner node['jmxtrans']['user']
  group node['jmxtrans']['user']
  mode  "0755"
  notifies :restart, "service[jmxtrans]"
end

template "/etc/sysconfig/jmxtrans" do
  source "jmxtrans.conf.erb"
  owner node['jmxtrans']['user']
  group node['jmxtrans']['user']
  mode  "0644"
  notifies :restart, "service[jmxtrans]"
end

service "jmxtrans" do
  supports :restart => true, :status => true, :reload => true
  action [ :enable, :start]
end

