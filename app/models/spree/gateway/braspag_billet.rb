require 'securerandom'

module Spree
  class Gateway::BraspagBillet < Gateway
    preference :days_to_due, :integer, :default => 3
    preference :instructions, :string, :default => I18n.t('braspag.billet_instructions')
    preference :bank, :string
    preference :assignor, :string
    preference :billet_provider, :string

    def source_required?
      true
    end

    def payment_source_class
      Spree::AlternativePaymentSource
    end

    def provider_class
      ::BraspagRest
    end

    def provider
      ::BraspagRest::Sale
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
      params = build_params(amount, source, gateway_options)
      sale_request = provider.new(params)

      if sale_request.save
        url = sale_request.payment.printable_page_url
        source.update_attributes(billet_url: url)
        def sale_request.success?;  true;  end
        def sale_request.authorization; self.payment.id; end
        def sale_request.avs_result; {}; end
        def sale_request.cvv_result; {}; end
      else
        def sale_request.success?;  false;  end
        def sale_request.to_s
          "#{self[:message]}"
        end
      end

      sale_request
    end

    private

    def build_params(amount, source, gateway_options)
      order_number = gateway_options[:order_id].split('-').first

      {
        order_id: gateway_options[:order_id],
        request_id: SecureRandom.uuid,
        customer: {
          name: gateway_options[:billing_address][:name],
        },
        payment: {
          type: 'Boleto',
          amount: amount,
          provider: billet_provider,
          boleto_number: order_number.gsub(/\D/,''),
          assignor: preferred_assignor,
          instructions: preferred_instructions,
          expiration_date: (Date.today + preferred_days_to_due.days).strftime("%Y-%m-%d"),
          identification: customer_document(gateway_options[:customer_id], order_number)
        }
      }
    end

    def billet_provider
      ::BraspagRest.config.environment.to_s == 'production' ? preferred_billet_provider : 'Simulado'
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
