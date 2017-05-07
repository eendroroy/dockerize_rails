module Rockered
  module CommandLine
    require 'colorize'

    def run
      create_config
    end

    private

    def parse_opts; end

    def create_config
      ConfigGenerator.create_configs
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
