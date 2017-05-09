module RockerDocker
  module CommandLine
    def run
      puts 'Please wait for version > 0'
      exit(1)
      opts = Helpers.parse_opts
      exit(CommandLineMethods.invoke(opts.command, opts.args))
    end
  end
end
