require 'arke'
require 'action'

describe Arke::Exchange::Binance do
  include_context 'mocked binance'

  let(:binance) { Arke::Exchange::Binance.new({'market' => 'ethusdt'}) }

  context 'ojbect initialization' do
    it 'is a sublass of Arke::Exchange::Base' do
      expect(Arke::Exchange::Binance.superclass).to eq(Arke::Exchange::Base)
    end

    it 'has an orderbook' do
      expect(binance.orderbook).to be_an_instance_of(Arke::Orderbook)
    end
  end

  context 'getting snapshot' do
    let(:snapshot_buy_order_1) { Arke::Order.new('ethusdt', '135.84000000', '6.62227000', :buy) }
    let(:snapshot_buy_order_2) { Arke::Order.new('ethusdt', '135.85000000', '0.57176000', :buy) }
    let(:snapshot_buy_order_3) { Arke::Order.new('ethusdt', '135.87000000', '36.43875000', :buy) }

    let(:snapshot_sell_order_1) { Arke::Order.new('ethusdt', '135.91000000', '0.00070000', :sell) }
    let(:snapshot_sell_order_2) { Arke::Order.new('ethusdt', '135.93000000', '8.00000000', :sell) }
    let(:snapshot_sell_order_3) { Arke::Order.new('ethusdt', '135.95000000', '1.11699000', :sell) }

    it 'gets a snapshot' do
      binance.get_snapshot
      expect(binance.orderbook.book[:buy].empty?).to be false
      expect(binance.orderbook.book[:sell].empty?).to be false
    end

    it 'gets filled with buy orders from snapshot' do
      binance.get_snapshot
      expect(binance.orderbook.contains?(snapshot_buy_order_1)).to eq(true)
      expect(binance.orderbook.contains?(snapshot_buy_order_2)).to eq(true)
      expect(binance.orderbook.contains?(snapshot_buy_order_3)).to eq(true)
    end

    it 'gets filled with sell orders from snapshot' do
      binance.get_snapshot
      expect(binance.orderbook.contains?(snapshot_sell_order_1)).to eq(true)
      expect(binance.orderbook.contains?(snapshot_sell_order_2)).to eq(true)
      expect(binance.orderbook.contains?(snapshot_sell_order_3)).to eq(true)
    end
  end

  context 'binance message processing' do
    let(:example_message) do
        OpenStruct.new({
          'data' => "{\"e\":\"depthUpdate\",\"E\":1551458278012,\"s\":\"ETHUSDT\",\"U\":320977456,\"u\":320977468,\"b\":[[\"136.43000000\",\"0.66174000\",[]],[\"136.07000000\",\"29.38270000\",[]]],\"a\":[[\"136.44000000\",\"5.15285000\",[]],[\"136.45000000\",\"165.29973000\",[]],[\"136.50000000\",\"0.16122000\",[]],[\"136.51000000\",\"0.93508000\",[]],[\"136.52000000\",\"25.20000000\",[]]]}"
        })
    end

    let(:example_messsage_buy_order_1) { Arke::Order.new('ethusdt', '136.07000000', '29.38270000', :buy) }
    let(:example_messsage_buy_order_2) { Arke::Order.new('ethusdt', '136.43000000', '0.66174000', :buy) }

    let(:example_messsage_sell_order_1) { Arke::Order.new('ethusdt', '136.44000000', '5.15285000', :sell) }
    let(:example_messsage_sell_order_2) { Arke::Order.new('ethusdt', '136.45000000', '165.29973000', :sell) }
    let(:example_messsage_sell_order_3) { Arke::Order.new('ethusdt', '136.50000000', '0.16122000', :sell) }
    let(:example_messsage_sell_order_4) { Arke::Order.new('ethusdt', '136.51000000', '0.93508000', :sell) }
    let(:example_messsage_sell_order_5) { Arke::Order.new('ethusdt', '136.52000000', '25.20000000', :sell) }

    it 'parses message and fills orderbook with data from it' do
      binance.on_message(example_message)

      expect(binance.orderbook.contains?(example_messsage_buy_order_1)).to eq(true)
      expect(binance.orderbook.contains?(example_messsage_buy_order_2)).to eq(true)

      expect(binance.orderbook.contains?(example_messsage_sell_order_1)).to eq(true)
      expect(binance.orderbook.contains?(example_messsage_sell_order_2)).to eq(true)
      expect(binance.orderbook.contains?(example_messsage_sell_order_3)).to eq(true)
      expect(binance.orderbook.contains?(example_messsage_sell_order_4)).to eq(true)
      expect(binance.orderbook.contains?(example_messsage_sell_order_5)).to eq(true)
    end

    context 'handling last_update_id value' do
      let(:with_invalid_update_value) do
        OpenStruct.new({
          'data' => "{\"e\":\"depthUpdate\",\"E\":1551458278013,\"s\":\"ETHUSDT\",\"U\":320977465,\"u\":320977471,\"b\":[[\"136.44000000\",\"0.66174000\",[]],[\"137.07000000\",\"29.38270000\",[]]],\"a\":[[\"136.44000000\",\"5.15285000\",[]],[\"136.45000000\",\"165.29973000\",[]],[\"136.50000000\",\"0.16122000\",[]],[\"136.51000000\",\"0.93508000\",[]],[\"136.52000000\",\"25.20000000\",[]]]}"
        })
      end

      let(:with_valid_update_value) do
        OpenStruct.new({
          'data' => "{\"e\":\"depthUpdate\",\"E\":1551458278014,\"s\":\"ETHUSDT\",\"U\":320977469,\"u\":320977483,\"b\":[[\"136.44000000\",\"0.66174000\",[]],[\"137.07000000\",\"29.38270000\",[]]],\"a\":[[\"136.44000000\",\"5.15285000\",[]],[\"136.45000000\",\"165.29973000\",[]],[\"136.50000000\",\"0.16122000\",[]],[\"136.51000000\",\"0.93508000\",[]],[\"136.52000000\",\"25.20000000\",[]]]}"
        })
      end

      it 'accepts only message with correct update_id and changes current one' do
        binance.on_message(example_message)
        expect{ binance.on_message(with_invalid_update_value) }.to_not change{ binance.last_update_id }
        expect{ binance.on_message(with_valid_update_value) }.to change{ binance.last_update_id }
      end
    end

    context 'price level removing' do
      let(:order_to_remove) { Arke::Order.new('ethusdt', '136.07000000', '29.38270000', :buy) }
      let(:price_level_to_remove) { [["136.07000000", "0.00000000",[]]] }

      it 'removes specified order' do
        binance.on_message(example_message)
        expect{ binance.process(price_level_to_remove, :buy) }.to change{ binance.orderbook.contains?(order_to_remove) }.from(true).to(false)
      end
    end
  end
end
