require 'spec_helper'
require './lib/arke/command'

RSpec.describe Arke::Command do

  before(:all) do
    @configs = YAML.load(File.open('config/variables.yaml'))
  end

  before(:each) do
    Arke.configuration = nil
  end

  it "loads configuration" do
    Arke::Command.load_configuration

    expect(Arke.configuration.host).to eq(@configs['host'])
    expect(Arke.configuration.api_key['key']).to eq(@configs['api_key']['key'])
    expect(Arke.configuration.api_key['secret']).to eq(@configs['api_key']['secret'])
  end

  it "loads configuration on run" do
    Arke::Command.run!

    expect(Arke.configuration.host).to eq(@configs['host'])
    expect(Arke.configuration.api_key['key']).to eq(@configs['api_key']['key'])
    expect(Arke.configuration.api_key['secret']).to eq(@configs['api_key']['secret'])
  end
end
