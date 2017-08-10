module DockerizeRails
  module DockerCommands
    module Helpers
      NAMES = {
        image: {
          rails: "#{DRConfig.application_name}_rails:#{DRConfig.application_env}".freeze,
          mysql: "#{DRConfig.application_name}_mysql:#{DRConfig.application_env}".freeze,
          postgres: "#{DRConfig.application_name}_postgres:#{DRConfig.application_env}".freeze
        }.freeze,
        container: {
          rails: "#{DRConfig.application_name}_rails_container".freeze,
          mysql: "#{DRConfig.application_name}_mysql_container".freeze,
          postgres: "#{DRConfig.application_name}_postgres_container".freeze
        }.freeze
      }.freeze

      def self.get_name(service, type)
        NAMES[type][service]
      end

      def self.services_from_docker_compose
        docker_compose = YAML.load_file "#{DockerizeRails::PATHS.current}/docker-compose.yml"
        docker_compose['services']
      end

      def self.recurse_merge(first, second)
        first.merge(second) do |_, first_element, second_element|
          if first_element.is_a?(Hash) && second_element.is_a?(Hash)
            recurse_merge(first_element, second_element)
          else
            [*first_element, *second_element]
          end
        end
      end
    end
  end
end
