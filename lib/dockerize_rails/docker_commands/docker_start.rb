module DockerizeRails
  module DockerCommands
    module DockerStart
      def self.start_rails
        services = DockerHelpers.services_from_docker_compose
        begin
          container = Docker::Container.get(DockerHelpers.get_name(:rails, :container))
          if container.info['State']['Running']
            puts " ==> Container >#{DockerHelpers.get_name(:rails, :container)}< already running.".yellow
          else
            docker_start_container(container, services['rails'], :rails)
            puts " ==> Container >#{DockerHelpers.get_name(:rails, :container)}< started successfully".green
          end
          0
        rescue Docker::Error::NotFoundError
          services.key?('rails') && docker_start(services['rails'], :rails)
          puts " ==> Container >#{DockerHelpers.get_name(:rails, :container)}< started successfully".green
          0
        rescue Docker::Error::NotFoundError => exception
          puts
          puts exception.to_s.red
          puts
          1
        end
      end

      def self.start_mysql
        return 0 unless DRConfig.linked_database? && DRConfig.databases[DRConfig.application_env] == 'mysql'
        services = DockerHelpers.services_from_docker_compose
        begin
          container = Docker::Container.get(DockerHelpers.get_name(:mysql, :container))
          if container.info['State']['Running']
            puts " ==> Container >#{DockerHelpers.get_name(:mysql, :container)}< already running.".yellow
          else
            docker_start_container(container, services['mysql'], :mysql)
            puts " ==> Container >#{DockerHelpers.get_name(:mysql, :container)}< started successfully".green
          end
          0
        rescue Docker::Error::NotFoundError
          services.key?('mysql') && docker_start(services['mysql'], :mysql)
          puts " ==> Container >#{DockerHelpers.get_name(:mysql, :container)}< started successfully".green
          0
        rescue Docker::Error::NotFoundError => exception
          puts
          puts exception.to_s.red
          puts
          1
        end
      end

      def self.start_postgres
        return 0 unless DRConfig.linked_database? && DRConfig.databases[DRConfig.application_env] == 'postgresql'
        services = DockerHelpers.services_from_docker_compose
        begin
          container = Docker::Container.get(DockerHelpers.get_name(:postgres, :container))
          if container.info['State']['Running']
            puts " ==> Container >#{DockerHelpers.get_name(:postgres, :container)}< already running.".yellow
          else
            docker_start_container(container, services['postgresql'], :postgres)
            puts " ==> Container >#{DockerHelpers.get_name(:postgres, :container)}< started successfully".green
          end
          0
        rescue Docker::Error::NotFoundError
          services.key?('postgresql') && docker_start(services['postgresql'], :postgres)
          puts " ==> Container >#{DockerHelpers.get_name(:postgres, :container)}< started successfully".green
          0
        rescue Docker::Error::NotFoundError => exception
          puts
          puts exception.to_s.red
          puts
          1
        end
      end

      def self.docker_start_container(container, definitions, service)
        options = DockerHelpers.build_options(definitions, service)
        container.start(options)
      end

      def self.docker_start(definitions, service)
        options = DockerHelpers.build_options(definitions, service)
        container = Docker::Container.create options
        binds =
          if definitions.key? 'volumes'
            { 'Binds' => definitions['volumes'].map do |volume|
              [if volume.split(':')[0].start_with?('/')
                 volume.split(':')[0]
               else
                 File.join(PATHS.current, volume.split(':')[0])
               end,
               volume.split(':')[1],
               volume.length > 2 ? volume.split(':')[2] : 'rw'].join(':')
            end }
          end
        container.start binds
      end

      class << self
        private :docker_start
        private :docker_start_container
      end
    end
  end
end
