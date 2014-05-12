#
# Cookbook Name:: grano
# Recipe:: default
#
# Copyright (C) 2014 YOUR_NAME
# 
# License under MIT.
#
directory "/opt/grano" do
  action :create
end

directory "/opt/grano" do
  action :create
  owner "nobody"
end
