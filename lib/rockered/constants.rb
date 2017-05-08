module Rockered
  COMMANDS = {
    configure_rockered: { aliases: %I[configure_rockered cr], help: 'generates .rockered.yml'.freeze },
    configure: { aliases: %I[configure rock c], help: 'generates docker config files'.freeze },
    help: { aliases: %I[help h], help: 'prints this message'.freeze }
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
