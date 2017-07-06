module DockerizeRails
  module Helpers
    require 'ostruct'
    require 'optparse'

    def self.processed_commands
      Hash[Constants::COMMANDS.keys.map do |key|
        [key, Constants::COMMANDS[key][:aliases].map(&:to_s)]
      end]
    end

    def self.parse_opts
      options = { skip_desc: false, purge: false, config_test: false }
      parser = OptionParser.new do |opts|
        opts.on('--skip-desc') { options[:skip_desc] = true }
        opts.on('--purge') { options[:purge] = true }
        opts.on('--config-test') { options[:config_test] = true }
      end
      parser.parse!
      [ARGV[0].to_s, args: options]
    end

    def self.ensure_rails_root
      unless PATHS.rails_root?
        puts "\n'#{`pwd`.strip}' is not a rails application root.\n".red
        exit(1)
      end
      0
    end

    def self.params_help(command)
      if command.key? :params
        [command[:params].keys.map do |param|
          "\n          #{('[' + param.to_s + ']').ljust(15, ' ')} -- #{command[:params][param]}"
        end,
         "\n"].join
      else
        ''
      end
    end

    # -rubocop:disable Metrics/MethodLength
    # -rubocop:disable Metrics/AbcSize
    def self.help
      ['
Usage: rocker <command>
   or: bundle exec dock <command>

   commands:
       ',
       Constants::COMMANDS.keys.map do |key|
         command = Constants::COMMANDS[key]
         "        #{command[:aliases].map(&:to_s).join(', ').ljust(30, ' ')}" \
           " - #{command[:help]}" + params_help(command)
       end,
       '
       '].join("\n")
    end
    # -rubocop:enable Metrics/MethodLength
    # -rubocop:enable Metrics/MethodLength

    def self.print_formatted_info(name, value)
      print name.ljust(15, ' ').yellow, value.blue
    end

    class << self
      private :params_help
    end
  end
end
