include_recipe "runit"
include_recipe "database"
include_recipe "postgresql"
include_recipe "postgresql::ruby"
include_recipe 'postgresql::server'

postgresql_connection_info = {:host => "127.0.0.1",
                              :port => node['postgresql']['config']['port'],
                              :username => 'postgres',
                              :password => node['postgresql']['password']['postgres']}

database 'grano' do
  connection postgresql_connection_info
  provider Chef::Provider::Database::Postgresql
  action :create
end

postgresql_database_user 'grano' do
  connection postgresql_connection_info
  database_name 'grano'
  password 'password'
  privileges [:all]
  action :create
end

postgresql_database "grant schema" do
  connection postgresql_connection_info
  database_name 'grano'
  sql "grant CREATE on database grano to grano"
  action :nothing
  subscribes :query, resources(:postgresql_database_user => 'grano'), :immediately
end

connection_info = postgresql_connection_info.clone()
connection_info[:username] = 'grano'
connection_info[:password] = 'password'
conn = "postgres://#{connection_info[:username]}:#{connection_info[:password]}@#{connection_info[:host]}/ly"

include_recipe "grano::apilib"

template "/opt/grano/app/settings.py" do
  source "settings.py.erb"
  owner "root"
  group "root"
  variables {}
  mode 00755
end

execute "init db" do
  cwd "/opt/grano/app"
  action :nothing
  environment ({"GRANO_SETTINGS" => "/opt/grano/app/settings.py"})
  command "grano db upgrade head & grano schema_import addressbook model.yml"
end
