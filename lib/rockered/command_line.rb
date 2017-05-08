module Rockered
  module CommandLine
    def run
      opts = Helpers.parse_opts
      exit(CommandLineMethods.invoke(opts))
    end
  end
end
