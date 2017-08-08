module DockerizeRails
  module DockerCommands
    module DockerStart
      def self.start_rails
        services = DockerizeRails::DockerCommands::Helpers.get_services_from_docker_compose
        docker_start(services['rails'], "#{DRConfig.application_name}_rails:#{DRConfig.application_env}") \
        if services.has_key? 'rails'
        0
      rescue Docker::Error::NotFoundError => exception
        puts
        puts exception.to_s.red
        puts
        1
      end

      def self.start_mysql
        if DRConfig.linked_database? && DRConfig.databases[DRConfig.application_env] == 'mysql'
          services = DockerizeRails::DockerCommands::Helpers.get_services_from_docker_compose
          docker_start(services['mysql'], "#{DRConfig.application_name}_mysql:#{DRConfig.application_env}") \
          if services.has_key? 'mysql'
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
          services = DockerizeRails::DockerCommands::Helpers.get_services_from_docker_compose
          docker_start(services['postgresql'], "#{DRConfig.application_name}_postgres:#{DRConfig.application_env}") \
          if services.has_key? 'postgresql'
        end
        0
      rescue Docker::Error::NotFoundError => exception
        puts
        puts exception.to_s.red
        puts
        1
      end

      def self.docker_start(service, image_name)
        options = {}
        options['Image'] = image_name
        options['name'] = "#{image_name.split(':')[0]}_container"
        options['ExposedPorts'] = { "#{service['expose']}/tcp" => {} } if service.has_key? 'expose'
        if service.has_key? 'ports'
          options['HostConfig'] = {}
          options['HostConfig']['PortBindings'] = Hash[service['ports'].map do |x|
            ["#{x.split(':')[0]}/tcp", [{'HostPort' => x.split(':')[1]}]]
          end]
        end
        if service.has_key? 'volumes'
          options['Volumes'] = Hash[service['volumes'].map do |x|
            source = x.split(':')[0].start_with?('/') ? x.split(':')[0] : File.join(
              DockerizeRails::PATHS.current, x.split(':')[0]
            )
            [ "#{source}", { x.split(':')[1] => x.length > 2 ? x.split(':')[2] : 'rw' } ]
          end]
        end
        # if service.has_key? 'environment'
        #   options['Environments'] = Hash[service['environment'].map do |x|
        #     [ x.split('=')[0], x.split('=')[1] ]
        #   end]
        # end
        if service.has_key? 'environment'
          options['Env'] = service['environment']
        end
        puts options
        container = Docker::Container.create options
        container.start
      end
    end
  end
end
