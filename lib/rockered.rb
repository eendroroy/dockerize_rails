require 'rockered/rockered_config'
require 'rockered/command_line_methods'
require 'rockered/config_generator'
require 'rockered/config_loader'
require 'rockered/docker_helper'
require 'rockered/paths'
require 'rockered/helpers'
require 'rockered/version'
require 'rockered/constants'
require 'rockered/command_line'
require 'rockered/r_name_space'

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
