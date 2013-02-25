class CreateSpreeBraspagCreditcardTransactions < ActiveRecord::Migration

  def change
    create_table :spree_braspag_creditcard_transactions do |t|
      t.integer :payment_id
      t.string :transaction_id
      t.decimal :amount
      t.string :number
      t.string :return_code
      t.string :status
      t.string :message

      t.timestamps
    end
  end

end
