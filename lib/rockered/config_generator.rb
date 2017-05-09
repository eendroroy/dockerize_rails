module Rockered
  module ConfigGenerator
    def self.configure
      puts "\nGenerating Rockered config file ...\n".yellow
      puts "  ==> #{ROCKERED_CONFIG_FILE_NAME}".green
      f = File.open(File.join(PATHS.current, ROCKERED_CONFIG_FILE_NAME), 'w+')
      f.write(RockeredConfig.to_yaml_str)
      f.close
      puts
      0
    end

    def self.dockrize
      resp = 0
      resp += create_config_directories
      resp += create_config_files
      resp
    end

    def self.create_config_directories
      (Templates::ROOT_DIRECTORIES + Templates::RAILS_DIRECTORIES).each do |v|
        FileUtils.mkdir_p(v) unless File.directory?(v)
      end
      Templates::MYSQL_DIRECTORIES.each { |v| FileUtils.mkdir_p(v) unless File.directory?(v) }
      Templates::POSTGRES_DIRECTORIES.each { |v| FileUtils.mkdir_p(v) unless File.directory?(v) }
      0
    end

    def self.create_custom_database_config
      puts "    ==> #{PATHS.relative_from_current(File.join(PATHS.rails_directory, 'database.yml'))}".green
      f = File.open(File.join(PATHS.config_directory, RAILS_DIRECTORY_NAME, 'database.yml'), 'w+')
      f.write(ConfigLoader.app_config.to_yaml)
      f.close
      0
    end

    def self.create_rails_configs
      resp = 0
      resp += write_to_dir PATHS.rails_directory, Templates::RAILS_TEMPLATES, 'rails'
      resp += create_custom_database_config
      resp
    end

    def self.create_mysql_configs
      write_to_dir PATHS.mysql_directory, Templates::MYSQL_TEMPLATES, 'mysql'
    end

    def self.create_postgresql_configs
      write_to_dir PATHS.postgresql_directory, Templates::POSTGRES_TEMPLATES, 'postgresql'
    end

    def self.create_root_configs
      write_to_dir PATHS.current, Templates::ROOT_TEMPLATES
    end

    def self.create_config_files
      resp = 0
      puts "\nGenerating config files ...\n".yellow
      resp += create_rails_configs
      resp += create_mysql_configs
      resp += create_postgresql_configs
      resp += create_root_configs
      puts
      resp
    end

    def self.write_to_dir(dir, config_names, resource_name = '')
      config_names.each do |conf|
        puts "    ==> #{PATHS.relative_from_current(File.join(dir, conf).to_s)}".green
        f = File.open(File.join(dir, conf), 'w+')
        f.write(
          StringIO.new(
            ERB.new(File.read(File.join(PATHS.resources(resource_name), "#{conf}.erb"))).result(RNameSpace.eval_i)
          ).read
        )
        f.close
      end
      0
    end
  end
end
