module DockerizeRails
  module DockerCommands
    module DockerStop
      def self.stop_rails
        docker_stop DockerHelpers.get_name(:rails, :container)
      end

      def self.stop_mysql
        if DRConfig.linked_database? && DRConfig.databases[DRConfig.application_env] == 'mysql'
          return docker_stop DockerHelpers.get_name(:mysql, :container)
        end
        0
      end

      def self.stop_postgres
        if DRConfig.linked_database? && DRConfig.databases[DRConfig.application_env] == 'postgresql'
          return docker_stop DockerHelpers.get_name(:postgres, :container)
        end
        0
      end

      def self.docker_stop(container_name)
        container = Docker::Container.get(container_name)
        if container.info['State']['Running']
          container.stop
          container.delete(force: true) if DRNameSpace.namespace.delete_containers
          puts "Container >#{container_name}< stopped successfully.".green
          puts "Container >#{container_name}< deleted successfully.".green if DRNameSpace.namespace.delete_containers
        else
          puts "Container >#{container_name}< is not running.".blue
        end
        0
      rescue Docker::Error::NotFoundError => exception
        puts exception.to_s.strip.red
        1
      end

      class << self
        private :docker_stop
      end
    end
  end
end
