module DockerizeRails
  module Constants
    SHELL_SCRIPT_FILE_NAME = 'dockerw'.freeze

    CONFIG_FILE_NAME = '.dockerize.yml'.freeze
    DOCKER_COMPOSE_FILE_NAME = 'docker-compose.yml'.freeze
    DOCKERIGNORE_FILE_NAME = '.dockerignore'.freeze

    RAILS_DIRECTORY_NAME = 'rails'.freeze
    MYSQL_DIRECTORY_NAME = 'mysql'.freeze
    PG_DIRECTORY_NAME = 'postgresql'.freeze
    CONFIG_DIRECTORY_NAME = '.dockerized'.freeze
    DATA_DIRECTORY_NAME = 'data_dir'.freeze
    SQL_DIRECTORY_NAME = 'sql'.freeze

    DATABASE_HOST_LINKED = 'linked'.freeze
    DATABASE_HOST_REMOTE = 'remote'.freeze

    COMMANDS = {
      configure: {
        aliases: %I[configure c rc cr],
        help: "Generates '#{CONFIG_FILE_NAME}'".freeze,
        params: {
          :'--tiny' => 'generates shorter config file, skipping all descriptions'.freeze
        }
      },
      dockerize: {
        aliases: %I[dockerize dc d],
        help: 'Generates docker config files'.freeze,
        params: {
          :'--test-env' => 'generates configurations to run tests.'.freeze
        }
      },
      undockerize: {
        aliases: %I[undockerize ud du u dd],
        help: 'Removes docker configurations'.freeze,
        params: {
          :'--purge' => "also removes #{CONFIG_FILE_NAME}".freeze
        }
      },
      docker_info: {
        aliases: %I[docker_info info],
        help: 'Shows Docker information'.freeze
      },
      docker_pull: {
        aliases: %I[docker_pull pull],
        help: 'Pulls Docker images'.freeze
      },
      docker_build: {
        aliases: %I[docker_build build],
        help: 'Builds Docker images'.freeze
      },
      docker_start: {
        aliases: %I[docker_start start],
        help: 'Run Docker containers'.freeze
      },
      docker_stop: {
        aliases: %I[docker_stop stop],
        help: 'Run Docker containers'.freeze
      },
      help: {
        aliases: %I[help h],
        help: 'Prints this message'.freeze
      }
    }.freeze
  end
end
