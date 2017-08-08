module DockerizeRails
  module CommandLineMethods
    require 'colorize'

    # rubocop:disable Metrics/MethodLength
    # rubocop:disable Metrics/AbcSize
    def self.invoke(options)
      DRNameSpace.add_hash options[1][:args]
      commands = Helpers.processed_commands
      case options[0]
      when *(commands[:configure])
        return configure
      when *(commands[:dockerize])
        return dockerize
      when *(commands[:undockerize])
        return undockerize
      when *(commands[:docker_info])
        return docker_info
      when *(commands[:docker_pull])
        return docker_pull
      when *(commands[:docker_build])
        return docker_build
      when *(commands[:docker_start])
        return docker_start
      when *(commands[:help])
        return help
      else
        return help 1
      end
    end
    # rubocop:enable Metrics/MethodLength
    # rubocop:enable Metrics/AbcSize

    def self.dockerize
      Helpers.ensure_rails_root
      DRNameSpace.load
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
      docker_version = DockerCommands.version

      puts
      Helpers.print_formatted_info 'Docker Version', "#{docker_version['Version']}\n"
      Helpers.print_formatted_info 'API', "#{docker_version['ApiVersion']} : #{docker_version['MinAPIVersion']}\n"
      Helpers.print_formatted_info 'Git Commit', "#{docker_version['GitCommit']}\n"
      Helpers.print_formatted_info 'Go Version', "#{docker_version['GoVersion']}\n"
      # Helpers.print_formatted_info 'OS', "#{v['Os']}_#{v['Arch']}_#{v['KernelVersion']}\n"
      Helpers.print_formatted_info 'Experimental', "#{docker_version['Experimental']}\n"
      Helpers.print_formatted_info 'Build Time',
                                   "#{DateTime.parse(docker_version['BuildTime']).strftime('%b %d, %Y %I:%M %p')}\n"
      puts
      0
    end

    def self.docker_pull
      DRNameSpace.load
      DockerizeRails::DockerCommands.pull
      0
    end

    def self.docker_build
      DRNameSpace.load
      DockerizeRails::DockerCommands.build
      0
    end

    def self.docker_start
      DRNameSpace.load
      DockerizeRails::DockerCommands.start
      0
    end
  end
end
