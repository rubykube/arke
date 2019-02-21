require 'arke/command'

describe Arke::Command::Start do
  let(:command) { Arke::Command::Start.new(Dir.pwd) }
  let(:fake_thread) { Class.new { def join; end }.new }
  let(:fake_exchange) { Class.new(Arke::Exchange::Base) { def run; end }.new(fake_strategy) }

  before(:each) do
    allow(Thread).to receive(:new).and_yield.and_return(fake_thread)
    allow(Arke::Strategy).to receive(:create).and_return(fake_strategy)
    allow(Arke::Exchange).to receive(:create).and_return(fake_exchange)

    fake_strategy.stop
  end

  context 'run implemented' do
    let(:fake_strategy) { Class.new(Arke::Strategy::Base) { def run; end }.new }

    context 'strategy' do
      it 'inits strategy' do
        expect(Arke::Strategy).to receive(:create).and_return(fake_strategy)

        command.execute
      end

      it 'strategy workflow' do
        expect(fake_strategy).to receive(:on_start)
        expect(fake_strategy).to receive(:run_loop)
        expect(fake_strategy).to receive(:on_stop)
        expect(fake_strategy).to receive(:on_exit)

        command.execute
      end

      it 'exchange workflow' do
        expect(fake_exchange).to receive(:on_start).twice
        expect(fake_exchange).to receive(:on_stop).twice

        command.execute
      end
    end
  end
end
