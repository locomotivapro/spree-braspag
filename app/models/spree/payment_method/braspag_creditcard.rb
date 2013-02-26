module Spree
  class PaymentMethod::BraspagCreditcard < PaymentMethod
    preference :max_parcels, :integer, default: 1
    preference :minimun_parcel_value, :float, default: 10.0

    attr_accessible :preferred_max_parcels, :preferred_minimun_parcel_value

    def actions
      %w{capture void}
    end

    def payment_source_class
      BraspagCreditcard
    end

    def capture(*args)
      ActiveMerchant::Billing::Response.new(true, "", {}, {})
    end

    def void(*args)
      ActiveMerchant::Billing::Response.new(true, "", {}, {})
    end

    def authorize(source, order, payment)
      approval_response = Braspag::CreditCard.authorize(build_params(source, order, payment))
      record_response approval_response, payment
      response_to_spree(success?(approval_response), approval_response)
    end

    def success?(response)
      response[:status] == "0" || response[:status] == "1"
    end

  private

    def build_params(source, order, payment)
      {
        :order_id => source.number,
        :customer_name => order.name,
        :amount => payment.amount,
        :payment_method => payment_method_code(source),
        :holder => source.holder,
        :card_number => source.number,
        :expiration => source.expiration,
        :security_code => source.security_code,
        :number_payments => source.number_payments,
        :type => payment_type(source)
      }
    end

    def payment_method_code(source)
      Rails.env.production? ? source.payment_method.to_sym : :braspag
    end

    def payment_type(source)
      source.number_payments == '1' ? '0' : '1'
    end

    def response_to_spree(response_value, response)
      ActiveMerchant::Billing::Response.new(response_value, response)
    end

    def record_response(response, payment)
      payment.create_braspag_creditcard_transaction!({
                                          transaction_id: response[:transaction_id],
                                          amount: response[:amount],
                                          number: response[:number],
                                          return_code: response[:return_code],
                                          status: response[:status],
                                          message: response[:message]})
    end

  end
end
