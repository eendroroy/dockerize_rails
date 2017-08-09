module DockerizeRails
  module DockerCommands
    module DockerStart
      def self.start_rails
        services = DockerizeRails::DockerCommands::Helpers.services_from_docker_compose
        docker_start(services['rails'], "#{DRConfig.application_name}_rails:#{DRConfig.application_env}") \
        if services.key? 'rails'
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
          docker_start(services['mysql'], "#{DRConfig.application_name}_mysql:#{DRConfig.application_env}") \
          if services.key? 'mysql'
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
          docker_start(services['postgresql'], "#{DRConfig.application_name}_postgres:#{DRConfig.application_env}") \
          if services.key? 'postgresql'
        end
        0
      rescue Docker::Error::NotFoundError => exception
        puts
        puts exception.to_s.red
        puts
        1
      end

      def self.docker_start(service, image_name)
        options = build_options(service, image_name)
        puts options
        container = Docker::Container.create options
        container.start
      end

      def self.build_options(service, image_name)
        options = {}
        options['Image'] = image_name
        options['name'] = "#{image_name.split(':')[0]}_container"
        options['ExposedPorts'] = { "#{service['expose']}/tcp" => {} } if service.key? 'expose'
        if service.key? 'ports'
          options['HostConfig'] = {}
          options['HostConfig'] = {
            'PortBindings' => Hash[service['ports'].map do |ports|
              ["#{ports.split(':')[0]}/tcp", [{ 'HostPort' => ports.split(':')[1] }]]
            end]
          }
        end
        if service.key? 'volumes'
          options['Volumes'] = Hash[service['volumes'].map do |volume|
            source =
              if volume.split(':')[0].start_with?('/')
                volume.split(':')[0]
              else
                File.join(DockerizeRails::PATHS.current, volume.split(':')[0])
              end
            [source, { volume.split(':')[1] => volume.length > 2 ? volume.split(':')[2] : 'rw' }]
          end]
        end
        options['Env'] = service['environment'] if service.key? 'environment'
      end
    end
  end
end
