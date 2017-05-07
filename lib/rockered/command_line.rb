module Rockered
  module CommandLine
    require 'colorize'

    def run
      opts = parse_opts
      invoke(opts.command, opts. args)
    end

    private

    def invoke(command, _args)
      case command
      when 'configure', 'c' then create_rockered_config
      when 'config_gen', 'cg' then create_configs
      else puts Rockered::HELP_MESSAGE.white
      end
    end

    def parse_opts
      OpenStruct.new(command: ARGV[0].to_s, args: ARGV[1..ARGV.size].to_a)
    end

    def create_configs
      ConfigGenerator.create_configs
    end

    def create_rockered_config
      ConfigGenerator.configure_rockered
    end

    def parse_config
      ConfigHelper.config
    end

    def info
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
