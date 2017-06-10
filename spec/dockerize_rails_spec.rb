require 'spec_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe DockerizeRails do
  it 'has a version number' do
    expect(DockerizeRails::VERSION).not_to be nil
  end

  it 'successfully runs help command' do
    options = { skip_desc: false, purge: false, config_test: false }
    expect(DockerizeRailsCLI.run('help', args: options)).to be 0
  end

  it 'successfully runs configure command' do
    options = { skip_desc: false, purge: false, config_test: false }
    expect(DockerizeRailsCLI.run('configure', args: options)).to be 0
  end

  it 'successfully runs configure --skip-desc command' do
    options = { skip_desc: true, purge: false, config_test: false }
    expect(DockerizeRailsCLI.run('configure', args: options)).to be 0
  end

  it 'successfully runs dockerize command' do
    options = { skip_desc: false, purge: false, config_test: false }
    expect(DockerizeRailsCLI.run('dockerize', args: options)).to be 0
  end

  it 'successfully runs dockerize --config-test command' do
    options = { skip_desc: false, purge: false, config_test: true }
    expect(DockerizeRailsCLI.run('dockerize', args: options)).to be 0
  end

  it 'successfully runs undockerize command' do
    options = { skip_desc: false, purge: false, config_test: false }
    expect(DockerizeRailsCLI.run('undockerize', args: options)).to be 0
  end

  it 'successfully runs undockerize --purge command' do
    options = { skip_desc: false, purge: true, config_test: false }
    expect(DockerizeRailsCLI.run('undockerize', args: options)).to be 0
  end

  it 'fails to run undefined command' do
    options = { skip_desc: false, purge: false, config_test: false }
    expect(DockerizeRailsCLI.run('undefined', args: options)).to be 1
  end
end
