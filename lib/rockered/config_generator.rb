module Rockered
  module ConfigGenerator
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
      create_config_directories
      generate_config_files(rc)
    end

    def self.create_config_directories
      DIRECTORIES.map do |_, v|
        FileUtils.mkdir_p(v) unless File.directory?(v)
      end
    end

    def self.create_namespace(rc, dbc)
      namespace = namespace_from_rc(rc)
      namespace.database = 'mysql' if dbc[rc['application_env']]['adapter'].start_with?('mysql')
      namespace.database = 'postgresql' if dbc[rc['application_env']]['adapter'].start_with?('postgresql')
      namespace.db_user = dbc[rc['application_env']]['username']
      namespace.db_pass = dbc[rc['application_env']]['password']
      namespace.database_dockerfile = PATHS.relative_from_current("#{PATHS.config_directory}/Dockerfile#{namespace.database}")
      namespace
    end

    def self.namespace_from_rc(rc, namespace = OpenStruct.new)
      {
        rails_version: '5', application_env: 'production', application_port: '5000',
        db_root_pass: 'root', postgres_version: 'alpine', mysql_version: '5.7', database_host_name: 'database_name',
        database_user_name: 'user', database_user_pass: 'pass', database_name_prefix: 'rockered_'
      }.map do |k, v|
        namespace.send("#{attr}=", rc[k] || v)
      end
      namespace
    end

    def self.write_to_config_dir(config_names, namespace)
      config_names.each do |conf|
        puts "    ==> #{PATHS.relative_from_current(File.join(PATHS.config_directory, conf).to_s)}".green
        File.open(File.join(PATHS.config_directory, conf), 'w+').write(
          StringIO.new(
            ERB.new(File.read(File.join(PATHS.resources, "#{conf}.erb"))).result(namespace.instance_eval { binding })
          ).read
        )
      end
      0
    end

    def self.write_to_current_dir(config_names, namespace)
      config_names.each do |conf|
        puts "    ==> #{PATHS.relative_from_current(File.join(PATHS.current, conf).to_s)}".green
        File.open(File.join(PATHS.current, conf), 'w+').write(
          StringIO.new(
            ERB.new(File.read(File.join(PATHS.resources, "#{conf}.erb"))).result(namespace.instance_eval { binding })
          ).read
        )
      end
      0
    end

    def self.create_custom_database_config(dbc)
      puts "    ==> #{PATHS.relative_from_current(File.join(PATHS.config_directory, 'database.yml'))}".green
      File.open(File.join(PATHS.config_directory, 'database.yml'), 'w+').write(dbc.to_yaml)
      0
    end

    def self.generate_config_files(rc)
      response = 0
      dbc = ConfigLoader.load_app_config
      namespace = create_namespace rc, dbc

      puts "\nGenerating config files ...".yellow
      response |= create_custom_database_config dbc
      response |= write_to_config_dir TEMPLATES[:config_dir], namespace
      response |= write_to_current_dir TEMPLATES[:current_dir], namespace
      puts
      response
    end
  end
end
