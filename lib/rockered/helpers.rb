module Rockered
  module Helpers
    def self.processed_commands
      Hash[COMMANDS.keys.map do |k|
        [k, COMMANDS[k][:aliases].map(&:to_s)]
      end]
    end

    def self.help
      ['',
       'Available Commands are:',
       '',
       COMMANDS.keys.map do |k|
         "    #{COMMANDS[k][:aliases].map(&:to_s).join(', ').ljust(30, ' ')} - #{COMMANDS[k][:help]}"
       end,
       '',
       ''].join("\n")
    end
  end
end
