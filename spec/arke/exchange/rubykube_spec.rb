require 'securerandom'

require 'configuration'
require 'strategy'
require 'order'
require 'log'

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
  let(:strategy)   { Arke::Strategy::Copy.new(strategy_config) }
  let(:order)      { Arke::Order.new(1, 'ethusd', 1, 1, :buy) }
  let(:rubykube)   { Arke::Exchange::Rubykube.new(exchange_config) }

  context 'rubykube#create_order' do
    it 'sets proper url when create order' do
      response = rubykube.create_order(order)

      expect(response.env.url.to_s).to include('peatio/market/orders')
    end

    it 'sets proper header when create order' do
      response = rubykube.create_order(order)

      expect(response.env.request_headers.keys).to include('X-Auth-Apikey', 'X-Auth-Nonce', 'X-Auth-Signature', 'Content-Type')
      expect(response.env.request_headers).to include('X-Auth-Apikey' => @authorized_api_key)
    end

    it 'gets 403 on request with wrong api key' do
      rubykube.instance_variable_set(:@api_key, SecureRandom.hex)

      expect { rubykube.create_order(order) }.to output(/Code: 403/).to_stderr_from_any_process
    end
  end

  context 'rubykube#stop_order' do
    it 'sets proper url when stop order' do
      response = rubykube.stop_order(order)

      expect(response.env.url.to_s).to match(/peatio\/market\/orders\/\d+\/cancel/)
    end

    it 'sets proper header when stop order' do
      response = rubykube.stop_order(order)

      expect(response.env.request_headers.keys).to include('X-Auth-Apikey', 'X-Auth-Nonce', 'X-Auth-Signature', 'Content-Type')
      expect(response.env.request_headers).to include('X-Auth-Apikey' => @authorized_api_key)
    end
  end

end
