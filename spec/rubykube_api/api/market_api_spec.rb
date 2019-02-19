require 'spec_helper'
require 'securerandom'

RSpec.describe RubykubeApi::MarketApi do
  include_context 'mocked rubykube'

  let(:host)   { 'http://www.devkube.com/' }
  let(:key)    { @authorized_api_key }
  let(:secret) { SecureRandom.hex }

  let(:order)  { Arke::Order.new(1, 'ethusd', 1, 1) }

  let(:market_api) { RubykubeApi::MarketApi.new({'host' => host, 'key' => key, 'secret' => secret}) }

  context 'create order' do
    it 'sets proper url when create order' do
      r = market_api.create_order(order)

      expect(r.env.url.to_s).to include('peatio/market/orders')
    end

    it 'sets proper header when create order' do
      r = market_api.create_order(order)

      expect(r.env.request_headers.keys).to include('X-Auth-Apikey', 'X-Auth-Nonce', 'X-Auth-Signature', 'Content-Type')
      expect(r.env.request_headers).to include('X-Auth-Apikey' => key)
    end
  end

  context 'cancel order' do
    it 'sets proper url when cancel order' do
      r = market_api.cancel_order(order.id)

      expect(r.env.url.to_s).to match(/peatio\/market\/orders\/\d+\/cancel/)
    end

    it 'sets proper header when cancel order' do
      r = market_api.cancel_order(order.id)

      expect(r.env.request_headers.keys).to include('X-Auth-Apikey', 'X-Auth-Nonce', 'X-Auth-Signature', 'Content-Type')
      expect(r.env.request_headers).to include('X-Auth-Apikey' => key)
    end
  end

end
