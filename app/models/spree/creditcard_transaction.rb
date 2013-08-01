module Spree
  class CreditcardTransaction < Spree::BraspagTransaction
    attr_accessible :amount, :transaction_id, :message, :number, :return_code, :status

    validates :return_code, :status, presence: true
  end
end
