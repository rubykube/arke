# frozen_string_literal: true

require 'webmock/rspec'

shared_context 'mocked rubykube' do
  before(:each) do
    # TODO: find better way to store it (let is not accassible inside before)
    @authorized_api_key = '3107c98eb442e4135541d434410aaaa6'
    authorized_header = { 'X-Auth-Apikey'=> @authorized_api_key }

    # non-authorized requests

    stub_request(:post, /peatio\/market\/orders/).
    to_return(status: 403, body: '', headers: {})

    # authorized requests

    stub_request(:get, /peatio\/public\/timestamp/).
    with(headers: authorized_header).
    to_return(status: 200, body: '', headers: {})

    stub_request(:post, /peatio\/market\/orders/).
    with(headers: authorized_header).
    to_return(status: 201, body: { id: Random.rand(1...1000) }.to_json, headers: {})

    stub_request(:post, /peatio\/market\/orders\/\d+\/cancel/).
    with(headers: authorized_header).
    to_return(status: 201, body: '', headers: {})
  end
end

shared_context 'mocked binance' do
  before(:each) do
    stub_request(:get, "https://www.binance.com/api/v1/depth?symbol=ETHUSDT&limit=1000").
    to_return(
      status: 200,
      body: {
        "lastUpdateId"=>320927259,
        "bids"=>[["135.87000000", "36.43875000", []], ["135.85000000", "0.57176000", []], ["135.84000000", "6.62227000", []]],
        "asks"=>[["135.91000000", "0.00070000", []], ["135.93000000", "8.00000000", []], ["135.95000000", "1.11699000", []]]
      }.to_json,
      headers: {}
    )
  end
end
