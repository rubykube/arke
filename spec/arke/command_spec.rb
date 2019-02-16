require 'spec_helper'
require './lib/arke/command'

RSpec.describe Arke::Command do
  let(:config) { YAML.load_file('config/strategy.yaml')['strategy'] }
  let(:target) {
    t = config['target']
    t['driver'] = Rubykube::MarketApi
    t
  }
  let(:strategy_type) { Arke::Strategy::Copy }
  let(:sources_type) { Arke::Exchange::Bitfinex }

  before(:each) do
    Arke.config = nil
  end

  it 'loads configuration' do
    Arke::Command.load_configuration

    expect(Arke.config.target).to eq(target)
    expect(Arke.config.strategy).to be_an_instance_of(strategy_type)
    Arke.config.sources.each do |source|
      expect(source['driver']).to eq(sources_type)
    end
  end

  it 'loads configuration on run' do
    Arke::Command.run!

    expect(Arke.config.target).to eq(target)
    expect(Arke.config.strategy).to be_an_instance_of(strategy_type)
    Arke.config.sources.each do |source|
      expect(source['driver']).to eq(sources_type)
    end
  end
end
