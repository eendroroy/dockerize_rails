module RockerDocker
  module Constants
    COMMANDS = {
      configure: {
        aliases: %I[configure c rc cr],
        help: 'Generates \'.rocker_docker.yml\''.freeze
      },
      dockerize: {
        aliases: %I[dockerize rock dc d],
        help: 'Generates docker config files'.freeze
      },
      docker_info: {
        aliases: %I[docker_info di],
        help: 'Shows Docker information'.freeze
      },
      undockerize: {
        aliases: %I[undockerize ud du u dd],
        help: 'Removes docker configurations'.freeze
      },
      help: {
        aliases: %I[help h],
        help: 'prints this message'.freeze
      }
    }.freeze

    ROCKER_DOCKER_CONFIG_FILE_NAME = '.rocker_docker.yml'.freeze
    DOCKER_COMPOSE_FILE_NAME = 'docker-compose.yml'.freeze
    DOCKERIGNORE_FILE_NAME = '.dockerignore'.freeze

    RAILS_DIRECTORY_NAME = 'rails'.freeze
    MYSQL_DIRECTORY_NAME = 'mysql'.freeze
    PG_DIRECTORY_NAME = 'postgresql'.freeze
    CONFIG_DIRECTORY_NAME = '.rocker_docker'.freeze
    DATA_DIRECTORY_NAME = 'data_dir'.freeze
    SQL_DIRECTORY_NAME = 'sql'.freeze
  end
end
