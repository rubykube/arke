describe Arke::Action do
  let(:type)   { :create_order }
  let(:dest)   { :bitfaker }
  let(:params) { Arke::Order.new('ethusd', 1, 1, :buy) }

  it 'creates istruction' do
    action = Arke::Action.new(type, dest, params)

    expect(action.type).to eq(type)
    expect(action.params).to eq(params)
    expect(action.destination).to eq(dest)
  end
end
