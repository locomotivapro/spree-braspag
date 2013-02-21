require 'baby-braspag'

module Spree
  class PaymentMethod::BraspagBill < PaymentMethod
    preference :days_to_due, :integer, :default => 3
    preference :instructions, :string, :default => 'Instrucoes para pagamento do boleto'
    preference :bank, :string, :default => 'real'

    attr_accessible :preferred_days_to_due, :preferred_instructions, :preferred_bank

    def actions
      %w{capture void}
    end

    def source_required?
      false
    end

    def can_capture?(payment)
      ['checkout', 'pending'].include?(payment.state)
    end

    def can_void?(payment)
      payment.state != 'void'
    end

    def success?(response)
      response[:status] == '0'
    end

    def capture(*args)
      ActiveMerchant::Billing::Response.new(true, "", {}, {})
    end

    def void(*args)
      ActiveMerchant::Billing::Response.new(true, "", {}, {})
    end

    def generate_bill(order, payment)
      approval_response = Braspag::Bill.generate(build_params(order, payment))
      record_response approval_response, payment
      response_to_spree(success?(approval_response), approval_response)
    end

  private

    def build_params(order, payment)
      params = {
                :order_id => order.number,
                :amount => payment.amount,
                :payment_method => preferred_bank.to_sym,
                :instructions => preferred_instructions,
                :expiration_date => (Date.today + preferred_days_to_due.days).strftime("%d/%m/%y")
            }
      params
    end

    def record_response(response, payment)
      payment.create_braspag_bill_transaction!(amount: response[:amount],
                                              expiration_date: response[:expiration_date],
                                              message: response[:message],
                                              number: response[:number],
                                              return_code: response[:return_code],
                                              status: response[:status],
                                              url: response[:url])
    end

      def response_to_spree(response_value, response)
        ActiveMerchant::Billing::Response.new(
        response_value,
        response
        )
      end

  end
end
