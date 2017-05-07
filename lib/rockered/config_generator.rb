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
      namespace = namespace_from_rc(rc)
      namespace.database = 'mysql' if dbc[rc['application_env']]['adapter'].start_with?('mysql')
      namespace.database = 'postgresql' if dbc[rc['application_env']]['adapter'].start_with?('postgresql')
      namespace.db_user = dbc[rc['application_env']]['username']
      namespace.db_pass = dbc[rc['application_env']]['password']
      namespace.database_dockerfile = PATHS.relative_from_current("#{PATHS.config}/Dockerfile#{namespace.database}")
      namespace
    end

    def self.namespace_from_rc(rc, namespace = OpenStruct.new)
      {
        rails_version: '5', application_env: 'production', application_port: '5000',
        db_root_pass: 'root', postgres_version: 'alpine', mysql_version: '5.7'
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

    def self.create_custom_database_config(dbc)
      puts "  ==> #{PATHS.relative_from_current(File.join(PATHS.config, 'database.yml'))}".green
      File.open(File.join(PATHS.config, 'database.yml'), 'w+').write(dbc.to_yaml)
      0
    end

    def self.generate_config_files(rc)
      response = 0
      dbc = ConfigHelper.read_app_config
      dbc.delete 'default'
      { host: 'databasehost', username: 'user', password: 'pass', database: 'rockered_ENV' }.map do |k, v|
        dbc.keys.each { |section| dbc[section][k.to_s] = v.gsub('ENV', section) }
      end
      response |= create_custom_database_config dbc

      namespace = create_namespace rc, dbc

      puts 'Generating config files ...'.yellow
      response |= write_to_config_dir %w[entry-point.sh DockerfileRails Dockerfilemysql Dockerfilepostgresql], namespace
      response |= write_to_current_dir %w[docker-compose.yml], namespace
      response
    end
  end
end
