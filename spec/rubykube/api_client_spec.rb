require 'spec_helper'
require 'securerandom'

require './lib/rubykube/api_client'

RSpec.describe Rubykube::ApiClient do

  let(:host)   { 'http://www.devkube.com/' }
  let(:key)    { SecureRandom.hex }
  let(:secret) { SecureRandom.hex }

  let(:api_client) { Rubykube::ApiClient.new({'host' => host, 'key' => key, 'secret' => secret}) }

  it 'sets proper header in get request' do
    api_client_get = api_client.get('/peatio/public/timestamp')

    expect(api_client_get.env.request_headers.keys).to include('X-Auth-Apikey', 'X-Auth-Nonce', 'X-Auth-Signature', 'Content-Type')
    expect(api_client_get.env.request_headers).to include('X-Auth-Apikey' => key)
  end

  it 'gets successful answer on get request' do
    api_client_get = api_client.get('/peatio/public/timestamp')

    expect(api_client_get.env.status).to eq(200)
    expect(api_client_get.env.reason_phrase).to eq('OK')
  end

  it 'sets proper header in post request' do
    api_client_post = api_client.post('/barong/identity/users/email/generate_code', { email: 'admin@barong.io' })

    expect(api_client_post.env.request_headers.keys).to include('X-Auth-Apikey', 'X-Auth-Nonce', 'X-Auth-Signature', 'Content-Type')
    expect(api_client_post.env.request_headers).to include('X-Auth-Apikey' => key)
  end

end
