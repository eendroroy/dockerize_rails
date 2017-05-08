module Rockered
  module ConfigGenerator
    def self.configure
      puts "  ==> #{PATHS.relative_from_current(PATHS.rockered_config_file)}".green
      File.open(PATHS.rockered_config_file, 'w+').write(RockeredConfig.to_yaml_str)
      0
    end

    def self.dockrize
      resp = 0
      resp += create_config_directories
      resp += generate_config_files
      resp
    end

    def self.create_config_directories
      DIRECTORIES.map do |_, v|
        FileUtils.mkdir_p(v) unless File.directory?(v)
      end
      0
    end

    def self.generate_config_files
      resp = 0
      puts "\nGenerating config files ...".yellow
      resp += create_custom_database_config
      resp += write_to_dir PATHS.config_directory, TEMPLATES[:config_dir]
      resp += write_to_dir PATHS.current, TEMPLATES[:current_dir]
      puts
      resp
    end

    def self.write_to_dir(dir, config_names)
      config_names.each do |conf|
        puts "    ==> #{PATHS.relative_from_current(File.join(dir, conf).to_s)}".green
        File.open(File.join(dir, conf), 'w+').write(
          StringIO.new(
            ERB.new(File.read(File.join(PATHS.resources, "#{conf}.erb"))).result(RNameSpace.eval_i)
          ).read
        )
      end
      0
    end

    def self.create_custom_database_config
      puts "    ==> #{PATHS.relative_from_current(File.join(PATHS.config_directory, 'database.yml'))}".green
      File.open(File.join(PATHS.config_directory, 'database.yml'), 'w+').write(ConfigLoader.load_app_config.to_yaml)
      0
    end
  end
end
