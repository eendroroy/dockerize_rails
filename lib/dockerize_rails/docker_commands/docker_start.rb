module DockerizeRails
  module DockerCommands
    module DockerStart
      def self.start_rails
        services = DockerizeRails::DockerCommands::Helpers.services_from_docker_compose
        services.key?('rails') && docker_start(services['rails'], :rails)
        0
      rescue Docker::Error::NotFoundError => exception
        puts
        puts exception.to_s.red
        puts
        1
      end

      def self.start_mysql
        if DRConfig.linked_database? && DRConfig.databases[DRConfig.application_env] == 'mysql'
          services = DockerizeRails::DockerCommands::Helpers.services_from_docker_compose
          services.key?('mysql') && docker_start(services['mysql'], :mysql)
        end
        0
      rescue Docker::Error::NotFoundError => exception
        puts
        puts exception.to_s.red
        puts
        1
      end

      def self.start_postgres
        if DRConfig.linked_database? && DRConfig.databases[DRConfig.application_env] == 'postgresql'
          services = DockerizeRails::DockerCommands::Helpers.services_from_docker_compose
          services.key?('postgresql') && docker_start(services['postgresql'], :postgres)
        end
        0
      rescue Docker::Error::NotFoundError => exception
        puts
        puts exception.to_s.red
        puts
        1
      end

      def self.docker_start(definitions, service)
        options = build_options(definitions, service)
        puts options
        container = Docker::Container.create options
        binds =
          if definitions.key? 'volumes'
            { 'Binds' => definitions['volumes'].map do |volume|
                [if volume.split(':')[0].start_with?('/')
                  volume.split(':')[0]
                else
                  File.join(DockerizeRails::PATHS.current, volume.split(':')[0])
                end,
                volume.split(':')[1],
                volume.length > 2 ? volume.split(':')[2] : 'rw'].join(':')
            end }
          end
        puts binds
        container.start binds
      end

      def self.build_options(definitions, service)
        {
          'Image' => Helpers.get_name(service, :image), 'name' => Helpers.get_name(service, :container)
        }.merge(
          definitions.key?('expose') ? { 'ExposedPorts' => { "#{definitions['expose']}/tcp" => {} } } : {}
        ).merge(
          if definitions.key?('ports')
            { 'HostConfig' => { 'PortBindings' => Hash[definitions['ports'].map do |ports|
              ["#{ports.split(':')[0]}/tcp", [{ 'HostPort' => ports.split(':')[1] }]]
            end] } }
          else
            {}
          end
        ).merge(
          definitions.key?('environment') ? { 'Env' => definitions['environment'] } : {}
        ).merge(
          if definitions.key?('links')
            { 'Links' => definitions['links'].map do |link|
              puts link, link.split(':')[1].to_sym
              "#{link.split(':')[1]}:#{Helpers.get_name(link.split(':')[0].to_sym, :container)}"
            end }
          else
            {}
          end
        )
      end
    end
  end
end
