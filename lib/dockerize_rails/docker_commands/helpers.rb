module DockerizeRails
  module DockerCommands
    module Helpers
      def self.docker_compose_parser
        docker_compose = YAML.load_file '/Users/indrajit/IFC/docker-compose.yml'
        docker_compose['services']
      end
    end
  end
end
