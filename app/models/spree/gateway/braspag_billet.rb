module Spree
  class Gateway::BraspagBillet < Gateway
    preference :days_to_due, :integer, :default => 3
    preference :instructions, :string, :default => I18n.t('braspag.billet_instructions')
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

    def capture(amount, response_code, gateway_options = {})
      #value = { currency: gateway_options[:currency], value: amount }
      #response = provider.capture_payment(response_code, value)

      #if response.success?
        #def response.authorization; nil; end
        #def response.avs_result; {}; end
        #def response.cvv_result; {}; end
      #else
        ## todo confirm the error response will always have these two methods
        #def response.to_s
          #"#{result_code} - #{refusal_reason}"
        #end
      #end
      #response

      ActiveMerchant::Billing::Response.new(true, '', {}, :test => false, :authorization => '')
    end

    def void(response_code, source, gateway_options = {})
      #response = provider.cancel_payment(response_code)
      #response

      ActiveMerchant::Billing::Response.new(true, '', {}, :test => false, :authorization => '')
    end

    def method_type
      'braspag_billet'
    end

    def payment_profiles_supported?
      false
    end

    def authorize(amount, source, gateway_options={})
      response = provider.generate(build_params(amount, source, gateway_options))

      def response.success?
        self[:status] == '0'
      end

      if response.success?
        source.update_attributes(billet_url: response[:url])
        def response.authorization; self[:number]; end
        def response.avs_result; {}; end
        def response.cvv_result; {}; end
      else
        source.payment.failure
        def response.to_s
          "#{self[:message]}"
        end
      end

      response
    end

    private

    def build_params(amount, source, gateway_options)
      order_number = gateway_options[:order_id].split('-').first.gsub(/\D/,'')
      amount = amount / 100.0

      params = {
        :order_id => gateway_options[:order_id],
        :number => order_number,
        :amount => amount,
        :payment_method => preferred_bank.to_sym,
        :instructions => preferred_instructions,
        :expiration_date => (Date.today + preferred_days_to_due.days).strftime("%d/%m/%y"),
        :customer_name => gateway_options[:billing_address][:name],
        :customer_id => customer_document(gateway_options[:customer_id], order_number)
      }
      params
    end

    def customer_document(user_id, order_number)
      user = Spree::User.where(id: user_id).first

      if user
        user.account_type == 'personal' ? user.cpf : user.cnpj
      else
        order = Spree::Order.find_by(number: order_number)
        order.document
      end
    rescue
      ''
    end

  end
end
