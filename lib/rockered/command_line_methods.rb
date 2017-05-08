module Rockered
  module CommandLineMethods
    require 'colorize'

    def self.invoke
      opts = Helpers.parse_opts
      commands = Helpers.processed_commands
      rc = ConfigLoader.load_rockered_config(opts.command)
      case opts.command
      when *(commands[:configure])
        return configure
      when *(commands[:dockrize])
        return dockrize(rc)
      when *(commands[:help])
        help
        return 0
      else
        help
        return 1
      end
    end

    def self.dockrize(rc)
      ConfigGenerator.dockrize(rc)
    end

    def self.configure
      ConfigGenerator.configure
    end

    def self.help
      puts Helpers.help.white
    end

    def self.docker_info
      v = DockerHelper.version

      Helpers.print_formatted_info 'Docker Version', "#{v['Version']}\n"
      Helpers.print_formatted_info 'API', "#{v['ApiVersion']} : #{v['MinAPIVersion']}\n"
      Helpers.print_formatted_info 'Git Commit', "#{v['GitCommit']}\n"
      Helpers.print_formatted_info 'Go Version', "#{v['GoVersion']}\n"
      # Helpers.print_formatted_info 'OS', "#{v['Os']}_#{v['Arch']}_#{v['KernelVersion']}\n"
      Helpers.print_formatted_info 'Experimental', "#{v['Experimental']}\n"
      Helpers.print_formatted_info 'Build Time', "#{DateTime.parse(v['BuildTime']).strftime('%b %d, %Y %I:%M %p')}\n"
    end
  end
end
