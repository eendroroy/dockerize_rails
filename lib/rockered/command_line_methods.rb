module Rockered
  module CommandLineMethods
    require 'colorize'

    def self.invoke
      opts = parse_opts
      commands = processed_commands
      case opts.command
      when *(commands[:configure_rockered]) then create_rockered_config
      when *(commands[:configure]) then create_configs
      else puts generate_help.white
      end
    end

    def self.processed_commands
      Hash[COMMANDS.keys.map do |k|
        [k, COMMANDS[k][:aliases].map(&:to_s)]
      end]
    end

    def self.generate_help
      ['',
       'Available Commands are:',
       '',
       COMMANDS.keys.map do |k|
         "    #{COMMANDS[k][:aliases].map(&:to_s).join(', ').ljust(30, ' ')} - #{COMMANDS[k][:help]}"
       end,
       ''].join("\n")
    end

    def self.parse_opts
      OpenStruct.new(command: ARGV[0].to_s, args: ARGV[1..ARGV.size].to_a)
    end

    def self.create_configs
      ConfigGenerator.create_configs
    end

    def self.create_rockered_config
      ConfigGenerator.configure_rockered
    end

    def self.parse_config
      ConfigHelper.config
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
