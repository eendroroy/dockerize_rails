module Rockered
  module ConfigGenerator
    CONFIG_DIR_NAME = 'docker'.freeze

    def self.create_configs
      create_config_directory
      generate_config_files
    end

    def self.create_config_directory
      FileUtils.mkdir_p(PATHS.config_dir) unless File.directory?(PATHS.config_dir)
    end

    def self.generate_config_files
      %w[rockered.yml entry-point.sh DockerfileRails DockerfileMySQL DockerfilePostgres].each do |conf|
        puts "  ==> Generating #{File.join(PATHS.config_dir, conf)}".green
        File.open(File.join(PATHS.config_dir, conf), 'w+').write(
          StringIO.new(ERB.new(File.read(File.join(PATHS.resources, "#{conf}.erb"))).result(binding)).read
        )
      end
    end
  end
end
