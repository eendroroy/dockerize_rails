module DockerizeRails
  module DockerCommands
    module Helpers
      NAMES = {
        image: {
          suffix: ":#{::DockerizeRails::DRConfig.application_env}",
          rails: "#{::DockerizeRails::DRConfig.application_name}_rails".freeze,
          mysql: "#{::DockerizeRails::DRConfig.application_name}_mysql".freeze,
          postgres: "#{::DockerizeRails::DRConfig.application_name}_postgres".freeze
        }.freeze,
        container: {
          suffix: '',
          rails: "#{::DockerizeRails::DRConfig.application_name}_rails_container".freeze,
          mysql: "#{::DockerizeRails::DRConfig.application_name}_mysql_container".freeze,
          postgres: "#{::DockerizeRails::DRConfig.application_name}_postgres_container".freeze
        }.freeze
      }.freeze

      def self.get_name(service, type)
        "#{NAMES[type][service]}#{NAMES[type][:suffix]}".freeze
      end

      def self.services_from_docker_compose
        docker_compose = YAML.load_file "#{::DockerizeRails::PATHS.current}/docker-compose.yml"
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

      # rubocop:disable Metrics/AbcSize
      # rubocop:disable Metrics/MethodLength
      def self.build_options(definitions, service)
        options = ::DockerizeRails::DockerCommands::DockerOptions.new
        options.image get_name(service, :image)
        options.name get_name(service, :container)
        options.hostname '0.0.0.0'
        definitions['expose'].each {|expose| options.expose expose} if definitions.key?('expose')
        definitions['environment'].each {|env| options.add_env env} if definitions.key?('environment')
        if definitions.key?('ports')
          definitions['ports'].each do |ports|
            options.add_port_binds(ports.split(':')[1], ports.split(':')[0])
          end
        end
        if definitions.key?('links')
          definitions['links'].each do |link|
            options.add_links(get_name(link.split(':')[0].to_sym, :container), link.split(':')[1])
          end
        end
        options.options
      end
      # rubocop:enable Metrics/AbcSize
      # rubocop:enable Metrics/MethodLength

      def self.print_version
        docker_version = ::DockerizeRails::DockerCommands.version

        ::DockerizeRails::Helpers.print_formatted_info('Docker Version', "#{docker_version['Version']}\n")
        ::DockerizeRails::Helpers.print_formatted_info(
          'API',
          "#{docker_version['ApiVersion']} : #{docker_version['MinAPIVersion']}\n"
        )
        ::DockerizeRails::Helpers.print_formatted_info('Git Commit', "#{docker_version['GitCommit']}\n")
        ::DockerizeRails::Helpers.print_formatted_info('Go Version', "#{docker_version['GoVersion']}\n")
        # ::DockerizeRails::Helpers.print_formatted_info('OS', "#{v['Os']}_#{v['Arch']}_#{v['KernelVersion']}\n")
        ::DockerizeRails::Helpers.print_formatted_info('Experimental', "#{docker_version['Experimental']}\n")
        ::DockerizeRails::Helpers.print_formatted_info(
          'Build Time',
         "#{DateTime.parse(docker_version['BuildTime']).strftime('%b %d, %Y %I:%M %p')}\n"
        )
      end
    end
  end
end
