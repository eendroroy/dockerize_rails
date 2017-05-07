module Rockered
  COMMANDS = {
    configure_rockered: { aliases: %I[configure_rockered cr], help: 'generates .rockered.yml'.freeze },
    configure: { aliases: %I[configure rock c], help: 'generates docker config files'.freeze },
    help: { aliases: %I[help h], help: 'prints this message'.freeze }
  }.freeze
end
