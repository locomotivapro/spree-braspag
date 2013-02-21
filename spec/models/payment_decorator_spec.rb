require 'spec_helper'

describe Spree::Payment do

  let(:order) do
    order = Spree::Order.new(:bill_address => Spree::Address.new,
                             :ship_address => Spree::Address.new)
  end

  let(:gateway) do
    gateway = Spree::PaymentMethod::BraspagBill.new({:environment => 'test', :active => true}, :without_protection => true)
    gateway.stub :source_required => false
    gateway
  end

  let(:payment) do
    payment = Spree::Payment.new
    payment.order = order
    payment.payment_method = gateway
    payment
  end

  before(:each) do
    payment.log_entries.stub(:create)
  end

  context "processing" do
    before do
      payment.stub(:update_order)
      payment.stub(:create_payment_profile)
    end

    context "#process!" do

      it "should send to braspag_gateway_action if payment_method is a BraspagBill" do
        payment.should_receive(:braspag_gateway_action)
        payment.process!
      end

    end
  end
end

