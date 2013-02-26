Spree::Payment.class_eval do

  has_one :bill_transaction, :class_name => "Spree::BillTransaction"
  has_one :creditcard_transaction, :class_name => "Spree::CreditcardTransaction"

end
