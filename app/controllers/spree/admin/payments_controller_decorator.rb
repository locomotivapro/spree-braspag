Spree::Admin::PaymentsController.class_eval do

  def create
    # Overriding the core method because route is wrong when there is a payment error
    @payment = @order.payments.build(object_params)
    if @payment.payment_method.is_a?(Spree::Gateway) && @payment.payment_method.payment_profiles_supported? && params[:card].present? and params[:card] != 'new'
      @payment.source = Creditcard.find_by_id(params[:card])
    end

    begin
      unless @payment.save
        respond_with(@payment) { |format| format.html { redirect_to admin_order_payments_path(@order) } }
        return
      end

      if @order.completed?
        @payment.process!
        flash.notice = flash_message_for(@payment, :successfully_created)

        respond_with(@payment) { |format| format.html { redirect_to admin_order_payments_path(@order) } }
      else
        #This is the first payment (admin created order)
        until @order.completed?
          @order.next!
        end
        flash.notice = t(:new_order_completed)
        respond_with(@payment) { |format| format.html { redirect_to admin_order_url(@order) } }
      end

    rescue Spree::Core::GatewayError => e
      flash[:error] = "#{e.message}"
      respond_with(@payment) { |format| format.html { redirect_to new_admin_order_payment_path(@order) } }
    end
  end

end
