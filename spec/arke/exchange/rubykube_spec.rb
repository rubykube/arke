require 'spec_helper'
require 'securerandom'

require 'configuration'
require 'action'
require 'order'
require 'exchange/rubykube'

RSpec.describe Arke::Exchange::Rubykube do
  include_context 'mocked rubykube'

  before(:each) do
    Arke::Configuration.define do |config|
      config.target = {'host' => 'http://www.devkube.com', 'key' => @authorized_api_key, 'secret' => SecureRandom.hex}
    end
  end

  let(:strategy) { Arke::Strategy::Base.new }

  let(:action_create_order) { Arke::Action.new(:create_order, Arke::Order.new(1, 'ethusd', 1, 1)) }
  let(:action_cancel_order) { Arke::Action.new(:cancel_order, Arke::Order.new(1, 'ethusd', 0, 1)) }
  let(:action_other)        { Arke::Action.new(:shutdown)}

  context 'rubykube#call' do
    it 'calls create_order on action with :create_order type' do
      r = Arke::Exchange::Rubykube.new(strategy).call(action_create_order)

      expect(r.env.url.to_s).to include('peatio/market/orders')
    end

    it 'calls cancel_order on action with :cancel_order type' do
      r = Arke::Exchange::Rubykube.new(strategy).call(action_cancel_order)

      expect(r.env.url.to_s).to match(/peatio\/market\/orders\/\d+\/cancel/)
    end

    it 'does nothing on other actions' do
      expect(Arke::Exchange::Rubykube.new(strategy).call(action_other)).to be_nil
    end
  end

end
