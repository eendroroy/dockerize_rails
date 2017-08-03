module DockerizeRails
  module DockerHelper
    require 'docker'

    def self.version
      Docker.version
    end

    def self.pull
      status = 0
      Docker::Image.create('fromImage' => "ruby:#{DRConfig.ruby_version}")
      puts "Base image 'ruby:#{DRConfig.ruby_version}' ready".green
      status += pull_mysql
      status += pull_postgres
      status
    rescue Docker::Error::NotFoundError => e
      puts
      puts e.to_s.red
      puts
      1
    end

    def self.build
      status = 0
      Docker::Image.build_from_dir(
        '.',
        dockerfile: "#{Constants::CONFIG_DIRECTORY_NAME}/#{Constants::RAILS_DIRECTORY_NAME}/Dockerfile"
      )
      puts "Image 'ruby:#{DRConfig.ruby_version}' build success".green
      status += build_postgres
      status += build_mysql
      status
    rescue Docker::Error::NotFoundError => e
      puts
      puts e.to_s.red
      puts
      1
    end

    def self.pull_mysql
      if DRConfig.linked_database? && DRConfig.databases[DRConfig.application_env] == 'mysql'
        Docker::Image.create('fromImage' => "mysql:#{DRConfig.mysql_version}")
        puts "Base image 'mysql:#{DRConfig.mysql_version}' ready".green
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
        Docker::Image.create('fromImage' => "postgres:#{DRConfig.postgres_version}")
        puts "Base image 'postgres:#{DRConfig.postgres_version}' ready".green
      end
      0
    rescue Docker::Error::NotFoundError => e
      puts
      puts e.to_s.red
      puts
      1
    end

    def self.build_mysql
      if DRConfig.linked_database? && DRConfig.databases[DRConfig.application_env] == 'mysql'
        Docker::Image.build_from_dir(
          '.',
          dockerfile: "#{Constants::CONFIG_DIRECTORY_NAME}/#{Constants::MYSQL_DIRECTORY_NAME}/Dockerfile"
        )

        puts "Image 'mysql:#{DRConfig.mysql_version}' build success".green
      end
      0
    rescue Docker::Error::NotFoundError => e
      puts
      puts e.to_s.red
      puts
      1
    end

    def self.build_postgres
      if DRConfig.linked_database? && DRConfig.databases[DRConfig.application_env] == 'postgresql'
        Docker::Image.build_from_dir(
          '.',
          dockerfile: "#{Constants::CONFIG_DIRECTORY_NAME}/#{Constants::PG_DIRECTORY_NAME}/Dockerfile"
        )
        puts "Image 'postgres:#{DRConfig.postgres_version}' build success".green
      end
      0
    rescue Docker::Error::NotFoundError => e
      puts
      puts e.to_s.red
      puts
      1
    end

    # class << self
    #   private :build_mysql
    #   private :build_postgres
    #   private :pull_mysql
    #   private :pull_postgres
    # end
  end
end
