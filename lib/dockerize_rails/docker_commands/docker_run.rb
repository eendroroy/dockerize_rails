module DockerizeRails
  module DockerCommands
    module DockerRun
      def run; end

      def run_rails; end
      def run_mysql; end
      def run_postgres; end

      def docker_run(image_name, opts)
        # container = Docker::Container.create( 'Image' => image_name, opts)
      end
    end
  end
end
