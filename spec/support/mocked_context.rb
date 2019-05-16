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

    stub_request(:get, /peatio\/market\/orders/).
    to_return(status: 403, body: '', headers: {})

    stub_request(:get, /peatio\/account\/balances/).
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

    stub_request(:get, /peatio\/market\/orders/).
    with(headers: authorized_header).
    to_return(
      status: 200,
      body: [
        {'id'=>4, 'side'=>'sell', 'ord_type'=>'limit', 'price'=>'138.87', 'avg_price'=>'0.0', 'state'=>'wait', 'market'=>'fthusd', 'created_at'=>'2019-05-15T12:18:42+02:00', 'updated_at'=>'2019-05-15T12:18:42+02:00', 'origin_volume'=>'2.0', 'remaining_volume'=>'2.0', 'executed_volume'=>'0.0', 'trades_count'=>0},
        {'id'=>3, 'side'=>'buy', 'ord_type'=>'limit', 'price'=>'233.98', 'avg_price'=>'0.0', 'state'=>'wait', 'market'=>'fthusd', 'created_at'=>'2019-05-15T12:18:37+02:00', 'updated_at'=>'2019-05-15T12:18:37+02:00', 'origin_volume'=>'4.68', 'remaining_volume'=>'4.68', 'executed_volume'=>'0.0', 'trades_count'=>0},
        {'id'=>2, 'side'=>'sell', 'ord_type'=>'limit', 'price'=>'138.87', 'avg_price'=>'0.0', 'state'=>'wait', 'market'=>'fthusd', 'created_at'=>'2019-05-15T12:18:21+02:00', 'updated_at'=>'2019-05-15T12:18:21+02:00', 'origin_volume'=>'2.0', 'remaining_volume'=>'2.0', 'executed_volume'=>'0.0', 'trades_count'=>0},
        {'id'=>1, 'side'=>'buy', 'ord_type'=>'limit', 'price'=>'138.76', 'avg_price'=>'0.0', 'state'=>'wait', 'market'=>'fthusd', 'created_at'=>'2019-05-15T12:18:04+02:00', 'updated_at'=>'2019-05-15T12:18:04+02:00', 'origin_volume'=>'0.17', 'remaining_volume'=>'0.17', 'executed_volume'=>'0.0', 'trades_count'=>0}].to_json,
      headers: {Total: 4})

    stub_request(:get, /peatio\/account\/balances/).
    with(headers: authorized_header).
    to_return(
      status: 200,
      body: [
        {"currency"=>"eth", "balance"=>"0.0", "locked"=>"0.0"},
        {"currency"=>"fth", "balance"=>"1000000.0", "locked"=>"0.0"},
        {"currency"=>"trst", "balance"=>"0.0", "locked"=>"0.0"},
        {"currency"=>"usd", "balance"=>"1000000.0", "locked"=>"0.0"}].to_json,
      headers: {})

  end
end

shared_context 'mocked binance' do
  before(:each) do
    @authorized_api_key = 'Uwg8wqlxueiLCsbTXjlogviL8hdd60'
    authorized_headers = { 'X-MBX-APIKEY' => @authorized_api_key, 'Content-Type' => 'application/x-www-form-urlencoded' }

    stub_request(:post, 'https://api.binance.com/api/v3/order').
    to_return(status: 401, body: 'Unauthorized', headers: {})

    stub_request(:get, 'https://www.binance.com/api/v1/depth?symbol=ETHUSDT&limit=1000').
    to_return(
      status: 200,
      body: {
        'lastUpdateId'=>320927259,
        'bids'=>[['135.87000000', '36.43875000', []], ['135.85000000', '0.57176000', []], ['135.84000000', '6.62227000', []]],
        'asks'=>[['135.91000000', '0.00070000', []], ['135.93000000', '8.00000000', []], ['135.95000000', '1.11699000', []]]
      }.to_json,
      headers: {}
    )

    stub_request(:post, 'https://api.binance.com/api/v3/order').
    with(headers: authorized_headers).
    to_return(status: 200, body: '', headers: {})
  end
end
