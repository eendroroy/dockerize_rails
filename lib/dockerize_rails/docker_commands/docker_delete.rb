module DockerizeRails
  module DockerCommands
    module DockerDelete
      def self.delete_rails
        docker_delete DockerHelpers.get_name(:rails, :container)
      end

      def self.delete_mysql
        if DRConfig.linked_database? && DRConfig.databases[DRConfig.application_env] == 'mysql'
          return docker_delete DockerHelpers.get_name(:mysql, :container)
        end
        0
      end

      def self.delete_postgres
        if DRConfig.linked_database? && DRConfig.databases[DRConfig.application_env] == 'postgresql'
          return docker_delete DockerHelpers.get_name(:postgres, :container)
        end
        0
      end

      def self.docker_delete(container_name)
        container = Docker::Container.get(container_name)
        container.stop if container.info['State']['Running']
        container.delete(force: true)
        puts "Container >#{container_name}< deleted successfully.".green
        0
      rescue Docker::Error::NotFoundError => exception
        puts exception.to_s.strip.red
        1
      end

      class << self
        private :docker_delete
      end
    end
  end
end
