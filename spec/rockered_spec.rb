require 'spec_helper'

RSpec.describe Rockered do
  it 'has a version number' do
    expect(Rockered::VERSION).not_to be nil
  end

  it 'successfully runs help command' do
    expect(RockererCLI.run('help', [])).to be 0
  end

  it 'successfully runs configure command' do
    expect(RockererCLI.run('configure', [])).to be 0
  end

  it 'successfully runs dockerize command' do
    expect(RockererCLI.run('dockerize', [])).to be 0
  end

  it 'successfully runs docker_info command' do
    expect(RockererCLI.run('docker_info', [])).to be 0
  end

  it 'fails to run undefined command' do
    expect(RockererCLI.run('undefined', [])).to be 1
  end
end
