#
# Cookbook Name:: cookbook_rackbox
# Recipe:: unicorn
#
# Setup unicorn apps
#

::Chef::Recipe.send(:include, CookbookRackbox::Helpers)

Array(node["cookbook_rackbox"]["apps"]["unicorn"]).each_with_index do |app, index|

  # Merge the defaults for the app into the custom overriden attributes.
  config = node["cookbook_rackbox"]["default_config"]["unicorn_app"].to_hash
  app = config.merge(app)
  
  default_port = node["cookbook_rackbox"]["upstream_start_port"]["unicorn"].to_i + index
  app_dir      = ::File.join(node["appbox"]["apps_dir"], app["appname"], app["capistrano_sub_dir"])
  rails_app_dir = app_dir
  if app["rails_sub_dir"]
    rails_app_dir = ::File.join(rails_app_dir, app["rails_sub_dir"])
  end

  setup_nginx_site(app, app_dir, default_port)
  setup_unicorn_config(app, rails_app_dir, default_port)
  setup_unicorn_runit(app, rails_app_dir)
end

