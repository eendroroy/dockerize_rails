require 'spec_helper'

RSpec.describe RockerDocker do
  it 'has a version number' do
    expect(RockerDocker::VERSION).not_to be nil
  end

  it 'successfully runs help command' do
    expect(RockerDockerCLI.run('help', [])).to be 0
  end

  it 'successfully runs configure command' do
    expect(RockerDockerCLI.run('configure', [])).to be 0
  end

  it 'successfully runs dockerize command' do
    expect(RockerDockerCLI.run('dockerize', [])).to be 0
  end

  it 'successfully runs undockerize command' do
    expect(RockerDockerCLI.run('undockerize', [])).to be 0
  end

  it 'fails to run undefined command' do
    expect(RockerDockerCLI.run('undefined', [])).to be 1
  end
end
