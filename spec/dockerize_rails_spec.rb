require 'spec_helper'

RSpec.describe DockerizeRails do
  it 'has a version number' do
    expect(DockerizeRails::VERSION).not_to be nil
  end

  it 'successfully runs help command' do
    expect(DockerizeRailsCLI.run('help', [])).to be 0
  end

  it 'successfully runs configure command' do
    expect(DockerizeRailsCLI.run('configure', [])).to be 0
  end

  it 'successfully runs dockerize command' do
    expect(DockerizeRailsCLI.run('dockerize', [])).to be 0
  end

  it 'successfully runs undockerize command' do
    expect(DockerizeRailsCLI.run('undockerize', [])).to be 0
  end

  it 'fails to run undefined command' do
    expect(DockerizeRailsCLI.run('undefined', [])).to be 1
  end
end
