require 'arke'
require 'action'

describe Arke::Exchange::Bitfinex do
  let(:config) do
    {
      'driver' => 'rubykube',
      'host' => 'http://www.devkube.com',
      'key' => @authorized_api_key,
      'secret' => SecureRandom.hex
    }
  end
  let(:strategy) { Arke::Strategy::Copy.new('pair' => 'ethusd') }
  let(:bitfinex) { Arke::Exchange::Bitfinex.new(strategy) }

  context 'Bitfinex orderbook parsing' do
    # contains 3 orders with same id to test update and cancel actions when strategy will be ready
    let(:ws_data) do
      [
        [22496904977, 125.2, -102.98022124],
        [22496903051, 125.19, 0.2],
        [22496903051, 125.19, 0.1],
        [22496903051, 125.19, 0.0]
      ]
    end

    context 'sell order ws message processing' do
      let(:process_first_message) { bitfinex.process_data(ws_data.first) }

      it 'sends Arke::Action to strategy' do
        expect(strategy).to receive(:push).with(Arke::Action)
        process_first_message
      end

      it 'creates Arke::Action with Arke::Order as params' do
        expect(process_first_message.params).to be_an_instance_of(Arke::Order)
      end

      it 'Arke::Action comes with correct params' do
        expect(process_first_message.params.market).to eq('ethusd')
        expect(process_first_message.params.side).to eq(:sell)
        expect(process_first_message.params.amount).to eq(ws_data.first.last * -1)
        expect(process_first_message.params.id).to eq(ws_data.first.first)
        expect(process_first_message.params.price).to eq(ws_data.first[1])
      end
    end

    context 'buy order ws message processing' do
      let(:process_second_message) { bitfinex.process_data(ws_data[1]) }

      it 'sends Arke::Action to strategy' do
        expect(strategy).to receive(:push).with(Arke::Action)
        process_second_message
      end

      it 'creates Arke::Action with Arke::Order as params' do
        expect(process_second_message.params).to be_an_instance_of(Arke::Order)
      end

      it 'Arke::Action comes with correct params' do
        expect(process_second_message.params.market).to eq('ethusd')
        expect(process_second_message.params.side).to eq(:buy)
        expect(process_second_message.params.amount).to eq(ws_data[1].last)
        expect(process_second_message.params.id).to eq(ws_data[1].first)
        expect(process_second_message.params.price).to eq(ws_data[1][1])
      end
    end

    context 'cancel order ws message processing' do
      let(:process_cancel_order) { bitfinex.process_data(ws_data[3]) }

      it 'sends Arke::Action to strategy' do
        expect(strategy).to receive(:push).with(Arke::Action)
        process_cancel_order
      end

      it 'creates Arke::Action with cancel_order type and order as param' do
        expect(process_cancel_order.type).to eq(:cancel_order)
        expect(process_cancel_order.params).to be_an_instance_of(Arke::Order)
      end
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

    let(:process_snapshot_message) do
      bitfinex.process_message(snapshot_message)
    end

    let(:process_single_order) do
      bitfinex.process_message(single_order)
    end

    it 'processes snapshot' do
      expect(strategy).to receive(:push).with(Arke::Action).exactly(10).times
      process_snapshot_message
    end

    it 'processes single order' do
      expect(strategy).to receive(:push).with(Arke::Action)
      process_single_order
    end
  end
end
