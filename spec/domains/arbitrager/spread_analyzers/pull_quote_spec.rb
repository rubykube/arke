# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable Metrics/BlockLength, Metrics/LineLength
RSpec.describe Arbitrager::SpreadAnalyzers::PullQuote do
  let(:quotes) do
    [
      { 'broker' => 'kraken', 'side' => 'ask', 'price' => '8766.80000', 'volume' => '0.200' },
      { 'broker' => 'kraken', 'side' => 'ask', 'price' => '8770.50000', 'volume' => '0.240' },
      { 'broker' => 'kraken', 'side' => 'ask', 'price' => '8774.10000', 'volume' => '0.010' },
      { 'broker' => 'kraken', 'side' => 'ask', 'price' => '8775.00000', 'volume' => '0.010' },
      { 'broker' => 'kraken', 'side' => 'ask', 'price' => '8776.00000', 'volume' => '2.390' },
      { 'broker' => 'kraken', 'side' => 'ask', 'price' => '8778.50000', 'volume' => '1.076' },
      { 'broker' => 'kraken', 'side' => 'ask', 'price' => '8779.90000', 'volume' => '0.015' },
      { 'broker' => 'kraken', 'side' => 'ask', 'price' => '8784.00000', 'volume' => '0.290' },
      { 'broker' => 'kraken', 'side' => 'ask', 'price' => '8784.10000', 'volume' => '0.030' },
      { 'broker' => 'kraken', 'side' => 'ask', 'price' => '8784.20000', 'volume' => '0.003' },

      { 'broker' => 'bitfinex', 'side' => 'ask', 'price' => '8781', 'volume' => '1.13506452' },
      { 'broker' => 'bitfinex', 'side' => 'ask', 'price' => '8781.9', 'volume' => '0.4' },
      { 'broker' => 'bitfinex', 'side' => 'ask', 'price' => '8783.2', 'volume' => '0.5' },
      { 'broker' => 'bitfinex', 'side' => 'ask', 'price' => '8789', 'volume' => '3.54336989' },
      { 'broker' => 'bitfinex', 'side' => 'ask', 'price' => '8789.6', 'volume' => '0.02' },
      { 'broker' => 'bitfinex', 'side' => 'ask', 'price' => '8789.8', 'volume' => '0.0034643' },
      { 'broker' => 'bitfinex', 'side' => 'ask', 'price' => '8789.9', 'volume' => '0.2432' },
      { 'broker' => 'bitfinex', 'side' => 'ask', 'price' => '8790', 'volume' => '27.13016061' },
      { 'broker' => 'bitfinex', 'side' => 'ask', 'price' => '8790.5', 'volume' => '0.502' },
      { 'broker' => 'bitfinex', 'side' => 'ask', 'price' => '8790.7', 'volume' => '0.1' },

      { 'broker' => 'kraken', 'side' => 'bid', 'price' => '8765.30000', 'volume' => '1.000' },
      { 'broker' => 'kraken', 'side' => 'bid', 'price' => '8764.50000', 'volume' => '3.708' },
      { 'broker' => 'kraken', 'side' => 'bid', 'price' => '8758.00000', 'volume' => '0.241' },
      { 'broker' => 'kraken', 'side' => 'bid', 'price' => '8757.90000', 'volume' => '1.000' },
      { 'broker' => 'kraken', 'side' => 'bid', 'price' => '8757.60000', 'volume' => '1.500' },
      { 'broker' => 'kraken', 'side' => 'bid', 'price' => '8752.20000', 'volume' => '3.000' },
      { 'broker' => 'kraken', 'side' => 'bid', 'price' => '8748.30000', 'volume' => '3.000' },
      { 'broker' => 'kraken', 'side' => 'bid', 'price' => '8745.00000', 'volume' => '0.290' },
      { 'broker' => 'kraken', 'side' => 'bid', 'price' => '8744.70000', 'volume' => '2.281' },
      { 'broker' => 'kraken', 'side' => 'bid', 'price' => '8744.10000', 'volume' => '4.000' },

      { 'broker' => 'bitfinex', 'side' => 'bid', 'price' => '8780.9', 'volume' => '0.34482478' },
      { 'broker' => 'bitfinex', 'side' => 'bid', 'price' => '8780.8', 'volume' => '0.84236903' },
      { 'broker' => 'bitfinex', 'side' => 'bid', 'price' => '8780', 'volume' => '4.4392' },
      { 'broker' => 'bitfinex', 'side' => 'bid', 'price' => '8779.7', 'volume' => '0.14538937' },
      { 'broker' => 'bitfinex', 'side' => 'bid', 'price' => '8779.6', 'volume' => '1.4392' },
      { 'broker' => 'bitfinex', 'side' => 'bid', 'price' => '8778.8', 'volume' => '1.4392' },
      { 'broker' => 'bitfinex', 'side' => 'bid', 'price' => '8777.1', 'volume' => '0.2' },
      { 'broker' => 'bitfinex', 'side' => 'bid', 'price' => '8776.4', 'volume' => '4.84126668' },
      { 'broker' => 'bitfinex', 'side' => 'bid', 'price' => '8774.9', 'volume' => '0.05708619' },
      { 'broker' => 'bitfinex', 'side' => 'bid', 'price' => '8774.8', 'volume' => '8.1' }
    ].map { |q| ActiveSupport::HashWithIndifferentAccess.new(q) }
  end

  let(:best_bid) do
    { 'broker' => 'bitfinex',
      'side' => 'bid',
      'price' => '8780.9',
      'volume' => '0.34482478' }
  end
  let(:best_ask) do
    {
      'broker' => 'kraken',
      'side' => 'ask',
      'price' => '8766.80000',
      'volume' => '0.200'
    }
  end
  let(:worst_bid) do
    {
      'broker' => 'kraken',
      'side' => 'bid',
      'price' => '8744.10000',
      'volume' => '4.000'
    }
  end
  let(:worst_ask) do
    {
      'broker' => 'bitfinex',
      'side' => 'ask',
      'price' => '8790.7',
      'volume' => '0.1'
    }
  end

  # best bid - highest price
  # best ask - lowest price
  context 'when best quotes option choosen' do
    it 'works' do
      expect(
        described_class.new.call(quotes, :best)
      ).to eq([best_bid, best_ask])
    end
  end

  # worst bid - lowest price
  # worst ask - highest price
  context 'when worst quotes option choosen' do
    it 'works' do
      expect(
        described_class.new.call(quotes, :worst)
      ).to eq([worst_bid, worst_ask])
    end
  end
end
# rubocop:enable Metrics/BlockLength, Metrics/LineLength
