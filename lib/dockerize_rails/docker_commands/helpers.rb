module DockerizeRails
  module DockerCommands
    module Helpers
      def self.services_from_docker_compose
        docker_compose = YAML.load_file "#{DockerizeRails::PATHS.current}/docker-compose.yml"
        docker_compose['services']
      end
    end
  end
end
