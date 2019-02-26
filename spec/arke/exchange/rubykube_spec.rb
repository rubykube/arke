require 'securerandom'

require 'configuration'
require 'action'
require 'order'
require 'exchange/rubykube'

RSpec.describe Arke::Exchange::Rubykube do
  include_context 'mocked rubykube'

  before(:all) { Arke::Log.define }

  let(:strategy_config) { {} }
  let(:exchange_config) {
    {
    'driver' => 'rubykube',
    'host' => 'http://www.devkube.com',
    'key' => @authorized_api_key,
    'secret' => SecureRandom.hex
    }
  }
  let(:strategy) { Arke::Strategy::Base.new(strategy_config) }
  let(:order)    { Arke::Order.new(1, 'ethusd', 1, 1) }
  let(:rubykube) { Arke::Exchange::Rubykube.new(exchange_config, strategy) }

  let(:action_create_order) { Arke::Action.new(:create_order, Arke::Order.new(1, 'ethusd', 1, 1)) }
  let(:action_cancel_order) { Arke::Action.new(:cancel_order, Arke::Order.new(1, 'ethusd', 0, 1)) }
  let(:action_other)        { Arke::Action.new(:shutdown)}

  context 'rubykube#call' do
    it 'calls create_order on action with :create_order type' do
      response = rubykube.call(action_create_order)

      expect(response.env.url.to_s).to include('peatio/market/orders')
    end

    it 'calls cancel_order on action with :cancel_order type' do
      response = rubykube.call(action_cancel_order)

      expect(response.env.url.to_s).to match(/peatio\/market\/orders\/\d+\/cancel/)
    end

    it 'does nothing on other actions' do
      expect(rubykube.call(action_other)).to be_nil
    end
  end

  context 'rubykube#create_order' do
    it 'sets proper url when create order' do
      response = rubykube.send(:create_order, order)

      expect(response.env.url.to_s).to include('peatio/market/orders')
    end

    it 'sets proper header when create order' do
      response = rubykube.send(:create_order, order)

      expect(response.env.request_headers.keys).to include('X-Auth-Apikey', 'X-Auth-Nonce', 'X-Auth-Signature', 'Content-Type')
      expect(response.env.request_headers).to include('X-Auth-Apikey' => @authorized_api_key)
    end

    it 'gets 403 on request with wrong api key' do
      rubykube.instance_variable_set(:@api_key, SecureRandom.hex)

      expect { rubykube.send(:create_order, order) }.to output(/Code: 403/).to_stderr_from_any_process
    end
  end

  context 'rubykube#cancel_order' do
    it 'sets proper url when cancel order' do
      response = rubykube.send(:cancel_order, order)

      expect(response.env.url.to_s).to match(/peatio\/market\/orders\/\d+\/cancel/)
    end

    it 'sets proper header when cancel order' do
      response = rubykube.send(:cancel_order, order)

      expect(response.env.request_headers.keys).to include('X-Auth-Apikey', 'X-Auth-Nonce', 'X-Auth-Signature', 'Content-Type')
      expect(response.env.request_headers).to include('X-Auth-Apikey' => @authorized_api_key)
    end
  end

end
