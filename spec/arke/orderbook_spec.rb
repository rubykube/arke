require 'rbtree'
require 'orderbook'
require 'order'

RSpec.describe Arke::Orderbook do
  let(:market)     { 'ethusd' }
  let(:orderbook)  { Arke::Orderbook.new('ethusd') }

  it 'creates orderbook' do
    orderbook = Arke::Orderbook.new(market)

    expect(orderbook.book).to eq({ sell: ::RBTree.new, buy: ::RBTree.new })
  end

  context 'orderbook#add' do
    let(:order_buy)   { Arke::Order.new(1, 'ethusd', 1, 1) }
    let(:order_sell)  { Arke::Order.new(2, 'ethusd', 1, -1) }
    let(:order_sell2) { Arke::Order.new(3, 'ethusd', 1, -1) }

    it 'adds buy order to orderbook' do
      orderbook.add_order(order_buy)

      expect(orderbook.book[:buy]).not_to be_empty
      expect(orderbook.book[:buy][order_buy.price]).not_to be_empty
    end

    it 'adds sell order to orderbook' do
      orderbook.add_order(order_sell)

      expect(orderbook.book[:sell]).not_to be_empty
      expect(orderbook.book[:sell][order_sell.price]).not_to be_empty
    end

    it 'doesnt add order with the same id' do
      orderbook.add_order(order_sell)
      orderbook.add_order(order_sell)

      expect(orderbook.book[:sell][order_sell.price].count).to eq(1)
    end

    it 'adds order with the same price' do
      orderbook.add_order(order_sell)
      orderbook.add_order(order_sell2)

      expect(orderbook.book[:sell][order_sell.price].count).to eq(2)
    end
  end

  context 'orderbook#contains?' do
    let(:order0) { Arke::Order.new(1, 'ethusd', 5, 1) }
    let(:order1) { Arke::Order.new(2, 'ethusd', 5, 1) }

    it 'returns true if order is in orderbook' do
      orderbook.add_order(order0)
      orderbook.add_order(order1)

      expect(orderbook.contains?(order0)).to equal(true)
      expect(orderbook.contains?(order1)).to equal(true)
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
      orderbook.add_order(order0)
      orderbook.add_order(order1)
      orderbook.add_order(order_cheap)

      expect(orderbook.get(:buy).first.price).to equal(order_cheap.price)
    end
  end

  context 'orderbook#remove' do
    let(:order_buy)   { Arke::Order.new(1, 'ethusd', 1, 1) }

    it 'removes correct order from orderbook' do
      orderbook.add_order(order_buy)
      orderbook.add_order(Arke::Order.new(2, 'ethusd', order_buy.price, 1))
      orderbook.add_order(Arke::Order.new(3, 'ethusd', 11, -1))

      orderbook.remove_order(order_buy)

      expect(orderbook.contains?(order_buy)).to eq(false)
      expect(orderbook.book[:buy][order_buy.price]).not_to be_empty
      expect(orderbook.book[:sell]).not_to be_empty
    end

    it 'does nothing if non existing id' do
      orderbook.add_order(order_buy)

      orderbook.remove_order(Arke::Order.new(999999, 'ethusd', 10, 1))

      expect(orderbook.book[:buy]).not_to be_empty
      expect(orderbook.contains?(order_buy)).to eq(true)
    end
  end

end
