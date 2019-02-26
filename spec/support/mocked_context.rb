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
    to_return(status: 201, body: '', headers: {})

    stub_request(:post, /peatio\/market\/orders\/\d+\/cancel/).
    with(headers: authorized_header).
    to_return(status: 201, body: '', headers: {})

  end
end
