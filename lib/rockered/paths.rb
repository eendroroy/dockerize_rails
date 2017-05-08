module Rockered
  module PATHS
    def self.root
      File.expand_path '../..', File.dirname(__FILE__)
    end

    def self.current
      Dir.pwd
    end

    def self.resources
      File.join(root, 'resources')
    end

    def self.config
      File.join(current, CONFIG_DIRECTORY_NAME)
    end

    def self.rockered_config_file
      File.join(current, '.rockered.yml')
    end

    def self.relative(base, target)
      Pathname.new(target).relative_path_from(Pathname.new(base)).to_s
    end

    def self.relative_from_current(target)
      relative(current, target)
    end
  end
end
