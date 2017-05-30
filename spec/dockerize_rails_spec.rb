require 'spec_helper'

RSpec.describe DockerizeRails do
  it 'has a version number' do
    expect(DockerizeRails::VERSION).not_to be nil
  end

  it 'successfully runs help command' do
    expect(DockerizeRailsCLI.run('help', args: [])).to be 0
  end

  it 'successfully runs configure command' do
    expect(DockerizeRailsCLI.run('configure', args: [])).to be 0
  end

  it 'successfully runs configure --skip-desc command' do
    expect(DockerizeRailsCLI.run('configure', args: ['--skip-desc'])).to be 0
  end

  it 'successfully runs dockerize command' do
    expect(DockerizeRailsCLI.run('dockerize', args: [])).to be 0
  end

  it 'successfully runs undockerize command' do
    expect(DockerizeRailsCLI.run('undockerize', args: [])).to be 0
  end

  it 'successfully runs undockerize --purge command' do
    expect(DockerizeRailsCLI.run('undockerize', args: ['--purge'])).to be 0
  end

  it 'fails to run undefined command' do
    expect(DockerizeRailsCLI.run('undefined', args: [])).to be 1
  end
end
