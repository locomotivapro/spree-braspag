=begin
Deface::Override.new(:virtual_path => "spree/shared/_order_details",
                     :name => "add_bill_link",
                     :insert_bottom => ".payment-info",
                     :partial => "spree/shared/braspag_bill")

Deface::Override.new(:virtual_path => "spree/admin/payments/_list",
                     :name => "add_bill_link_to_admin_payments_list",
                     :insert_bottom => "tr[data-hook=payments_row]//td[2]") do
                       "<%= link_to('   Abrir boleto', payment.bill_transaction.url, target: '_blank') if payment.payment_method.kind_of?(Spree::PaymentMethod::BraspagBill)%>"
                     end
=end
