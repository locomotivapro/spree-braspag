require "spec_helper"

describe Spree::BraspagCreditcard do

  let(:valid_attributes) { {number: '0000000000000001', month: '1', year: '2015', security_code: '123', holder: 'Walter Bishop', number_payments: 1, payment_method: "Visa"} }

  def self.payment_states
    Spree::Payment.state_machine.states.keys
  end

  def stub_rails_env(environment)
    Rails.stub(:env => ActiveSupport::StringInquirer.new(environment))
  end

  let(:credit_card) { Spree::BraspagCreditcard.new }

  context "create" do
    it "should format expiration" do
      card = Spree::BraspagCreditcard.new(valid_attributes)
      card.expiration.should be_nil
      card.save
      card.expiration.should eq "01/15"
    end
  end

  context "#can_capture?" do
    it "should be true if payment state is pending" do
      payment = mock_model(Spree::Payment, :state => 'pending', :created_at => Time.now)
      credit_card.can_capture?(payment).should be_true
    end
  end

  context "#can_void?" do

    let(:payment) { mock_model(Spree::Payment, :state => 'pending', :created_at => Time.now) }

    (payment_states - ['void']).each do |state|
      it "should be true if payment state is #{state}" do
        payment.stub :state => state
        payment.stub :void? => false
        credit_card.can_void?(payment).should be_true
      end
    end

    it "should be false if payment state is void" do
      payment.stub :state => 'void'
      credit_card.can_void?(payment).should be_false
    end
  end

  context "#valid?" do
    it "should validate presence of number" do
      credit_card.attributes = valid_attributes.except(:number)
      credit_card.should_not be_valid
      credit_card.errors[:number].should == ["can't be blank"]
    end

    it "should validate presence of security code" do
      credit_card.attributes = valid_attributes.except(:security_code)
      credit_card.should_not be_valid
      credit_card.errors[:security_code].should == ["can't be blank"]
    end

    it "should only validate on create" do
      credit_card.attributes = valid_attributes
      credit_card.save
      credit_card.should be_valid
    end
  end

  context "#save" do
    before do
      credit_card.attributes = valid_attributes
      credit_card.save!
    end

    let!(:persisted_card) { Spree::BraspagCreditcard.find(credit_card.id) }

    it "should not actually store the number" do
      persisted_card.number.should be_blank
    end

    it "should not actually store the security code" do
      persisted_card.security_code.should be_blank
    end
  end

  context "#set_payment_method" do
    before :each do
      credit_card.attributes = valid_attributes
    end

    it "match Visa to cielo_noauth_visa" do
      credit_card.payment_method = "Visa"
      credit_card.save
      credit_card.payment_method.should == 'cielo_noauth_visa'
    end

    it "match Amex to amex_2p" do
      credit_card.payment_method = "Amex"
      credit_card.save
      credit_card.payment_method.should == 'amex_2p'
    end

    it "match Mastercard to redecard" do
      credit_card.payment_method = "Mastercard"
      credit_card.save
      credit_card.payment_method.should == 'redecard'
    end

    it "match Diners to redecard" do
      credit_card.payment_method = "Diners"
      credit_card.save
      credit_card.payment_method.should == 'redecard'
    end

    it "match Hipercard to hipercard_sitef" do
      credit_card.payment_method = "Hipercard"
      credit_card.save
      credit_card.payment_method.should == 'hipercard_sitef'
    end
  end

  # context "#number=" do
  #   it "should strip non-numeric characters from card input" do
  #     pending 'MAKE NUMBER CLEANER'
  #     credit_card.number = "6011000990139424"
  #     credit_card.number.should == "6011000990139424"

  #     credit_card.number = "  6011-0009-9013-9424  "
  #     credit_card.number.should == "6011000990139424"
  #   end

  #   it "should not raise an exception on non-string input" do
  #     pending 'MAKE NUMBER CLEANER'
  #     credit_card.number = Hash.new
  #     credit_card.number.should be_nil
  #   end
  # end

  context "#associations" do
    it "should be able to access its payments" do
      lambda { credit_card.payments.all }.should_not raise_error ActiveRecord::StatementInvalid
    end
  end

end
