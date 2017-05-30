module DockerizeRails
  module ConfigLoader
    require 'yaml'

    @app_config = false

    def self.app_config
      unless @app_config
        @app_config = YAML.load_file(File.join(PATHS.current, 'config/database.yml'))
        process_app_config
      end
      @app_config
    end

    def self.process_app_config
      @app_config.delete 'default'
      @app_config.keys.each do |section|
        current_section = @app_config[section]
        current_section['username'] = DRConfig.database_user_name
        current_section['password'] = DRConfig.database_user_pass
        current_section['database'] = "#{DRConfig.application_name}_#{section}" \
          if DRConfig.database_host_type == Constants::DATABASE_HOST_LINKED
        current_section['host'] = DRConfig.database_host_name
        @app_config[section] = current_section
      end
    end

    class << self
      private :process_app_config
    end
  end
end
