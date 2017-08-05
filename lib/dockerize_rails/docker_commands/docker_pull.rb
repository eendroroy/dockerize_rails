module DockerizeRails
  module DockerCommands
    module DockerPull
      def self.pull_ruby
        pull_docker_image('ruby', DRConfig.ruby_version)
        0
      rescue Docker::Error::NotFoundError => e
        puts
        puts e.to_s.red
        puts
        1
      end

      def self.pull_mysql
        if DRConfig.linked_database? && DRConfig.databases[DRConfig.application_env] == 'mysql'
          pull_docker_image('mysql', DRConfig.mysql_version)
        end
        0
      rescue Docker::Error::NotFoundError => e
        puts
        puts e.to_s.red
        puts
        1
      end

      def self.pull_postgres
        if DRConfig.linked_database? && DRConfig.databases[DRConfig.application_env] == 'postgresql'
          pull_docker_image('postgres', DRConfig.postgres_version)
        end
        0
      rescue Docker::Error::NotFoundError => e
        puts
        puts e.to_s.red
        puts
        1
      end

      def self.pull_docker_image(image_name, tag)
        Docker::Image.create('fromImage' => "#{image_name}:#{tag}")
        puts "Base image '#{image_name}:#{tag}' ready".green
        0
      rescue Docker::Error::NotFoundError => e
        puts
        puts e.to_s.red
        puts
        1
      end

      class << self
        private :pull_docker_image
      end
    end
  end
end
