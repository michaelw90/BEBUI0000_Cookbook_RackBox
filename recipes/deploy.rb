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
    command "sudo bundle install --binstubs"
  end

  execute "Own Assets & Public" do
    cwd "#{deploy[:current_path]}/rails"
    command "sudo chmod -R 0777 public tmp"
  end

  execute "CKEditor Compile" do
    cwd "#{deploy[:current_path]}/rails"
    command "RAILS_ENV=production rake ckeditor:create_nondigest_assets"
  end

  execute "Rake Assets Precompile" do
    cwd "#{deploy[:current_path]}/rails"
    command "RAILS_ENV=production rake assets:precompile"
  end

  execute "Restart Application" do
    command "sudo sv restart #{deploy[:application]}"
  end
end