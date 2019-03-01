describe Arke::Exchange::Bitfinex do
  let(:config) { YAML.load_file('spec/support/fixtures/test_config.yaml') }
  let(:bitfinex_config) do
    {
      'driver' => 'bitfinex',
      'market' => 'tETHUSD',
      'host' => "api.bitfinex.com",
      'key' => "",
      'secret' => "",
      'rate_limit' => 1.0
    }
  end
  let(:strategy) { Arke::Strategy::Copy.new(config) }
  let(:bitfinex) { Arke::Exchange::Bitfinex.new(bitfinex_config) }

  context 'Bitfinex class' do
    let(:data_create) { [1, 10, 20] }
    let(:data_create_sell) { [2, 22, -33] }
    let(:data_delete) { [3, 0, 44] }

    it 'initialize configuration' do
      expect(bitfinex.orderbook).not_to be_nil
      expect(bitfinex.instance_variable_get(:@market)).to eq(bitfinex_config['market'])
    end

    it '#build_order with positive amount' do
      price, _count, amount = data_create
      order = bitfinex.build_order(data_create)

      expect(order.price).to eq(price)
      expect(order.amount).to eq(amount)
      expect(order.side).to eq(:buy)
      expect(order.market).to eq(bitfinex_config['market'])
    end

    it '#build_order with negative amount' do
      price, _count, amount = data_create_sell
      order = bitfinex.build_order(data_create_sell)

      expect(order.price).to eq(price)
      expect(order.amount).to eq(-amount)
      expect(order.side).to eq(:sell)
      expect(order.market).to eq(bitfinex_config['market'])
    end

    it '#process_data creates order' do
      expect(bitfinex.orderbook).to receive(:update)
      bitfinex.process_data(data_create)
    end

    it '#process_data deletes order' do
      expect(bitfinex.orderbook).to receive(:delete)
      bitfinex.process_data(data_delete)
    end
  end

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

    it 'processes single order in message' do
      # expect(bitfinex).to receive(:process_channel_message)
      expect(bitfinex).to receive(:process_data)

      bitfinex.process_message(single_order)
    end

    it 'processes list of orders' do
      n = snapshot_message[1].length
      expect(bitfinex).to receive(:process_data).exactly(n).times

      bitfinex.process_message(snapshot_message)
    end
  end
end
