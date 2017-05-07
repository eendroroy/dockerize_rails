module Rockered
  module ConfigHelper
    require 'yaml'

    def self.read_app_config
      YAML.load_file(File.join(PATHS.current, 'config/database.yml'))
    end

    def self.read_rockered_config(command)
      return YAML.load_file(PATHS.rockered_config_file) if File.exist? PATHS.rockered_config_file
      commands = Helpers.processed_commands
      return nil if commands[:configure_rockered].include?(command) || commands[:help].include?(command)
      puts "Rockered not yet configured\nRun 'bundle exec rock cr' to configure rockered.".red
      puts Helpers.help
      exit(1)
    end
  end
end
