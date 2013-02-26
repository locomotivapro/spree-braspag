require "spec_helper"

describe Spree::BraspagCreditcardTransaction do

  context "validation" do
    it "validates :amount, :transaction_id, :return_code, :status" do
      braspag_transaction = Spree::BraspagCreditcardTransaction.new
      braspag_transaction.should be_invalid
      braspag_transaction.amount = "100"
      braspag_transaction.should be_invalid
      braspag_transaction.transaction_id = "1231asrf214"
      braspag_transaction.should be_invalid
      braspag_transaction.return_code = '1'
      braspag_transaction.should be_invalid
      braspag_transaction.status = '1'
      braspag_transaction.should  be_valid
    end
  end


  context "#associations" do
    braspag_transaction = Spree::BraspagCreditcardTransaction.new
    it "should be able to access its payments" do
      lambda { braspag_transaction.payment }.should_not raise_error ActiveRecord::StatementInvalid
    end
  end
end
