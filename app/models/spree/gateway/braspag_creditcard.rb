require 'securerandom'

module Spree
  class Gateway::BraspagCreditcard < Gateway
    preference :max_parcels, :integer, default: 1
    preference :minimun_parcel_value, :float, default: 10.0

    def payment_profiles_supported?
      false
    end

    def method_type
      'braspag_creditcard'
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

    def authorize(amount, source, gateway_options={})
      params = build_params(amount, source, gateway_options)
      sale_request = provider.new(params)

      if sale_request.save
        def sale_request.success?;  true;  end
        def sale_request.authorization; self.payment.id; end
        def sale_request.avs_result; {}; end
        def sale_request.cvv_result; {}; end
      else
        def sale_request.success?;  false;  end
        def sale_request.to_s
          I18n.t "braspag.creditcard_error_#{self.payment.status}", default: :generic_creditcard_error
        end
      end

      sale_request
    end

    private
    def build_params(amount, source, options)
      {
        :order_id => options[:order_id],
        :request_id => SecureRandom.uuid,
        :customer => {
          :name => options[:billing_address][:name],
        },
        :payment => {
          :type => 'CreditCard',
          :amount => amount,
          :provider => payment_method_code(source),
          :installments => source.installments,
          :credit_card => {
            :holder => source.name,
            :number => source.number,
            :expiration_date => expiration(source),
            :security_code => source.verification_value,
            :brand => payment_type(source)
          }
        }
      }
    end

    def expiration(source)
      m = source.month.to_s.length == 1 ? "0#{source.month}" : source.month
      y = source.year
       "#{m}/#{y}"
    end

    def set_payment_method(brand)
      case brand.downcase
      when "amex", "american_express" then "amex_2p"
      when "visa" then "cielo_noauth_visa"
      when "master", "mastercard", "maestro", "diners", "diners_club" then "redecard"
      when "hipercard" then "hipercard_sitef"
      when "elo" then "cielo_noauth_elo"
      end
    end


    def payment_method_code(source)
      ::BraspagRest.config.environment.to_s == 'production' ? set_payment_method(source.brand).to_sym : 'Simulado'
    end

    def payment_type(source)
      source.installments == 1 ? '0' : '1'
    end

  end
end
