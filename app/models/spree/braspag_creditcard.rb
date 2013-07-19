module Spree
  class BraspagCreditcard < ActiveRecord::Base
    attr_accessible :expiration, :holder, :number_payments, :payment_method, :number, :month, :year, :security_code

    attr_accessor :number, :month, :year, :security_code

    has_many :payments, :as => :source, :class_name => "Spree::Payment"

    validates :month, :year,:number_payments, :numericality => { :only_integer => true }, :on => :create
    validates :number, :security_code, :holder, :presence => true, :on => :create

    validates :payment_method, inclusion: { in: %w(Amex Visa Mastercard Diners Hipercard Elo)}, :on => :create

    before_save :format_expiration, :set_payment_method

    def actions
      %w{capture void}
    end

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

    def set_payment_method
      code = case payment_method
      when "Amex"; "amex_2p"
      when "Visa"; "cielo_noauth_visa"
      when "Mastercard"; "redecard"
      when "Diners"; "redecard"
      when "Hipercard"; "hipercard_sitef"
      when "Elo"; "cielo_noauth_elo"
      end

      self.payment_method = code
    end

  end
end
