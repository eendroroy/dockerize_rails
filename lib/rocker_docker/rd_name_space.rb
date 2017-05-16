module RockerDocker
  class RDNameSpace
    require 'ostruct'

    @namespace = OpenStruct.new

    attr_reader :namespace

    def self.load
      RDConfig.load_rocker_docker_config
      load_from_app_config
      load_from_rocker_docker_config
    end

    def self.load_from_app_config
      app_c = ConfigLoader.app_config
      @namespace.databases = {}
      app_c.keys.each do |env|
        @namespace.databases[env] = 'mysql' if app_c[env]['adapter'].start_with?('mysql')
        @namespace.databases[env] = 'postgresql' if app_c[env]['adapter'].start_with?('postgresql')
        @namespace.databases[env] = 'sqlite' if app_c[env]['adapter'].start_with?('sqlite')
      end
      RDConfig.databases = @namespace.databases
    end

    def self.load_from_rocker_docker_config
      RDConfig.to_hash.map do |k, v|
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
