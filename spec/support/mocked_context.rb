# frozen_string_literal: true

require 'webmock/rspec'

shared_context 'mocked rubykube' do
  before(:all) do
    # TODO: find better way to store it (let is not accassible inside before)
    @authorized_api_key = '3107c98eb442e4135541d434410aaaa6'

    # authorized requests
    stub_request(:get, 'http://www.devkube.com/peatio/public/timestamp').
    with(
      headers: {
        'X-Auth-Apikey'=> @authorized_api_key
      }).
    to_return(status: 200, body: '', headers: {})
  end
end
