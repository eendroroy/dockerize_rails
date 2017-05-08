module Rockered
  COMMANDS = {
    configure: {
      aliases: %I[configure c rc cr],
      help: 'Generates \'.rockered.yml\''.freeze
    },
    dockerize: {
      aliases: %I[dockerize rock dc d],
      help: 'Generates docker config files'.freeze
    },
    docker_info: {
      aliases: %I[docker_info di],
      help: 'Shows Docker information'.freeze
    },
    help: {
      aliases: %I[help h],
      help: 'prints this message'.freeze
    }
  }.freeze

  TEMPLATES = {
    config_dir: %w[
      secrets.yml
      rails-entry-point.sh
      Dockerfilerails
      Dockerfilemysql
      Dockerfilepostgresql
      sqls/initdb-mysql.sql
    ].freeze,
    current_dir: %w[docker-compose.yml .dockerignore].freeze
  }.freeze

  CONFIG_DIRECTORY_NAME = '.rockered'.freeze

  DIRECTORIES = {
    conf_dir: PATHS.config_directory,
    data_dir: File.join(PATHS.config_directory, 'data_dir'),
    sqls_dir: File.join(PATHS.config_directory, 'sqls')
  }.freeze
end
