require "spec_helper"

describe Spree::BillTransaction do

  context "validation" do
    it "validates :amount, :expiration_date, :number, :return_code, :status, :url" do
      braspag_bill = Spree::BillTransaction.new
      braspag_bill.should be_invalid
      braspag_bill.amount = "100"
      braspag_bill.should be_invalid
      braspag_bill.expiration_date = "23/12/2012"
      braspag_bill.should be_invalid
      braspag_bill.return_code = '1'
      braspag_bill.should be_invalid
      braspag_bill.status = '1'
      braspag_bill.should  be_invalid
      braspag_bill.number = '213123'
      braspag_bill.should  be_invalid
      braspag_bill.url = 'http://www.someurl.com'
      braspag_bill.should  be_valid
    end
  end


  context "#associations" do
    braspag_bill = Spree::BillTransaction.new
    it "should be able to access its payments" do
      lambda { braspag_bill.payment }.should_not raise_error ActiveRecord::StatementInvalid
    end
  end
end
