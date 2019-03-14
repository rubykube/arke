describe Arke::Command do
  let(:config) { YAML.load_file('config/strategy.yaml')['strategy'] }

  it 'loads configuration' do
    Arke::Command.load_configuration

    expect(Arke::Configuration.get(:strategy)).to eq(config)
  end
end
