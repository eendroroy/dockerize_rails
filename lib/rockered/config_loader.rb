module Rockered
  module ConfigLoader
    require 'yaml'

    @app_config = nil

    def self.load_app_config
      if @app_config.nil?
        @app_config = YAML.load_file(File.join(PATHS.current, 'config/database.yml'))
        process_app_config
      end
      @app_config
    end

    def self.process_app_config
      rc = load_rockered_config('')
      @app_config.delete 'default'
      {
        username: rc['database_user_name'] || 'root', password: rc['database_user_pass'] || 'root',
        database: "#{rc['database_name_prefix']}#", host: rc['database_host_name'] || 'db'
      }.map do |k, v|
        @app_config.keys.each { |section| @app_config[section][k.to_s] = v.gsub('#', section) }
      end
    end

    def self.load_rockered_config(command)
      commands = Helpers.processed_commands
      if (commands[:configure] + commands[:help]).include?(command) && !File.exist?(PATHS.rockered_config_file)
        nil
      elsif File.exist? PATHS.rockered_config_file
        @rockered_config = YAML.load_file(PATHS.rockered_config_file) if @rockered_config.nil?
        @rockered_config
      else
        puts "Rockered not yet configured\nRun 'bundle exec rock cr' to configure rockered.".red
        puts Helpers.help
        exit(1)
      end
    end
  end
end
