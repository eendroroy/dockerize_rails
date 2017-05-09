module RockerDocker
  class RockerDockerConfig
    @application_name     = 'rocker_docker'

    @rails_version        = 'latest'
    @application_env      = 'development'
    @application_port     = '5000'

    @postgres_version     = 'alpine'
    @mysql_version        = 'latest'

    @db_root_pass         = 'root'
    @database_host_name   = 'db'
    @database_user_name   = 'user'
    @database_user_pass   = 'pass'

    def self.load_rocker_docker_config
      if File.exist? File.join(PATHS.current, ROCKER_DOCKER_CONFIG_FILE_NAME)
        rocker_docker_config = YAML.load_file(File.join(PATHS.current, ROCKER_DOCKER_CONFIG_FILE_NAME))
        %w[
          application_name rails_version application_env application_port postgres_version mysql_version
          db_root_pass database_host_name database_user_name database_user_pass database_name_prefix
        ].each do |attr|
          send("#{attr}=", rocker_docker_config[attr]) unless rocker_docker_config[attr].nil?
        end
      else
        puts "\nRockerDocker config file not generated...".yellow
        puts "Run 'bundle exec rocker configure' to generate configuration file.\n".yellow
      end
    end

    def self.to_yaml_str
      "---
# Set application name
#
# Default is #{application_name}
application_name: #{application_name}

# Set rails version
# Visit: https://hub.docker.com/_/rails/ for list of available versions
#
# Default is #{rails_version}
rails_version: #{rails_version}

# Set docker container's rails environment to production, staging, or development
#
# Default is #{application_env}
application_env: #{application_env}

# Set docker container's rails port
# If you have any application running on a specific port, suppose 80, then don't use port 80 as container port
#
# Default #{application_port}
application_port: #{application_port}

# Set root password for docker database container
# it doesn't make any changes in your computer's database
#
# Default #{db_root_pass}
db_root_pass: #{db_root_pass}

# Set postgres database version if application uses postgres
# Visit: https://hub.docker.com/_/postgres/ for list of available versions
#
# Default is #{postgres_version}
postgres_version: #{postgres_version}

# Set mysql database version if application uses mysql
# Visit: https://hub.docker.com/_/mysql/ for list of available versions
#
# Default is #{mysql_version}
mysql_version: #{mysql_version}

# Set database properties

# Default #{database_host_name}
database_host_name: #{database_host_name}

# Default #{database_user_name}
database_user_name: #{database_user_name}

# Default #{database_user_pass}
database_user_pass: #{database_user_pass}

"
    end

    def self.to_hash
      {
        application_name: application_name,
        rails_version: rails_version,
        application_env: application_env,
        application_port: application_port,
        postgres_version: postgres_version,
        mysql_version: mysql_version,
        db_root_pass: db_root_pass,
        database_host_name: database_host_name,
        database_user_name: database_user_name,
        database_user_pass: database_user_pass
      }
    end

    class << self
      attr_accessor :application_name
      attr_accessor :rails_version
      attr_accessor :application_env
      attr_accessor :application_port
      attr_accessor :postgres_version
      attr_accessor :mysql_version
      attr_accessor :db_root_pass
      attr_accessor :database_host_name
      attr_accessor :database_user_name
      attr_accessor :database_user_pass
    end
  end
end
