module Rockered
  module ConfigGenerator
    CONFIG_DIR_NAME = 'docker'.freeze

    def self.create_configs
      create_config_directory
      generate_config_files
    end

    def self.create_config_directory
      conf_dir = PATHS.config
      data_dir = File.join(PATHS.config, 'data_dir')
      FileUtils.mkdir_p(conf_dir) unless File.directory?(conf_dir)
      FileUtils.mkdir_p(data_dir) unless File.directory?(data_dir)
    end

    def self.create_namespace(dbc)
      namespace = OpenStruct.new

      dbc.keys.each do |k|
        namespace.database = 'mysql' if dbc[k].keys.include?('adapter') && dbc[k]['adapter'].start_with?('mysql')
        namespace.database_dockerfile = PATHS.relative_from_current(File.join(PATHS.config, 'Dockerfilemysql'))
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
    end

    def self.update_database_config(dbc)
      (dbc.keys.reject { |f| f.match(%r{^(default)/}) }).each do |k|
        dbc[k].keys.include?('host') ? dbc[k]['host'] = 'databasehost' : next
      end
      dbc.delete 'default'
      puts "  ==> #{PATHS.relative_from_current(File.join(PATHS.config, 'database.yml'))}".green
      File.open(File.join(PATHS.config, 'database.yml'), 'w+').write(dbc.to_yaml)
    end

    def self.generate_config_files
      dbc = ConfigHelper.read_app_config
      namespace = create_namespace dbc

      puts 'Generating config files ...'.yellow
      write_to_config_dir %w[rockered.yml entry-point.sh DockerfileRails Dockerfilemysql Dockerfilepostgres], namespace
      update_database_config dbc
      write_to_current_dir %w[docker-compose.yml], namespace
    end
  end
end
