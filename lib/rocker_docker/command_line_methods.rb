module RockerDocker
  module CommandLineMethods
    require 'colorize'

    # -rubocop:disable Metrics/MethodLength
    def self.invoke(command, _args)
      commands = Helpers.processed_commands
      case command
      when *(commands[:configure])
        return configure
      when *(commands[:dockerize])
        return dockerize
      when *(commands[:undockerize])
        return undockerize
      when *(commands[:docker_info])
        return docker_info
      when *(commands[:help])
        return help
      else
        return help 1
      end
    end
    # -rubocop:enable Metrics/MethodLength

    def self.dockerize
      Helpers.ensure_rails_root
      RDNameSpace.load
      ConfigGenerator.dockerize
    end

    def self.undockerize
      Helpers.ensure_rails_root
      ConfigGenerator.undockerize
    end

    def self.configure
      Helpers.ensure_rails_root
      ConfigGenerator.configure
    end

    def self.help(status = 0)
      puts "\nCommand not found".red if status != 0
      puts Helpers.help.white
      status
    end

    def self.docker_info
      v = DockerHelper.version

      puts
      Helpers.print_formatted_info 'Docker Version', "#{v['Version']}\n"
      Helpers.print_formatted_info 'API', "#{v['ApiVersion']} : #{v['MinAPIVersion']}\n"
      Helpers.print_formatted_info 'Git Commit', "#{v['GitCommit']}\n"
      Helpers.print_formatted_info 'Go Version', "#{v['GoVersion']}\n"
      # Helpers.print_formatted_info 'OS', "#{v['Os']}_#{v['Arch']}_#{v['KernelVersion']}\n"
      Helpers.print_formatted_info 'Experimental', "#{v['Experimental']}\n"
      Helpers.print_formatted_info 'Build Time', "#{DateTime.parse(v['BuildTime']).strftime('%b %d, %Y %I:%M %p')}\n"
      puts
      0
    end
  end
end
