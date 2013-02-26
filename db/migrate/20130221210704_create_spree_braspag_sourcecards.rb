class CreateSpreeBraspagSourcecards < ActiveRecord::Migration
  def change
    create_table :spree_braspag_sourcecards do |t|
      t.string :holder
      t.string :expiration
      t.string :number_payments
      t.string :type_payment
      t.string :payment_method

      t.timestamps
    end
  end
end
