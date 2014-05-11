#
# Cookbook Name:: grano
# Recipe:: default
#
# Copyright (C) 2014 YOUR_NAME
# 
# License under MIT.
#
include_recipe "runit"
include_recipe "database"
include_recipe "nodejs"
include_recipe "python"

directory "/opt/grano" do
  action :create
end

directory "/opt/grano" do
  action :create
  owner "nobody"
end

include_recipe 'nodejs'
include_recipe 'git'

execute "install bower" do
  command "npm i -g bower@1.2.6"
  not_if "test -e /usr/bin/bower"
end

git "/opt/grano/grano" do
  repository "git://github.com/granoproject/grano.git"
  enable_submodules true
  reference "master"
  action :sync
end

package "libxml2-dev" do
  action :install
end

package "libxslt1-dev" do
  action :install
end
