module Rockered
  module ConfigGenerator
    CONFIG_DIR_NAME = 'docker'.freeze

    def self.configure_rockered
      puts "  ==> #{PATHS.relative_from_current(PATHS.rockered_config_file)}".green
      File.open(PATHS.rockered_config_file, 'w+').write(
        StringIO.new(
          ERB.new(File.read(File.join(PATHS.resources, 'rockered.yml.erb'))).result(binding)
        ).read
      )
      0
    end

    def self.create_configs(rc)
      create_config_directory
      generate_config_files(rc)
    end

    def self.create_config_directory
      conf_dir = PATHS.config
      data_dir = File.join(PATHS.config, 'data_dir')
      FileUtils.mkdir_p(conf_dir) unless File.directory?(conf_dir)
      FileUtils.mkdir_p(data_dir) unless File.directory?(data_dir)
    end

    def self.create_namespace(rc, dbc)
      namespace = read_rc(rc)
      namespace.database = 'mysql' if dbc[rc['application_env']]['adapter'].start_with?('mysql')
      namespace.database = 'postgresql' if dbc[rc['application_env']]['adapter'].start_with?('postgresql')
      namespace.database_dockerfile = PATHS.relative_from_current("#{PATHS.config}/Dockerfile#{namespace.database}")
      namespace
    end

    def self.read_rc(rc, namespace = OpenStruct.new)
      {
        rails_version: '5',
        application_env: 'production',
        application_port: '5000',
        db_root_pass: 'root',
        postgres_version: 'alpine',
        mysql_version: '5.7'
      }.map do |k, v|
        namespace.send("#{attr}=", rc[k] || v)
      end
      namespace
    end

    def self.write_to_config_dir(config_names, namespace)
      config_names.each do |conf|
        puts "  ==> #{PATHS.relative_from_current(File.join(PATHS.config, conf).to_s)}".green
        File.open(File.join(PATHS.config, conf), 'w+').write(
          StringIO.new(
            ERB.new(File.read(File.join(PATHS.resources, "#{conf}.erb"))).result(namespace.instance_eval { binding })
          ).read
        )
      end
      0
    end

    def self.write_to_current_dir(config_names, namespace)
      config_names.each do |conf|
        puts "  ==> #{PATHS.relative_from_current(File.join(PATHS.current, conf).to_s)}".green
        File.open(File.join(PATHS.current, conf), 'w+').write(
          StringIO.new(
            ERB.new(File.read(File.join(PATHS.resources, "#{conf}.erb"))).result(namespace.instance_eval { binding })
          ).read
        )
      end
      0
    end

    def self.update_database_config(dbc)
      (dbc.keys.reject { |f| f.match(%r{^(default)/}) }).each do |k|
        dbc[k].keys.include?('host') ? dbc[k]['host'] = 'databasehost' : next
      end
      dbc.delete 'default'
      puts "  ==> #{PATHS.relative_from_current(File.join(PATHS.config, 'database.yml'))}".green
      File.open(File.join(PATHS.config, 'database.yml'), 'w+').write(dbc.to_yaml)
      0
    end

    def self.generate_config_files(rc)
      dbc = ConfigHelper.read_app_config
      namespace = create_namespace rc, dbc

      puts 'Generating config files ...'.yellow
      write_to_config_dir %w[entry-point.sh DockerfileRails Dockerfilemysql Dockerfilepostgres], namespace
      update_database_config dbc
      write_to_current_dir %w[docker-compose.yml], namespace
      0
    end
  end
end
