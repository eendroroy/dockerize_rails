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
      image = Docker::Image.build_from_dir(
        '.',
        dockerfile: "#{Constants::CONFIG_DIRECTORY_NAME}/#{Constants::RAILS_DIRECTORY_NAME}/Dockerfile"
      )
      image.tag(repo: "#{DRConfig.application_name}_rails", tag: "#{DRConfig.application_env}")
      puts "Image '#{DRConfig.application_name}_rails:#{DRConfig.application_env}' build success".green
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
        image = Docker::Image.build_from_dir(
          '.',
          dockerfile: "#{Constants::CONFIG_DIRECTORY_NAME}/#{Constants::MYSQL_DIRECTORY_NAME}/Dockerfile"
        )
        image.tag(repo: "#{DRConfig.application_name}_mysql", tag: "#{DRConfig.application_env}")
        puts "Image '#{DRConfig.application_name}_mysql:#{DRConfig.application_env}' build success".green
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
        image = Docker::Image.build_from_dir(
          '.',
          dockerfile: "#{Constants::CONFIG_DIRECTORY_NAME}/#{Constants::PG_DIRECTORY_NAME}/Dockerfile"
        )
        image.tag(repo: "#{DRConfig.application_name}_postgres", tag: "#{DRConfig.application_env}")
        puts "Image '#{DRConfig.application_name}_postgres:#{DRConfig.application_env}' build success".green
      end
      0
    rescue Docker::Error::NotFoundError => e
      puts
      puts e.to_s.red
      puts
      1
    end

    class << self
      private :build_mysql
      private :build_postgres
      private :pull_mysql
      private :pull_postgres
    end
  end
end
