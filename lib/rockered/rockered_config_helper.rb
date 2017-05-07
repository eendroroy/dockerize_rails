module Rockered
  module ConfigParser
    require 'yaml'

    def self.read_app_config
      YAML.load_file(File.join(PATHS.current, 'config/database.yml'))
    end

    class << self
      private :read_config
    end
  end
end
