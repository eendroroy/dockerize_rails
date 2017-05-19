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
      databases = {}
      app_c.keys.each do |env|
        adapter = app_c[env]['adapter']
        databases[env] =
          if adapter.start_with?('mysql')
            'mysql'
          elsif adapter.start_with?('postgresql')
            'postgresql'
          elsif adapter.start_with?('sqlite')
            'sqlite'
          end
      end
      @namespace.databases = databases
      RDConfig.databases = databases
    end

    def self.load_from_rocker_docker_config
      RDConfig.to_hash.map do |key, value|
        @namespace.send("#{key}=", value)
      end
    end

    def self.add_hash(hash)
      hash.map do |key, value|
        @namespace.send("#{attr}=", rc[key] || value)
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
