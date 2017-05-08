module Rockered
  class RNameSpace
    @namespace = OpenStruct.new

    attr_reader :namespace

    def self.load
      load_from_app_config
      load_from_rockered_config
    end

    def self.load_from_app_config
      dbc = ConfigLoader.load_app_config
      @namespace.database = 'mysql' if dbc[RockeredConfig.application_env]['adapter'].start_with?('mysql')
      @namespace.database = 'postgresql' if dbc[RockeredConfig.application_env]['adapter'].start_with?('postgresql')
      @namespace.db_user = dbc[RockeredConfig.application_env]['username']
      @namespace.db_pass = dbc[RockeredConfig.application_env]['password']
      @namespace.database_dockerfile = PATHS.relative_from_current(
        "#{PATHS.config_directory}/Dockerfile#{@namespace.database}"
      )
    end

    def self.load_from_rockered_config
      RockeredConfig.to_hash.map do |k, v|
        @namespace.send("#{k}=", v)
      end
    end

    def self.add_hash(hash)
      hash.map do |k, v|
        @namespace.send("#{attr}=", rc[k] || v)
      end
    end

    def self.eval_i
      @namespace.instance_eval { binding }
    end

    class << self
      private :load_from_app_config
      private :load_from_rockered_config
    end
  end
end
