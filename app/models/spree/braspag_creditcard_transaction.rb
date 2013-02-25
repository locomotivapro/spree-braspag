module Spree
  class BraspagCreditcardTransaction < ActiveRecord::Base
    attr_accessible :amount, :transaction_id, :message, :number, :return_code, :status

    validates :amount, :transaction_id, :return_code, :status, presence: true
  end
end
