require 'rocker_docker/paths'
require 'rocker_docker/helpers'
require 'rocker_docker/rocker_docker_name_space'
require 'rocker_docker/config_loader'
require 'rocker_docker/rocker_docker_config'
require 'rocker_docker/config_generator'
require 'rocker_docker/docker_helper'
require 'rocker_docker/constants'
require 'rocker_docker/templates'
require 'rocker_docker/version'
require 'rocker_docker/command_line_methods'
require 'rocker_docker/command_line'

module RockerDocker
  private_constant :CommandLineMethods
  private_constant :ConfigGenerator
  private_constant :ConfigLoader
  private_constant :COMMANDS
  private_constant :DockerHelper
  private_constant :PATHS
  private_constant :Helpers
end

class RockerDockerCLI
  extend RockerDocker::CommandLine
end
