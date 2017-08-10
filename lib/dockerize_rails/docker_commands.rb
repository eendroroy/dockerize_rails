module DockerizeRails
  module DockerCommands
    require 'docker'

    def self.version
      Docker.version
    end

    def self.pull
      status = 0
      status += DockerPull.pull_ruby
      status += DockerPull.pull_mysql
      status += DockerPull.pull_postgres
      status
    rescue Docker::Error::NotFoundError => exception
      puts
      puts exception.to_s.red
      puts
      1
    end

    def self.build
      status = 0
      status += DockerBuild.build_rails
      status += DockerBuild.build_postgres
      status += DockerBuild.build_mysql
      status
    rescue Docker::Error::NotFoundError => exception
      puts
      puts exception.to_s.red
      puts
      1
    end

    def self.start
      status = 0
      status += DockerStart.start_mysql
      status += DockerStart.start_postgres
      # puts
      # (0..29).each do |i|
      #   printf "\r => waiting for database server to start properly #{30 - i} ..."
      #   $stdout.flush
      #   sleep 1
      # end
      puts
      status += DockerStart.start_rails
      status
    rescue Docker::Error::NotFoundError => exception
      puts
      puts exception.to_s.red
      puts
      1
    end
  end
end
