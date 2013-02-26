class CreateSpreeBraspagTransactions < ActiveRecord::Migration
  def up
    create_table :spree_braspag_transactions do |t|
      t.integer :payment_id
      t.string :type
      t.string :url
      t.decimal :amount
      t.string :number
      t.date :expiration_date
      t.string :return_code
      t.string :status
      t.string :message
      t.string :transaction_id

      t.timestamps
    end
  end

  def down
    drop_table :spree_braspag_transactions
  end
end
