require 'dockerize_rails/version'
require 'dockerize_rails/constants'
require 'dockerize_rails/templates'
require 'dockerize_rails/paths'
require 'dockerize_rails/helpers'
require 'dockerize_rails/dr_config'
require 'dockerize_rails/config_loader'
require 'dockerize_rails/dr_name_space'
require 'dockerize_rails/config_generator'
require 'dockerize_rails/docker_commands/docker_options'
require 'dockerize_rails/docker_commands/docker_helpers'
require 'dockerize_rails/docker_commands/docker_pull'
require 'dockerize_rails/docker_commands/docker_build'
require 'dockerize_rails/docker_commands/docker_start'
require 'dockerize_rails/docker_commands/docker_stop'
require 'dockerize_rails/docker_commands/docker_delete'
require 'dockerize_rails/docker_commands'
require 'dockerize_rails/command_line_methods'
require 'dockerize_rails/command_line'

module DockerizeRails
  private_constant :PATHS
  private_constant :Helpers
  private_constant :DRNameSpace
  private_constant :ConfigLoader
  private_constant :DRConfig
  private_constant :ConfigGenerator
  private_constant :Constants
  private_constant :Templates
  private_constant :CommandLineMethods
  private_constant :DockerCommands
end

class DockerizeRailsCLI
  extend DockerizeRails::CommandLine
end
