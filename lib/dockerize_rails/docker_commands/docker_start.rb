module DockerizeRails
  module DockerCommands
    module DockerStart
      def self.start_rails
        Docker::Container.get(Helpers.get_name(:rails, :container))
        puts " ==> Container >#{Helpers.get_name(:rails, :container)}< already running.".yellow
        1
      rescue Docker::Error::NotFoundError
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
        Docker::Container.get(Helpers.get_name(:mysql, :container))
        puts " ==> Container >#{Helpers.get_name(:mysql, :container)}< already running.".yellow
        1
      rescue Docker::Error::NotFoundError
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
        Docker::Container.get(Helpers.get_name(:postgres, :container))
        puts " ==> Container >#{Helpers.get_name(:postgres, :container)}< already running.".yellow
        1
      rescue Docker::Error::NotFoundError
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

      # rubocop:disable Metrics/AbcSize
      def self.docker_start(definitions, service)
        options = build_options(definitions, service)
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
        container.start binds
      end
      # rubocop:enable Metrics/AbcSize

      # rubocop:disable Metrics/AbcSize
      # rubocop:disable Metrics/MethodLength
      def self.build_options(definitions, service)
        options = Helpers.recurse_merge(
          {
            'Image' => Helpers.get_name(service, :image),
            'name' => Helpers.get_name(service, :container),
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
        options = Helpers.recurse_merge(
          options,
          if definitions.key?('ports')
            { 'HostConfig' => { 'PortBindings' => Hash[definitions['ports'].map do |ports|
              ["#{ports.split(':')[0]}/tcp", [{ 'HostPort' => ports.split(':')[1] }]]
            end] } }
          else
            {}
          end
        )
        options = Helpers.recurse_merge(
          options,
          definitions.key?('environment') ? { 'Env' => definitions['environment'] } : {}
        )
        options = Helpers.recurse_merge(
          options,
          if definitions.key?('links')
            { 'HostConfig' => { 'Links' => definitions['links'].map do |link|
              puts link, link.split(':')[1].to_sym
              "#{Helpers.get_name(link.split(':')[0].to_sym, :container)}:#{link.split(':')[1]}"
            end } }
          else
            {}
          end
        )
        options
      end
      # rubocop:enable Metrics/AbcSize
      # rubocop:enable Metrics/MethodLength
    end
  end
end
