include_recipe "nodejs"
include_recipe "grano::default"
include_recipe 'git'
include_recipe "python"

package "libxml2-dev" do
  action :install
end

package "libxslt1-dev" do
  action :install
end

execute "install bower" do
  command "npm i -g bower@1.2.6"
  not_if "test -e /usr/bin/bower"
end

execute "install less" do
  command "npm i -g less@1.7.1"
  not_if "test -e /usr/bin/less"
end

execute "install uglify-js@2.4.14" do
  command "npm i -g less@1.2.6"
  not_if "test -e /usr/bin/less"
end

git "/opt/grano/grano" do
  repository "git://github.com/granoproject/grano.git"
  enable_submodules true
  reference "master"
  action :sync
end

git "/opt/grano/app" do
  repository "git://github.com/g0v/addressbook-grano.git"
  enable_submodules true
  reference "master"
  action :sync
end

execute "install grano" do
  cwd "/opt/grano/grano"
  action :nothing
  subscribes :run, resources(:git => "/opt/grano/grano"), :immediately
  environment ({"SUDO_USER" => "", "SUDO_UID" => ""})
  #@FIXME: run production installation after setup.py fixed.
  command "sudo pip install -r requirements.txt && sudo python setup.py develop && sudo pip install psycopg2"
end
