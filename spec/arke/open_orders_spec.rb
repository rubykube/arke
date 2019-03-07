describe Arke::OpenOrders do
  let(:market)          { 'ethusd' }
  let(:open_orders)     { Arke::OpenOrders.new(market) }
  let(:delete_order)    { { id: 1, order: Arke::Order.new(market, 100, 30, :buy) } }
  let(:skip_order)      { { id: 2, order: Arke::Order.new(market, 200, 20, :sell) } }
  let(:create_order)    { { id: 3, order: Arke::Order.new(market, 250, 20, :sell) } }
  let(:update_order)    { { id: 4, order: Arke::Order.new(market, 500, 10, :buy) } }
  let(:update_order_ob) { { id: 5, order: Arke::Order.new(market, 500, 5, :buy) } }

  let(:orderbook) do
    orderbook = Arke::Orderbook.new(market)

    orderbook.update(skip_order[:order])
    orderbook.update(create_order[:order])
    orderbook.update(update_order_ob[:order])

    orderbook
  end

  it '#contains?' do
    order = skip_order[:order]

    open_orders.add_order(order, skip_order[:id])

    expect(open_orders.contains?(order.side, order.price)).to eq(true)
    expect(open_orders.contains?(order.side, order.price + 100)).to eq(false)
  end

  context 'open_orders#get_diff' do
    it 'return correct diff' do
      open_orders.add_order(delete_order[:order], delete_order[:id])
      open_orders.add_order(update_order[:order], update_order[:id])
      open_orders.add_order(skip_order[:order], skip_order[:id])

      diff = open_orders.get_diff(orderbook)

      expect(diff[:create][create_order[:order].side].length).to eq(1)
      expect(diff[:create][create_order[:order].side][0].price).to eq(create_order[:order].price)
      expect(diff[:create][create_order[:order].side][0].amount).to eq(create_order[:order].amount)

      expect(diff[:update][update_order[:order].side].length).to eq(1)
      expect(diff[:update][update_order[:order].side][0].price).to eq(update_order[:order].price)
      expect(diff[:update][update_order[:order].side][0].amount)
        .to eq(update_order_ob[:order].amount - update_order[:order].amount)

      expect(diff[:delete][delete_order[:order].side].length).to eq(1)
      expect(diff[:delete][delete_order[:order].side][0]).to eq(delete_order[:id])
    end
  end
end
