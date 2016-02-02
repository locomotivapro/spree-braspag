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

    def actions
      %w{capture void authorize}
    end

    def cancel(response_code)
      payment = Spree::Payment.find_by response_code: response_code
      payment.void
    rescue
      true
    end

    def can_void?(payment)
      !payment.void?
    end

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
      response = provider.generate(build_params(amount, source, gateway_options))

      def response.success?
        self[:status] == '0'
      end

      if response.success?
        source.update_attributes(billet_url: response[:url])
        def response.authorization; self[:number]; end
        def response.avs_result; {}; end
        def response.cvv_result; { 'code' => self[:return_code] }; end
      else
        def response.to_s
          "#{self[:message]}"
        end
      end

      response
    end

    private

    def build_params(amount, source, gateway_options)
      order_number = gateway_options[:order_id].split('-').first

      params = {
        :order_id => gateway_options[:order_id],
        #:number => order_number,
        :amount => Spree::Braspag::Utils.format_amount(amount),
        :payment_method => preferred_bank.to_sym,
        :instructions => preferred_instructions,
        :expiration_date => (Date.today + preferred_days_to_due.days).strftime("%d/%m/%y"),
        :customer_name => gateway_options[:billing_address][:name],
        :customer_id => customer_document(gateway_options[:customer_id], order_number)
      }
      params
    end

    def customer_document(user_id, order_number)
      user = Spree::User.find user_id

      if user
        user.account_type == 'personal' ? user.cpf : user.cnpj
      else
        order = Spree::Order.find_by :number
        order.document
      end
    rescue
      ''
    end

  end
end
