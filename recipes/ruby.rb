#
# Cookbook Name:: cookbook_rackbox
# Recipe:: ruby
#
# Install and setup Ruby environment
#

if node['cookbook_rackbox']['ruby']['use_rvm'] == false

  include_recipe "ruby_build::default"
  ruby_build_ruby node['cookbook_rackbox']['ruby']['global_version'] do
    action :install
  end

else

  include_recipe "rbenv::default"
  include_recipe "rbenv::ruby_build"

  node['cookbook_rackbox']['ruby']['versions'].each do |rb_version|

    rbenv_ruby rb_version do
      global(node['cookbook_rackbox']['ruby']['global_version'] == rb_version)
    end
    rbenv_gem 'bundler' do
      ruby_version rb_version
    end

  end

end

