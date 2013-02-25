Spree::Payment::Processing.module_eval do

  def process!
    if payment_method && payment_method.source_required? && !payment_method.kind_of?(Spree::BraspagGateway)
      if source
        if !processing?
          if Spree::Config[:auto_capture]
            purchase!
          else
            authorize!
          end
        end
      else
        raise Core::GatewayError.new(I18n.t(:payment_processing_failed))
      end
    elsif payment_method && payment_method.kind_of?(Spree::PaymentMethod::BraspagBill)
      started_processing!
      braspag_gateway_action(order, :generate_bill, :pend)
    elsif payment_method && payment_method.kind_of?(Spree::BraspagGateway)
      started_processing!
      braspag_creditcard_action(:authorize, :pend)
    end
  end

  private

    def braspag_creditcard_action(action, success_state)
      protect_from_connection_error do
        check_environment

        response = payment_method.send(action, source, order, self)
        handle_response(response, success_state, :failure)
      end
    end

    def braspag_gateway_action(order, action, success_state)
      protect_from_connection_error do
        check_environment

        response = payment_method.send(action, order, self)
        handle_response(response, success_state, :failure)
      end
    end

end
