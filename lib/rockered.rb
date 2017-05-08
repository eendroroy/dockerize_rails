require 'rockered/version'
require 'rockered/constants'
require 'rockered/paths'
require 'rockered/rockered_config'
require 'rockered/command_line'
require 'rockered/command_line_methods'
require 'rockered/helpers'
require 'rockered/config_loader'
require 'rockered/config_generator'
require 'rockered/r_name_space'
require 'rockered/docker_helper'

module Rockered
  private_constant :CommandLineMethods
  private_constant :ConfigGenerator
  private_constant :ConfigLoader
  private_constant :COMMANDS
  private_constant :DockerHelper
  private_constant :PATHS
  private_constant :Helpers
end

class RockererCLI
  extend Rockered::CommandLine
end
