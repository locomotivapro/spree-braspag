class CreateBraspagBillTransactions < ActiveRecord::Migration
  def change
    create_table :spree_braspag_bill_transactions do |t|
      t.integer :payment_id
      t.string :url
      t.decimal :amount
      t.string :number
      t.date :expiration_date
      t.string :return_code
      t.string :status
      t.string :message

      t.timestamps
    end
  end
end
