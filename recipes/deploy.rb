include_recipe 'deploy'

node[:deploy].each do |application, deploy|

  opsworks_deploy_dir do
    user deploy[:user]
    group deploy[:group]
    path deploy[:deploy_to]
  end

  opsworks_rails do
    deploy_data deploy
    app application
  end

  opsworks_deploy do
    deploy_data deploy
    app application
  end

  execute "Bundle Install" do
    cwd "#{deploy[:current_path]}/rails"
    command "bundle install --binstubs"
  end

  execute :sudo, :sv, "restart #{deploy[:application]}"

end