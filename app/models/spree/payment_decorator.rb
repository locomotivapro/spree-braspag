Spree::Payment.class_eval do

  has_one :braspag_bill_transaction, :class_name => "Spree::BraspagBillTransaction"

end
