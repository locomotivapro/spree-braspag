module Spree
  class Gateway::BraspagBillet < Gateway
    preference :days_to_due, :integer, :default => 3
    preference :instructions, :string, :default => 'Instrucoes para pagamento do boleto'
    preference :bank, :string

    def source_required?
      true
    end

    def payment_source_class
      Spree::AlternativePaymentSource
    end

    def provider_class
      ::Braspag
    end

    def provider
      ::Braspag::Bill
    end

    def auto_capture?
      false
    end

    def actions
      %w{capture void authorize}
    end

    def cancel(response_code)
      payment = Spree::Payment.find_by response_code: response_code
      payment.void
    rescue
      true
    end

    # Indicates whether its possible to void the payment.
    def can_void?(payment)
      !payment.void?
    end

    # Indicates whether its possible to capture the payment
    def can_capture?(payment)
      payment.pending? || payment.checkout?
    end

    def method_type
      'braspag_billet'
    end

    def payment_profiles_supported?
      false
    end

    def authorize(amount, source, gateway_options={})
      binding.pry
      response = provider.generate(build_params(order, payment))

      if response.success?
        def response.authorization; psp_reference; end
        def response.avs_result; {}; end
        def response.cvv_result; { 'code' => result_code }; end
      else
        def response.to_s
          "#{result_code} - #{http_response}"
        end
      end

      response
    end

    private

    def build_params(order, payment)
      params = {
        :order_id => order.number,
        :number => order.number,
        :amount => payment.amount,
        :payment_method => preferred_bank.to_sym,
        :instructions => preferred_instructions,
        :expiration_date => (Date.today + preferred_days_to_due.days).strftime("%d/%m/%y"),
        :customer_name => customer_name(order),
        :customer_id => customer_document(order)
      }
      params
    end

    def customer_name(order)
      order.bill_address.full_name
    rescue
      ''
    end

    def customer_document(order)
      if order.user.present?
        order.user.account_type == 'personal' ? order.user.cpf : order.user.cnpj
      else
        order.document
      end
    rescue
      ''
    end

  end
end
