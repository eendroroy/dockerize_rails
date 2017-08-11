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
        puts " ==> Container >#{Helpers.get_name(:rails, :container)}< started successfully".green
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
          puts " ==> Container >#{Helpers.get_name(:mysql, :container)}< started successfully".green
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
          puts " ==> Container >#{Helpers.get_name(:postgres, :container)}< started successfully".green
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
        options = DockerCommands::Helpers.build_options(definitions, service)
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
    end
  end
end
