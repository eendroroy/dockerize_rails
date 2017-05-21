module DockerizeRails
  module PATHS
    def self.gem_root
      File.expand_path '../..', File.dirname(__FILE__)
    end

    def self.current
      Dir.pwd
    end

    def self.rails_root?
      File.exist? File.join(current, 'bin', 'rails')
    end

    def self.resources(name = '')
      File.join(gem_root, 'resources', name)
    end

    def self.config_directory
      File.join(current, Constants::CONFIG_DIRECTORY_NAME)
    end

    def self.rails_directory
      File.join(config_directory, Constants::RAILS_DIRECTORY_NAME)
    end

    def self.mysql_directory
      File.join(config_directory, Constants::MYSQL_DIRECTORY_NAME)
    end

    def self.postgresql_directory
      File.join(config_directory, Constants::PG_DIRECTORY_NAME)
    end

    def self.data_directory(db_dir_name)
      File.join(config_directory, db_dir_name, Constants::DATA_DIRECTORY_NAME)
    end

    def self.sql_directory(db_dir_name)
      File.join(config_directory, db_dir_name, Constants::SQL_DIRECTORY_NAME)
    end

    def self.relative(base, target)
      Pathname.new(target).relative_path_from(Pathname.new(base)).to_s
    end

    def self.relative_from_current(target)
      relative(current, target)
    end
  end
end
