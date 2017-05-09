module RockerDocker
  class RockerDockerNameSpace
    require 'ostruct'

    @namespace = OpenStruct.new

    attr_reader :namespace

    def self.load
      RockerDockerConfig.load_rocker_docker_config
      load_from_app_config
      load_from_rocker_docker_config
    end

    def self.load_from_app_config
      dbc = ConfigLoader.app_config
      @namespace.database = 'mysql' if dbc[RockerDockerConfig.application_env]['adapter'].start_with?('mysql')
      @namespace.database = 'postgresql' if dbc[RockerDockerConfig.application_env]['adapter'].start_with?('postgresql')
    end

    def self.load_from_rocker_docker_config
      RockerDockerConfig.to_hash.map do |k, v|
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
      private :load_from_rocker_docker_config
    end
  end
end
