module Spree
  class BraspagBillTransaction < ActiveRecord::Base
    attr_accessible :amount, :expiration_date, :message, :number, :return_code, :status, :url

    validates :amount, :expiration_date, :number, :return_code, :status, :url, presence: true
  end
end
