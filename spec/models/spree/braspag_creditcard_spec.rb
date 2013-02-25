require "spec_helper"

describe Spree::BraspagCreditcard do

  let(:card) { Spree::BraspagCreditcard.new(number: '0000000000000001', month: '1', year: '2015', security_code: '123', holder: 'Walter Bishop', number_payments: 1, payment_method: "Visa") }

  it "format expiration" do
    card.expiration.should be_nil
    card.save
    card.expiration.should eq "01/15"
  end

end
