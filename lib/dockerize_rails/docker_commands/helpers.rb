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

      # rubocop:disable Metrics/AbcSize
      # rubocop:disable Metrics/MethodLength
      def self.build_options(definitions, service)
        options = recurse_merge(
            {
                'Image' => get_name(service, :image),
                'name' => get_name(service, :container),
                'Hostname' => '0.0.0.0'
            },
            if definitions.key?('expose')
              {
                  'ExposedPorts' => Hash[definitions['expose'].map { |ports| ["#{ports}/tcp", {}] }],
                  'HostConfig' => { 'PortBindings' => Hash[definitions['expose'].map { |ports| ["#{ports}/tcp", [{}]] }] }
              }
            else
              {}
            end
        )
        options = recurse_merge(
            options,
            if definitions.key?('ports')
              { 'HostConfig' => { 'PortBindings' => Hash[definitions['ports'].map do |ports|
                ["#{ports.split(':')[0]}/tcp", [{ 'HostPort' => ports.split(':')[1] }]]
              end] } }
            else
              {}
            end
        )
        options = recurse_merge(
            options,
            definitions.key?('environment') ? { 'Env' => definitions['environment'] } : {}
        )
        options = recurse_merge(
            options,
            if definitions.key?('links')
              { 'HostConfig' => { 'Links' => definitions['links'].map do |link|
                "#{get_name(link.split(':')[0].to_sym, :container)}:#{link.split(':')[1]}"
              end } }
            else
              {}
            end
        )
        options
      end
      # rubocop:enable Metrics/AbcSize
      # rubocop:enable Metrics/MethodLength

      def self.print_version
        docker_version = DockerCommands.version

        DockerizeRails::Helpers.print_formatted_info('Docker Version', "#{docker_version['Version']}\n")
        DockerizeRails::Helpers.print_formatted_info(
          'API',
          "#{docker_version['ApiVersion']} : #{docker_version['MinAPIVersion']}\n"
        )
        DockerizeRails::Helpers.print_formatted_info('Git Commit', "#{docker_version['GitCommit']}\n")
        DockerizeRails::Helpers.print_formatted_info('Go Version', "#{docker_version['GoVersion']}\n")
        # DockerizeRails::Helpers.print_formatted_info('OS', "#{v['Os']}_#{v['Arch']}_#{v['KernelVersion']}\n")
        DockerizeRails::Helpers.print_formatted_info('Experimental', "#{docker_version['Experimental']}\n")
        DockerizeRails::Helpers.print_formatted_info(
          'Build Time',
         "#{DateTime.parse(docker_version['BuildTime']).strftime('%b %d, %Y %I:%M %p')}\n"
        )
      end
    end
  end
end
