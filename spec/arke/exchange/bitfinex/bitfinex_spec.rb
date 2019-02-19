require 'exchange'

describe Arke::Exchange::Bitfinex do
  let(:pair) { 'ETHUSD' }
  let(:strategy) { double(Arke::Strategy::Copy, pair: pair) }
  let(:data) { [1, 1, 1] }
  let(:data_zero_price) { [1, 0, 1] }
  let(:bitfinex) { Arke::Exchange::Bitfinex.new(strategy) }

  it 'inits exchange' do
    expect(bitfinex).to be_instance_of(Arke::Exchange::Bitfinex)
  end

  context '#update_order' do
    it 'calls @strategy.on_order_create' do
      allow(strategy).to receive(:pair).and_return(:pair)
      expect(strategy).to receive(:on_order_create)
      expect(strategy).not_to receive(:on_order_stop)

      bitfinex.update_order(data)
    end

    it 'calls @strategy.on_order_stop if price = 0' do
      allow(strategy).to receive(:pair).and_return(:pair)
      expect(strategy).not_to receive(:on_order_create)
      expect(strategy).to receive(:on_order_stop)

      bitfinex.update_order(data_zero_price)
    end
  end

  context 'process_message' do
    let(:event_message) { { 'event' => 'subscribed' } }
    let(:channel_message) { [22496904977, 125.29, 24.0265158] }

    it 'hanles subscription event' do
      expect(bitfinex).to receive(:process_event_message)
      expect(bitfinex).not_to receive(:process_channel_message)

      bitfinex.process_message(event_message)
    end

    it 'process channel message' do
      expect(bitfinex).not_to receive(:process_event_message)
      expect(bitfinex).to receive(:process_channel_message)

      bitfinex.process_message(channel_message)
    end
  end
end
