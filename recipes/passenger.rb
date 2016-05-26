# Cookbook Name:: cookbook_rackbox
# Recipe:: passenger
#
# Setup passenger apps
#

package "libcurl4-openssl-dev"

package "libmysqlclient-dev"

::Chef::Recipe.send(:include, CookbookRackbox::Helpers)

Array(node["cookbook_rackbox"]["apps"]["passenger"]).each_with_index do |app, index|

  # Merge the defaults for the app into the custom overriden attributes.
  config = node["cookbook_rackbox"]["default_config"]["passenger_app"].to_hash
  app = config.merge(app)

  default_port = node["cookbook_rackbox"]["upstream_start_port"]["passenger"].to_i + index
  app_dir      = ::File.join(node["appbox"]["apps_dir"], app["appname"])
  rails_app_dir = app_dir
  static_app_dir = app_dir
  rails_app_dir = ::File.join(rails_app_dir, app["rails_sub_dir"]) if app["rails_sub_dir"]
  rails_public_dir = ::File.join(rails_app_dir, app["rails_public_dir"]) if app["rails_public_dir"]
  static_app_dir = ::File.join(static_app_dir, app["static_sub_dir"]) if app["static_sub_dir"]
  static_public_dir = ::File.join(static_app_dir, app["static_public_dir"]) if app["static_public_dir"]

  setup_nginx_site(app, rails_public_dir, static_public_dir, default_port)
  setup_passenger_runit(app, rails_app_dir, default_port)
end


