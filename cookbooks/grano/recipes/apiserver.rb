include_recipe "runit"
include_recipe "database"
include_recipe "postgresql"
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