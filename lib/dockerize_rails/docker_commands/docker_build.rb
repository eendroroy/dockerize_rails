module DockerizeRails
  module DockerCommands
    module DockerBuild
      def self.build_rails
        if Docker::Image.exist? DockerHelpers.get_name(:rails, :image)
          if DRNameSpace.namespace.rebuild
            image = Docker::Image.get DockerHelpers.get_name(:rails, :image)
            puts " ==> Removing Image: #{DockerHelpers.get_name(:rails, :image)}".blue
            image.remove( force: DRNameSpace.namespace.force || false)
          else
            puts " ==> Image >#{DockerHelpers.get_name(:rails, :image)}< already exists".green
            return 0
          end
        end
        build_docker_image(
            "#{Constants::CONFIG_DIRECTORY_NAME}/#{Constants::RAILS_DIRECTORY_NAME}/Dockerfile",
            DockerHelpers.get_name(:rails, :image)
        )
        puts " ==> Image >#{DockerHelpers.get_name(:rails, :image)}< built successfully".green
        0
      rescue Docker::Error::NotFoundError => exception
        puts
        puts exception.to_s.red
        puts
        1
      end

      def self.build_mysql
        if DRConfig.linked_database? && DRConfig.databases[DRConfig.application_env] == 'mysql'
          if Docker::Image.exist? DockerHelpers.get_name(:mysql, :image)
            if DRNameSpace.namespace.rebuild
              image = Docker::Image.get DockerHelpers.get_name(:mysql, :image)
              puts " ==> Removing Image: #{DockerHelpers.get_name(:mysql, :image)}".blue
              image.remove( force: DRNameSpace.namespace.force || false)
            else
              puts " ==> Image >#{DockerHelpers.get_name(:mysql, :image)}< already exists".green
              return 0
            end
          end
          build_docker_image(
              "#{Constants::CONFIG_DIRECTORY_NAME}/#{Constants::MYSQL_DIRECTORY_NAME}/Dockerfile",
              DockerHelpers.get_name(:mysql, :image)
          )
          puts " ==> Image >#{DockerHelpers.get_name(:mysql, :image)}< built successfully".green
        end
        0
      rescue Docker::Error::NotFoundError => exception
        puts
        puts exception.to_s.red
        puts
        1
      end

      def self.build_postgres
        if DRConfig.linked_database? && DRConfig.databases[DRConfig.application_env] == 'postgresql'
          if Docker::Image.exist? DockerHelpers.get_name(:postgres, :image)
            if DRNameSpace.namespace.rebuild
              image = Docker::Image.get DockerHelpers.get_name(:postgres, :image)
              puts " ==> Removing Image: #{DockerHelpers.get_name(:postgres, :image)}".blue
              image.remove( force: DRNameSpace.namespace.force || false)
            else
              puts " ==> Image >#{DockerHelpers.get_name(:postgres, :image)}< already exists".green
              return 0
            end
          end
          build_docker_image(
              "#{Constants::CONFIG_DIRECTORY_NAME}/#{Constants::PG_DIRECTORY_NAME}/Dockerfile",
              DockerHelpers.get_name(:postgres, :image)
          )
          puts " ==> Image >#{DockerHelpers.get_name(:postgres, :image)}< built successfully".green
        end
        0
      rescue Docker::Error::NotFoundError => exception
        puts
        puts exception.to_s.red
        puts
        1
      end

      def self.build_docker_image(dockerfile, repo)
        image = Docker::Image.build_from_dir('.', dockerfile: dockerfile) do |v|
          if DRNameSpace.namespace.stream_log
            if (log = JSON.parse(v)) && log.has_key?('stream')
              $stdout.puts log['stream']
            end
          end
        end
        image.tag(repo: repo, tag: DRConfig.application_env)
        puts "Image '#{repo}:#{DRConfig.application_env}' build success".green
        0
      rescue Docker::Error::UnexpectedResponseError => _
        puts
        puts " ==> An error has occurred while building Image: #{repo}:#{DRConfig.application_env}".red
        puts
        1
      rescue Excon::Error::Socket => exception
        puts
        puts exception.to_s.red
        puts
        1
      rescue Docker::Error::NotFoundError => exception
        puts
        puts exception.to_s.red
        puts
        1
      end

      class << self
        private :build_docker_image
      end
    end
  end
end
