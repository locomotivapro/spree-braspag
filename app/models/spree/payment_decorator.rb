Spree::Payment.class_eval do

  has_one :braspag_bill_transaction, :class_name => "Spree::BraspagBillTransaction"
  has_one :braspag_creditcard_transaction, :class_name => "Spree::BraspagCreditcardTransaction"

end
