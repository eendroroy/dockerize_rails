module Rockered
  module Helpers
    require 'ostruct'

    def self.processed_commands
      Hash[COMMANDS.keys.map do |k|
        [k, COMMANDS[k][:aliases].map(&:to_s)]
      end]
    end

    def self.parse_opts
      OpenStruct.new(command: ARGV[0].to_s, args: ARGV[1..ARGV.size].to_a)
    end

    def self.help
      ['
Usage: rocker <command>
   or: bundle exec rocker <command>

   commands:
       ',
       COMMANDS.keys.map do |k|
         "        #{COMMANDS[k][:aliases].map(&:to_s).join(', ').ljust(30, ' ')} - #{COMMANDS[k][:help]}"
       end,
       '
       '].join("\n")
    end

    def self.print_formatted_info(name, value)
      print name.ljust(15, ' ').yellow, value.blue
    end
  end
end
