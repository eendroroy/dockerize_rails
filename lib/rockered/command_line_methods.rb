module Rockered
  module CommandLineMethods
    require 'colorize'

    def self.invoke
      opts = parse_opts
      commands = Helpers.processed_commands
      rc = ConfigLoader.load_rockered_config(opts.command)
      case opts.command
      when *(commands[:configure_rockered])
        return create_rockered_config
      when *(commands[:configure])
        return create_configs(rc)
      when *(commands[:help])
        puts Helpers.help.white
        return 0
      else
        puts Helpers.help.white
        return 1
      end
    end

    def self.parse_opts
      OpenStruct.new(command: ARGV[0].to_s, args: ARGV[1..ARGV.size].to_a)
    end

    def self.create_configs(rc)
      ConfigGenerator.create_configs(rc)
    end

    def self.create_rockered_config
      ConfigGenerator.configure_rockered
    end

    def self.info
      v = DockerHelper.version

      print_formatted_info 'Docker Version', "#{v['Version']}\n"
      print_formatted_info 'API', "#{v['ApiVersion']} : #{v['MinAPIVersion']}\n"
      print_formatted_info 'Git Commit', "#{v['GitCommit']}\n"
      print_formatted_info 'Go Version', "#{v['GoVersion']}\n"
      # print_formatted_info 'OS', "#{v['Os']}_#{v['Arch']}_#{v['KernelVersion']}\n"
      print_formatted_info 'Experimental', "#{v['Experimental']}\n"
      print_formatted_info 'Build Time', "#{DateTime.parse(v['BuildTime']).strftime('%b %d, %Y %I:%M %p')}\n"
    end

    def print_formatted_info(name, value)
      print name.ljust(15, ' ').yellow, value.blue
    end
  end
end
