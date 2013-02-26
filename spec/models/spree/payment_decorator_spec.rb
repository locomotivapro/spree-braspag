require 'spec_helper'

describe Spree::Payment do

  let(:order) do
    order = Spree::Order.new(:bill_address => Spree::Address.new,
                             :ship_address => Spree::Address.new)
  end

  context "processing" do
    before do
      payment.stub(:update_order)
      payment.stub(:create_payment_profile)
    end

    context "#process! a BraspagBill" do
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

      it "should send to braspag_gateway_action if payment_method is a BraspagBill" do
        payment.should_receive(:braspag_gateway_action)
        payment.process!
      end
    end

    context "#process! a BraspagGateway" do
      let(:gateway) do
        gateway = Spree::PaymentMethod::BraspagCreditcard.new({:environment => 'test', :active => true}, :without_protection => true)
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

      it "should send to braspag_creditcard_action if payment_method is a BraspagBill" do
        payment.should_receive(:braspag_creditcard_action)
        payment.process!
      end

    end

    context "associations" do
      let(:payment) { Spree::Payment.new }

      it "should have a braspag_bill" do
        payment.braspag_bill_transaction.should_not raise_error ActiveRecord::StatementInvalid
      end

      it "should have a braspag_creditcard" do
        payment.braspag_creditcard_transaction.should_not raise_error ActiveRecord::StatementInvalid
      end
    end

  end
end

