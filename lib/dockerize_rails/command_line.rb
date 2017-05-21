module DockerizeRails
  module CommandLine
    def run
      exit(CommandLineMethods.invoke(Helpers.parse_opts))
    end
  end
end
