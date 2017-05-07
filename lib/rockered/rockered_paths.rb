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

    def self.config_dir
      File.join(current, 'docker')
    end
  end
end
