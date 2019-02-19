require 'spec_helper'
require 'securerandom'

require './lib/rubykube_api/api_client'

RSpec.describe RubykubeApi::ApiClient do
  include_context 'mocked rubykube'

  let(:host)   { 'http://www.devkube.com/' }
  let(:key)    { @authorized_api_key }
  let(:secret) { SecureRandom.hex }

  let(:api_client) { RubykubeApi::ApiClient.new({'host' => host, 'key' => key, 'secret' => secret}) }
  let(:api_client_wrong) { RubykubeApi::ApiClient.new({'host' => host, 'key' => SecureRandom.hex, 'secret' => secret}) }

  it 'sets proper header in get request' do
    api_client_get = api_client.get('/peatio/public/timestamp')

    expect(api_client_get.env.request_headers.keys).to include('X-Auth-Apikey', 'X-Auth-Nonce', 'X-Auth-Signature', 'Content-Type')
    expect(api_client_get.env.request_headers).to include('X-Auth-Apikey' => key)
  end

  it 'gets successful answer on get request' do
    api_client_get = api_client.get('/peatio/public/timestamp')

    expect(api_client_get.env.status).to eq(200)
  end

  it 'gets 403 on get request with wrong api key' do
    expect { api_client_wrong.get('/peatio/public/timestamp') }.to output(/Code: 403/).to_stderr_from_any_process
  end

  it 'sets proper header in post request' do
    api_client_post = api_client.post('/barong/identity/users/email/generate_code', { email: 'admin@barong.io' })

    expect(api_client_post.env.request_headers.keys).to include('X-Auth-Apikey', 'X-Auth-Nonce', 'X-Auth-Signature', 'Content-Type')
    expect(api_client_post.env.request_headers).to include('X-Auth-Apikey' => key)
  end

end
