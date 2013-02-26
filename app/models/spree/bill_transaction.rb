module Spree
  class BillTransaction < Spree::BraspagTransaction
    attr_accessible :amount, :expiration_date, :message, :number, :return_code, :status, :url

    validates :amount, :expiration_date, :number, :return_code, :status, :url, presence: true
  end
end
