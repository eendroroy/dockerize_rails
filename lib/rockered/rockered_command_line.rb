module Rockered
  module CommandLine
    require 'colorize'

    def run
      create_config
    end

    private

    def create_config
      puts ConfigGenerator.create_configs
    end
  end
end
