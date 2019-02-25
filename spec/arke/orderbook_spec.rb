require 'orderbook'
require 'order'

RSpec.describe Arke::Orderbook do
  let(:market)     { 'ethusd' }
  let(:orderbook)  { Arke::Orderbook.new('ethusd') }

  it 'creates orderbook' do
    orderbook = Arke::Orderbook.new(market)

    expect(orderbook.book).to eq({ sell: [], buy: [] })
  end

  context 'orderbook#add' do
    let(:order_buy)  { Arke::Order.new(1, 'ethusd', 1, 1) }
    let(:order_sell) { Arke::Order.new(2, 'ethusd', 1, -1) }

    it 'adds buy order to orderbook' do
      orderbook.add(order_buy)

      expect(orderbook.book[:buy]).not_to be_empty
      expect(orderbook.book[:buy]).to include(order_buy)
    end

    it 'adds sell order to orderbook' do
      orderbook.add(order_sell)

      expect(orderbook.book[:sell]).not_to be_empty
      expect(orderbook.book[:sell]).to include(order_sell)
    end

    it 'doesnt add the same order' do
      orderbook.add(order_sell)
      orderbook.add(order_sell)

      expect(orderbook.book[:sell].count).to eq(1)
    end
  end

  context 'orderbook#remove' do
    let(:order_buy)  { Arke::Order.new(1, 'ethusd', 1, 1) }

    it 'removes correct order from orderbook' do
      orderbook.add(order_buy)
      orderbook.add(Arke::Order.new(2, 'ethusd', 1, 1))
      orderbook.add(Arke::Order.new(3, 'ethusd', 1, -1))

      orderbook.remove(order_buy)

      expect(orderbook.book[:buy]).not_to include(order_buy)
      expect(orderbook.book[:buy]).not_to be_empty
      expect(orderbook.book[:sell]).not_to be_empty
    end

    it 'does nothing if non existing id' do
      orderbook.add(order_buy)

      orderbook.remove(Arke::Order.new(999999, 'ethusd', 1, 1))

      expect(orderbook.book[:buy]).not_to be_empty
      expect(orderbook.book[:buy]).to include(order_buy)
    end
  end

  context 'orderbook#update' do
    let(:order_buy)     { Arke::Order.new(1, 'ethusd', 1, 1) }
    let(:order_buy_new) { Arke::Order.new(1, 'ethusd', 10, 1) }
    let(:order_invalid) { Arke::Order.new(9999999, 'ethusd', 10, 1) }

    it 'updates order' do
      orderbook.add(order_buy)

      orderbook.update(order_buy_new)

      expect(orderbook.book[:buy]).not_to include(order_buy)
      expect(orderbook.book[:buy]).to include(order_buy_new)
    end

    it 'does nothing if non existing id' do
      orderbook.add(order_buy)

      orderbook.update(order_invalid)

      expect(orderbook.book[:buy]).not_to be_empty
      expect(orderbook.book[:buy]).to include(order_buy)
      expect(orderbook.book[:buy]).not_to include(order_invalid)
    end
  end

  context 'orderbook#contains?' do
    let(:order0) { Arke::Order.new(1, 'ethusd', 5, 1) }

    it 'returns true if order is in orderbook' do
      orderbook.add(order0)

      expect(orderbook.contains?(order0)).to equal(true)
    end

    it 'returns false if order is not in orderbook' do
      expect(orderbook.contains?(order0)).to equal(false)
    end
  end

  context 'orderbook#get' do
    let(:order0)      { Arke::Order.new(1, 'ethusd', 5, 1) }
    let(:order1)      { Arke::Order.new(3, 'ethusd', 8, 1) }
    let(:order_cheap) { Arke::Order.new(2, 'ethusd', 2, 1) }

    it 'gets order with the lowest price' do
      orderbook.add(order0)
      orderbook.add(order1)
      orderbook.add(order_cheap)

      expect(orderbook.get(:buy).price).to equal(order_cheap.price)
    end
  end
end
