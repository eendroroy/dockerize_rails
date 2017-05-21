module DockerizeRails
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

module DockerizeRails
  module Helpers
    def self.ensure_rails_root
      0
    end
  end
end

class DockerizeRailsCLI
  extend DockerizeRails::CommandLine
end
