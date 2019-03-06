describe Arke::Orderbook do
  let(:market)     { 'ethusd' }
  let(:orderbook)  { Arke::Orderbook.new('ethusd') }

  it 'creates orderbook' do
    orderbook = Arke::Orderbook.new(market)

    expect(orderbook.book).to include({ sell: ::RBTree.new })
    expect(orderbook.book).to include({ index: ::RBTree.new })
  end

  context 'orderbook#add' do
    let(:order_buy)   { Arke::Order.new('ethusd', 1, 1, :buy) }
    let(:order_sell)  { Arke::Order.new('ethusd', 1, 1, :sell) }
    let(:order_sell2) { Arke::Order.new('ethusd', 1, 1, :sell) }

    it 'adds buy order to orderbook' do
      orderbook.update(order_buy)

      expect(orderbook.book[:buy]).not_to be_nil
      expect(orderbook.book[:buy][order_buy.price]).not_to be_nil
    end

    it 'adds sell order to orderbook' do
      orderbook.update(order_sell)

      expect(orderbook.book[:sell]).not_to be_nil
      expect(orderbook.book[:sell][order_sell.price]).not_to be_nil
    end

    it 'updates order with the same price' do
      orderbook.update(order_sell)
      orderbook.update(order_sell2)

      expect(orderbook.book[:sell][order_sell.price]).to eq(order_sell2.amount)
    end
  end

  context 'orderbook#contains?' do
    let(:order0) { Arke::Order.new('ethusd', 5, 1, :buy) }
    let(:order1) { Arke::Order.new('ethusd', 8, 1, :buy) }

    it 'returns true if order is in orderbook' do
      orderbook.update(order0)
      orderbook.update(order1)

      expect(orderbook.contains?(order0)).to equal(true)
      expect(orderbook.contains?(order1)).to equal(true)
    end

    it 'returns false if order is not in orderbook' do
      expect(orderbook.contains?(order0)).to equal(false)
    end
  end

  context 'orderbook#get' do
    let(:order_sell_0)     { Arke::Order.new('ethusd', 5, 1, :sell) }
    let(:order_sell_1)     { Arke::Order.new('ethusd', 8, 1, :sell) }
    let(:order_sell_cheap) { Arke::Order.new('ethusd', 2, 1, :sell) }

    let(:order_buy_0)         { Arke::Order.new('ethusd', 5, 1, :buy) }
    let(:order_buy_1)         { Arke::Order.new('ethusd', 8, 1, :buy) }
    let(:order_buy_expensive) { Arke::Order.new('ethusd', 9, 1, :buy) }

    it 'gets order with the lowest price for sell side' do
      orderbook.update(order_sell_0)
      orderbook.update(order_sell_1)
      orderbook.update(order_sell_cheap)

      expect(orderbook.get(:sell)[0]).to equal(order_sell_cheap.price)
    end

    it 'gets order with the highest price for buy side' do
      orderbook.update(order_buy_0)
      orderbook.update(order_buy_1)
      orderbook.update(order_buy_expensive)

      expect(orderbook.get(:buy)[0]).to equal(order_buy_expensive.price)
    end
  end

  context 'orderbook#remove' do
    let(:order_buy)   { Arke::Order.new('ethusd', 1, 1, :buy) }

    it 'removes correct order from orderbook' do
      orderbook.update(order_buy)
      orderbook.update(Arke::Order.new('ethusd', order_buy.price, 1, :buy))
      orderbook.update(Arke::Order.new('ethusd', 11, 1, :sell))

      orderbook.delete(order_buy)

      expect(orderbook.contains?(order_buy)).to eq(false)
      expect(orderbook.book[:buy][order_buy.price]).to be_nil
      expect(orderbook.book[:sell]).not_to be_nil
    end

    it 'does nothing if non existing id' do
      orderbook.update(order_buy)

      orderbook.delete(Arke::Order.new('ethusd', 10, 1, :buy))

      expect(orderbook.book[:buy]).not_to be_nil
      expect(orderbook.contains?(order_buy)).to eq(true)
    end
  end

end
