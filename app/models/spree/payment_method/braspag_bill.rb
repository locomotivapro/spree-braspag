require 'baby-braspag'

module Spree
  class PaymentMethod::BraspagBill < PaymentMethod

    def actions
      %w{capture void}
    end

    def source_required?
      false
    end

    def generate_bill(amount, order, options=nil)

       approval_response = Braspag::Bill.generate({
        :order_id => 2901,
        :amount => 3,
        :payment_method => :real,
        :number => "123123",
        :expiration_date => Date.today.strftime("%d/%m/%y")
      })

       logger.info("RESPOSTA ====> #{approval_response}")

      response_to_spree(success?(approval_response), approval_response)
    end

    # Indicates whether its possible to capture the payment
    def can_capture?(payment)
      ['checkout', 'pending'].include?(payment.state)
    end

    # Indicates whether its possible to void the payment.
    def can_void?(payment)
      payment.state != 'void'
    end

    def success?(approval_response)
      approval_response
    end

    def capture(*args)
      ActiveMerchant::Billing::Response.new(true, "", {}, {})
    end

    def void(*args)
      ActiveMerchant::Billing::Response.new(true, "", {}, {})
    end

  private

    def response_to_spree(response_value, response)
      ActiveMerchant::Billing::Response.new(
      response_value,
      response
      )
    end

  end
end
