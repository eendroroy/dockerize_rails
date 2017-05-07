module Rockered
  module ConfigHelper
    require 'yaml'

    def self.read_app_config
      YAML.load_file(File.join(PATHS.current, 'config/database.yml'))
    end
  end
end
