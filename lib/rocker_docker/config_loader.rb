module RockerDocker
  module ConfigLoader
    require 'yaml'

    @app_config = nil

    def self.app_config
      if @app_config.nil?
        @app_config = YAML.load_file(File.join(PATHS.current, 'config/database.yml'))
        process_app_config
      end
      @app_config
    end

    def self.process_app_config
      @app_config.delete 'default'
      @app_config.keys.each do |section|
        @app_config[section]['username'] = RDConfig.database_user_name
        @app_config[section]['password'] = RDConfig.database_user_pass
        @app_config[section]['database'] = "#{RDConfig.application_name}_#{section}"
        @app_config[section]['host'] = 'databasehost'
      end
    end

    class << self
      private :process_app_config
    end
  end
end
