class CreateSpreeBraspagCreditcards < ActiveRecord::Migration
  def change
    create_table :spree_braspag_creditcards do |t|
      t.string :holder
      t.string :expiration
      t.string :security_code
      t.string :number_payments
      t.string :type_payment
      t.string :payment_method

      t.timestamps
    end
  end
end
