require 'spec_helper'
require 'action'

RSpec.describe Arke::Action do
  let(:type) { :create_order }
  let(:params) { Arke::Order.new(1, 'ethusd', 1, 1, :buy) }

  it 'creates istruction' do
    action = Arke::Action.new(type, params)

    expect(action.type).to eq(type)
    expect(action.params).to eq(params)
  end
end
