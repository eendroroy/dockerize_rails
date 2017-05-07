module Rockered
  module ConfigGenerator
    CONFIG_DIR_NAME = 'docker'.freeze

    def self.create_configs
      create_config_directory
    end

    def self.create_config_directory
      puts PATHS.root
      puts PATHS.current
      puts PATHS.resources
    end
  end
end
