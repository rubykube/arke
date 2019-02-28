require 'arke'
require 'action'

describe Arke::Exchange::Bitfinex do
  let(:config) do
    {
      'driver' => 'rubykube',
      'host' => 'http://www.devkube.com',
      'key' => @authorized_api_key,
      'secret' => SecureRandom.hex,
      'market' => 'ethusd'
    }
  end
  let(:bitfinex_config) do
    {
      'driver' => 'bitfinex'
    }
  end
  let(:strategy) { Arke::Strategy::Copy.new(config) }
  let(:bitfinex) { Arke::Exchange::Bitfinex.new(bitfinex_config) }

  context 'websocket messages processing' do
    let(:snapshot_message) do
      [69586,
        [
          [22814737094, 141, 3.5459735],
          [22814761433, 141, 1678.72933611],
          [22814767295, 141, 2.28948142],
          [22814776345, 141, 572.89016357],
          [22814807549, 141, 6.848292],
          [22814800273, 141.01, -0.56493047],
          [22814805880, 141.01, -14],
          [22814813532, 141.01, -12.3841162],
          [22814813983, 141.01, -1.56],
          [22814799021, 141.1322692908, -2.32966444]
        ]
      ]
    end

    let(:single_order) { [69586, [22814737094, 141, 2.45]] }

    let(:process_snapshot_message) do
      bitfinex.process_message(snapshot_message)
    end

    let(:process_single_order) do
      bitfinex.process_message(single_order)
    end
  end
end
