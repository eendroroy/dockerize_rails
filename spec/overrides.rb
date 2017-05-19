module RockerDocker
  module CommandLine
    def run(command, args)
      original_stdout = $stdout.clone
      $stdout.reopen(File.new('/dev/null', 'w'))
      resp = CommandLineMethods.invoke([command, args])
      $stdout.reopen(original_stdout)
      resp
    end
  end
end

module RockerDocker
  module Helpers
    def self.ensure_rails_root
      0
    end
  end
end

class RockerDockerCLI
  extend RockerDocker::CommandLine
end
