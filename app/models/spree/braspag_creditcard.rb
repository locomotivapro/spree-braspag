module Spree
  class BraspagCreditcard < ActiveRecord::Base
    attr_accessible :expiration, :holder, :number_payments, :payment_method, :security_code, :type_payment, :number, :month, :year

    attr_accessor :number, :month, :year

    has_many :payments, :as => :source, :class_name => "Spree::Payment"

    validates :month, :year,:number_payments, :numericality => { :only_integer => true }, :on => :create
    validates :number, :security_code, :holder, :presence => true, :on => :create

    validates :payment_method, inclusion: { in: %w(Amex Visa Mastercard Diners Hipercard)}, :on => :create

    before_save :format_expiration, :translate_payment_method

    def can_capture?(payment)
      ['checkout', 'pending'].include?(payment.state)
    end

    def can_void?(payment)
      payment.state != 'void'
    end

  private

    def format_expiration
      m = month.length == 1 ? "0#{month}" : month
      y = year[2..3]
      self.expiration = "#{m}/#{y}"
    end

    def translate_payment_method
      code = case payment_method
      when "Amex"; "amex_2p"
      when "cielo_noauth_visa"; "71"
      when "redecard"; "20"
      when "redecard"; "20"
      when "hipercard_sitef"; "62"
      end

      self.payment_method = code
    end

  end
end
