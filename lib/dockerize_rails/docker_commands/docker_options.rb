module DockerizeRails
  module DockerCommands
    class DockerOptions
      def initialize
        @options = {
          'Image' => '',
          'name' => '',
          'Hostname' => '0.0.0.0',
          'ExposedPorts' => {},
          'Env' => [],
          'HostConfig' => {
            'PortBindings' => {},
            'Links' => []
          }
        }
      end

      def image(image)
        @options['Image'] = image
      end

      def name(name)
        @options['name'] = name
      end

      def hostname(hostname)
        @options['Hostname'] = hostname
      end

      def expose(port)
        @options['ExposedPorts']["#{port}/tcp"] = {}
        @options['HostConfig']['PortBindings']["#{port}/tcp"] = [{ 'HostPort' => port }]
      end

      def add_port_binds(container, host)
        @options['HostConfig']['PortBindings']["#{container}/tcp"] = [{ 'HostPort' => host }]
      end

      def add_env(env)
        @options['Env'] << env
      end

      def add_links(container, alias_name)
        @options['HostConfig']['Links'] << "#{container}:#{alias_name}"
      end

      def options
        Marshal.load(Marshal.dump(@options))
      end
    end
  end
end
