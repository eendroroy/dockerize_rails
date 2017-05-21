module DockerizeRails
  module ConfigGenerator
    def self.configure
      puts "\nGenerating DockerizeRails config file ...\n".yellow
      puts "  ==> #{Constants::ROCKER_DOCKER_CONFIG_FILE_NAME}".blue
      file = File.open(File.join(PATHS.current, Constants::ROCKER_DOCKER_CONFIG_FILE_NAME), 'w+')
      file.write(DRConfig.to_yaml_str)
      file.close
      puts
      0
    end

    def self.dockerize
      status = 0
      puts "\nGenerating config files ...\n".yellow
      status += create_config_directories
      status += create_config_files
      puts "\nDon't forget to update "\
        "\"#{Constants::CONFIG_DIRECTORY_NAME}/#{Constants::RAILS_DIRECTORY_NAME}/secrtes.yml\"".yellow.underline
      puts
      status
    end

    def self.undockerize
      puts "\nRemoving docker config files ...\n".yellow
      remove_config_directories
    end

    def self.dir_op(dir, method)
      FileUtils.send(method, File.join(PATHS.current, dir))
    end

    def self.remove_config_directories
      dir_op(Constants::CONFIG_DIRECTORY_NAME, 'rm_rf')
      dir_op(Constants::DOCKERIGNORE_FILE_NAME, 'rm_rf')
      dir_op(Constants::DOCKER_COMPOSE_FILE_NAME, 'rm_rf')
      0
    end

    def self.create_config_directories
      db_values = DRConfig.databases.values
      dirs = Templates::ROOT_DIRECTORIES + Templates::RAILS_DIRECTORIES
      dirs += Templates::MYSQL_DIRECTORIES if db_values.include? 'mysql'
      dirs += Templates::PG_DIRECTORIES if db_values.include? 'postgresql'
      dirs.each { |dir| dir_op(dir, 'mkdir_p') }
      0
    end

    def self.create_custom_database_config
      puts "    ==> #{PATHS.relative_from_current(File.join(PATHS.rails_directory, 'database.yml'))}".blue
      file = File.open(File.join(PATHS.config_directory, Constants::RAILS_DIRECTORY_NAME, 'database.yml'), 'w+')
      file.write(ConfigLoader.app_config.to_yaml)
      file.close
      0
    end

    def self.create_rails_configs
      status = 0
      status += write_config PATHS.rails_directory, Templates::RAILS_TEMPLATES, 'rails'
      status += create_custom_database_config
      status
    end

    def self.create_mysql_configs
      write_config PATHS.mysql_directory, Templates::MYSQL_TEMPLATES, 'mysql'
    end

    def self.create_postgresql_configs
      write_config PATHS.postgresql_directory, Templates::POSTGRES_TEMPLATES, 'postgresql'
    end

    def self.create_root_configs
      write_config PATHS.current, Templates::ROOT_TEMPLATES
    end

    def self.create_config_files
      db_values = DRConfig.databases.values
      status = 0
      status += create_rails_configs
      status += create_mysql_configs if db_values.include? 'mysql'
      status += create_postgresql_configs if db_values.include? 'postgresql'
      status += create_root_configs
      status
    end

    def self.write_config(dir, config_names, resource_name = '')
      config_names.each do |conf|
        conf_path = File.join(dir, conf)
        puts "    ==> #{PATHS.relative_from_current(conf_path)}".blue
        file = File.open(conf_path, 'w+')
        file.write(
          StringIO.new(
            ERB.new(File.read(File.join(
                                PATHS.resources(resource_name),
                                "#{conf}.erb"
            ))).result(DRNameSpace.eval_i)
          ).read.gsub!(/\s*\n+/, "\n")
        )
        file.close
      end
      0
    end

    class << self
      private :dir_op
      private :remove_config_directories
      private :create_config_directories
      private :create_custom_database_config
      private :create_rails_configs
      private :create_mysql_configs
      private :create_postgresql_configs
      private :create_root_configs
      private :create_config_files
      private :write_config
    end
  end
end
