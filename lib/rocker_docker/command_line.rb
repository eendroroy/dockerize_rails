module RockerDocker
  module CommandLine
    def run
      opts = Helpers.parse_opts
      exit(CommandLineMethods.invoke(opts.command, opts.args))
    end
  end
end
