require 'rockered/command_line'
require 'rockered/command_line_methods'
require 'rockered/config_generator'
require 'rockered/config_helper'
require 'rockered/docker_helper'
require 'rockered/paths'
require 'rockered/version'
require 'rockered/constants'

module Rockered
  private_constant :CommandLineMethods
  private_constant :ConfigGenerator
  private_constant :ConfigHelper
  private_constant :COMMANDS
  private_constant :DockerHelper
  private_constant :PATHS
end

class RockererCLI
  extend Rockered::CommandLine
end
