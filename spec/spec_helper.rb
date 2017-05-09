require 'bundler/setup'
require 'rocker_docker'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

module RockerDocker
  module CommandLine
    def run(command, args)
      original_stdout = $stdout.clone
      $stdout.reopen(File.new('/dev/null', 'w'))
      resp = CommandLineMethods.invoke(command, args)
      $stdout.reopen(original_stdout)
      resp
    end
  end
end

class RockerDockerCLI
  extend RockerDocker::CommandLine
end
