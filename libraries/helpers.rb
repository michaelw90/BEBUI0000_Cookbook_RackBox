module CookbookRackbox
  module Helpers

    def setup_passenger_runit(app, app_dir, default_port)
      default_config =  node["cookbook_rackbox"]["default_config"]["passenger_runit"].to_hash
      default_config["port"] = default_port
      config = merge_runit_config(
        default_config,
        app["runit_config"]
      )
      runit_service app["appname"] do
        run_template_name  config["template_name"]
        log_template_name  config["template_name"]
        cookbook       config["template_cookbook"]
        options(
          :user              => 'deploy',
          :group             => node["appbox"]["apps_user"],
          :rack_env          => config["rack_env"],
          :working_directory => app_dir,
          :socket            => config["socket"],
          :host              => config["host"],
          :port              => config["port"],
          :max_pool_size     => config["max_pool_size"],
          :min_instances     => config["min_instances"],
          :spawn_method      => config["spawn_method"]
        )
        restart_on_update false
      end
    end


    def merge_runit_config(default_config, app_config)
      config = default_config.to_hash
      config.merge(app_config || {})
    end

    def setup_nginx_site(app, rails_public_dir, static_public_dir, upstream_port)
      upstream_server = "localhost:#{upstream_port}"
      config = merge_nginx_config(
        node["cookbook_rackbox"]["default_config"]["nginx"],
        app["nginx_config"]
      )

      template( File.join(node["nginx"]["dir"], "sites-available", app["appname"]) ) do
        source    config["template_name"]
        cookbook  config["template_cookbook"]
        mode      "0644"
        owner     "root"
        group     "root"
        variables(
          :rails_public_dir  => rails_public_dir,
          :rails_path  => app["rails_path"],
          :static      => app["static"],
          :static_public_dir => static_public_dir,
          :static_path => app["static_path"],
          :log_dir     => node["nginx"]["log_dir"],
          :appname     => app["appname"],
          :hostname    => app["hostname"],
          :servers     => [upstream_server],
          :listen_port => config["listen_port"],
          :ssl_key     => config["ssl_key"],
          :ssl_cert    => config["ssl_cert"]
        )
        notifies :reload, "service[nginx]"
      end

      # TODO issue: nginx not reload enabled site
      nginx_site app["appname"] do
        notifies :reload, "service[nginx]"
      end
    end

    def merge_nginx_config(default_config, app_config)
      config = default_config.to_hash
      config.merge(app_config || {})
    end
    
  end

end
