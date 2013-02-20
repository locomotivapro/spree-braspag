Spree::Payment::Processing.module_eval do

  def process!
    if payment_method && payment_method.source_required?
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
      gateway_action(order, :generate_bill, :pend)
    end
  end

end
