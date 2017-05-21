module DockerizeRails
  module Helpers
    require 'ostruct'

    def self.processed_commands
      Hash[Constants::COMMANDS.keys.map do |key|
        [key, Constants::COMMANDS[key][:aliases].map(&:to_s)]
      end]
    end

    def self.parse_opts
      [ARGV[0].to_s, args: ARGV[1..ARGV.size].to_a]
    end

    def self.ensure_rails_root
      unless PATHS.rails_root?
        puts "\n'#{`pwd`.strip}' is not a rails application root.\n".red
        exit(1)
      end
      0
    end

    def self.help
      ['
Usage: rocker <command>
   or: bundle exec dock <command>

   commands:
       ',
       Constants::COMMANDS.keys.map do |key|
         command = Constants::COMMANDS[key]
         "        #{command[:aliases].map(&:to_s).join(', ').ljust(30, ' ')}" \
           " - #{command[:help]}"
       end,
       '
       '].join("\n")
    end

    def self.print_formatted_info(name, value)
      print name.ljust(15, ' ').yellow, value.blue
    end
  end
end
