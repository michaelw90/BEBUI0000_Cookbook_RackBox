#
# Cookbook Name:: cookbook_rackbox
# Recipe:: default
#

include_recipe "appbox"
include_recipe "cookbook_rackbox::ruby"
include_recipe "cookbook_rackbox::nginx"
include_recipe "runit"

if node["cookbook_rackbox"]["apps"]["unicorn"]
  include_recipe "cookbook_rackbox::unicorn"
end

if node["cookbook_rackbox"]["apps"]["passenger"]
  include_recipe "cookbook_rackbox::passenger"
end
