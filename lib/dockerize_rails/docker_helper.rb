module DockerizeRails
  module DockerHelper
    require 'docker'

    def self.version
      Docker.version
    end
  end
end
