module Rockered
  module ConfigParser
    def self.config
      read_config
    end

    def self.read_config
      'config'
    end

    class << self
      private :read_config
    end
  end
end
