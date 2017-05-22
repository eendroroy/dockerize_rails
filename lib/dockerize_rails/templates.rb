module DockerizeRails
  module Templates
    ROOT_TEMPLATES = %W[
      #{Constants::DOCKERIGNORE_FILE_NAME}
      #{Constants::DOCKER_COMPOSE_FILE_NAME}
      #{Constants::SHELL_SCRIPT_FILE_NAME}
    ].freeze

    RAILS_TEMPLATES = %w[Dockerfile entry-point.sh secrets.yml].freeze
    MYSQL_TEMPLATES = %W[Dockerfile #{Constants::SQL_DIRECTORY_NAME}/initdb-mysql.sql].freeze
    POSTGRES_TEMPLATES = %w[Dockerfile].freeze

    ROOT_DIRECTORIES = %W[#{Constants::CONFIG_DIRECTORY_NAME}].freeze
    RAILS_DIRECTORIES = %W[#{Constants::CONFIG_DIRECTORY_NAME}/#{Constants::RAILS_DIRECTORY_NAME}].freeze
    MYSQL_DIRECTORIES = %W[
      #{Constants::CONFIG_DIRECTORY_NAME}/#{Constants::MYSQL_DIRECTORY_NAME}
      #{Constants::CONFIG_DIRECTORY_NAME}/#{Constants::MYSQL_DIRECTORY_NAME}/#{Constants::SQL_DIRECTORY_NAME}
      #{Constants::CONFIG_DIRECTORY_NAME}/#{Constants::MYSQL_DIRECTORY_NAME}/#{Constants::DATA_DIRECTORY_NAME}
    ].freeze
    PG_DIRECTORIES = %W[
      #{Constants::CONFIG_DIRECTORY_NAME}/#{Constants::PG_DIRECTORY_NAME}
      #{Constants::CONFIG_DIRECTORY_NAME}/#{Constants::PG_DIRECTORY_NAME}/#{Constants::DATA_DIRECTORY_NAME}
    ].freeze

    EXECUTABLES = %W[#{Constants::SHELL_SCRIPT_FILE_NAME}].freeze
  end
end
