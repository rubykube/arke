require 'arke/command'

describe Arke::Command do
  let(:config) { YAML.load_file('config/strategy.yaml')['strategy'] }
  let(:target) { config['target'] }
  let(:strategy) { config }
  let(:sources) { config['sources'] }

  it 'loads configuration' do
    Arke::Command.load_configuration

    expect(Arke::Configuration.get(:target)).to eq(target)
    expect(Arke::Configuration.get(:strategy)).to eq(strategy)
    expect(Arke::Configuration.get(:sources)).to eq(sources)
  end
end
