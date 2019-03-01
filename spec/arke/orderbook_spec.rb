describe Arke::Orderbook do
  let(:market)     { 'ethusd' }
  let(:orderbook)  { Arke::Orderbook.new('ethusd') }

  it 'creates orderbook' do
    orderbook = Arke::Orderbook.new(market)

    expect(orderbook.book).to eq({ sell: ::RBTree.new, buy: ::RBTree.new , index: ::RBTree.new })
  end

  context 'orderbook#add' do
    let(:order_buy)   { Arke::Order.new(1, 'ethusd', 1, 1, :buy) }
    let(:order_sell)  { Arke::Order.new(2, 'ethusd', 1, 1, :sell) }
    let(:order_sell2) { Arke::Order.new(3, 'ethusd', 1, 1, :sell) }

    it 'adds buy order to orderbook' do
      orderbook.create(order_buy)

      expect(orderbook.book[:buy]).not_to be_empty
      expect(orderbook.book[:buy][order_buy.price]).not_to be_empty
    end

    it 'adds sell order to orderbook' do
      orderbook.create(order_sell)

      expect(orderbook.book[:sell]).not_to be_empty
      expect(orderbook.book[:sell][order_sell.price]).not_to be_empty
    end

    it 'doesnt add order with the same id' do
      orderbook.create(order_sell)
      orderbook.create(order_sell)

      expect(orderbook.book[:sell][order_sell.price].count).to eq(1)
    end

    it 'adds order with the same price' do
      orderbook.create(order_sell)
      orderbook.create(order_sell2)

      expect(orderbook.book[:sell][order_sell.price].count).to eq(2)
    end
  end

  context 'orderbook#contains?' do
    let(:order0) { Arke::Order.new(1, 'ethusd', 5, 1, :buy) }
    let(:order1) { Arke::Order.new(2, 'ethusd', 5, 1, :buy) }

    it 'returns true if order is in orderbook' do
      orderbook.create(order0)
      orderbook.create(order1)

      expect(orderbook.contains?(order0)).to equal(true)
      expect(orderbook.contains?(order1)).to equal(true)
    end

    it 'returns false if order is not in orderbook' do
      expect(orderbook.contains?(order0)).to equal(false)
    end
  end

  context 'orderbook#get' do
    let(:order0)      { Arke::Order.new(1, 'ethusd', 5, 1, :buy) }
    let(:order1)      { Arke::Order.new(3, 'ethusd', 8, 1, :buy) }
    let(:order_cheap) { Arke::Order.new(2, 'ethusd', 2, 1, :buy) }

    it 'gets order with the lowest price' do
      orderbook.create(order0)
      orderbook.create(order1)
      orderbook.create(order_cheap)

      expect(orderbook.get(:buy).first.price).to equal(order_cheap.price)
    end
  end

  context 'orderbook#remove' do
    let(:order_buy)   { Arke::Order.new(1, 'ethusd', 1, 1, :buy) }

    it 'removes correct order from orderbook' do
      orderbook.create(order_buy)
      orderbook.create(Arke::Order.new(2, 'ethusd', order_buy.price, 1, :buy))
      orderbook.create(Arke::Order.new(3, 'ethusd', 11, 1, :sell))

      orderbook.delete(order_buy)

      expect(orderbook.contains?(order_buy)).to eq(false)
      expect(orderbook.book[:buy][order_buy.price]).not_to be_empty
      expect(orderbook.book[:sell]).not_to be_empty
    end

    it 'does nothing if non existing id' do
      orderbook.create(order_buy)

      orderbook.delete(Arke::Order.new(999999, 'ethusd', 10, 1, :buy))

      expect(orderbook.book[:buy]).not_to be_empty
      expect(orderbook.contains?(order_buy)).to eq(true)
    end
  end

end
