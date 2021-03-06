require 'spec_helper'

describe TicketEvolution::Payments do
  let(:klass) { TicketEvolution::Payments }
  let(:single_klass) { TicketEvolution::Payment }
  let(:update_base) { {'url' => '/payments/1'} }

  it_behaves_like 'a ticket_evolution endpoint class'
  it_behaves_like 'a create endpoint'
  it_behaves_like 'a list endpoint'
  it_behaves_like 'a show endpoint'
  it_behaves_like 'an update endpoint'

  context 'integration tests' do
    let(:instance) { klass.new({ :parent => connection }) }

    describe 'apply' do
      let(:instance) { klass.new({ :parent => connection, :id => 1 }) }
      use_vcr_cassette 'payments/apply'

      it 'applies a payment' do
        instance.should_receive(:request).with(:GET, '/apply', { :id => 1, :check_number => 12345 })
        instance.apply({ :id => 1, :check_number => 12345 })
      end
    end

    describe 'cancel' do
      let(:instance) { klass.new({ :parent => connection, :id => 1 }) }
      use_vcr_cassette 'payments/cancel'

      it 'cancels the payment' do
        instance.should_receive(:request).with(:GET, '/cancel', nil)
        instance.cancel({ :order_id => 1, :id => 1 })
      end
    end

    describe 'refund' do
      let(:instance) { klass.new({ :parent => connection, :id => 1 }) }
      use_vcr_cassette 'payments/refund'

      it 'refunds the payment' do
        instance.should_receive(:request).with(:POST, '/refund', { :order_id => 1, :id => 1 })
        instance.refund({ :order_id => 1, :id => 1 })
      end
    end
  end
end
