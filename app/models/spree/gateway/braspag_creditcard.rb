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
      ::Braspag
    end

    def provider
      ::Braspag::CreditCard
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
      response = provider.authorize(params)

      def response.success?
        self[:status] == "0" || self[:status] == "1"
      end

      if response.success?
        def response.authorization; self[:transaction_id]; end
        def response.avs_result; {}; end
        def response.cvv_result; {}; end
      else
        def response.to_s
          I18n.t "braspag.creditcard_error_#{self[:return_code]}", default: :generic_creditcard_error
        end
      end

      response
    end

    private
    def build_params(amount, source, options)
      {
        :order_id => options[:order_id],
        :customer_name => options[:billing_address][:name],
        :amount => Spree::Braspag::Utils.format_amount(amount),
        :payment_method => payment_method_code(source),
        :holder => source.name,
        :card_number => source.number,
        :expiration => expiration(source),
        :security_code => source.verification_value,
        :number_payments => source.installments,
        :type => payment_type(source)
      }
    end

    def expiration(source)
      m = source.month.to_s.length == 1 ? "0#{source.month}" : source.month
      y = source.year.to_s[2..3]
       "#{m}/#{y}"
    end

    def set_payment_method(brand)
      case brand
      when "Amex"; "amex_2p"
      when "Visa"; "cielo_noauth_visa"
      when "Mastercard"; "redecard"
      when "Diners"; "redecard"
      when "Hipercard"; "hipercard_sitef"
      when "Elo"; "cielo_noauth_elo"
      end
    end


    def payment_method_code(source)
      Rails.env.production? ? source.payment_method.to_sym : :braspag
    end

    def payment_type(source)
      source.installments == 1 ? '0' : '1'
    end

  end
end
