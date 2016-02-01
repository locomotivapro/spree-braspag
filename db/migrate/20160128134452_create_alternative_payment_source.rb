class CreateAlternativePaymentSource < ActiveRecord::Migration

  def change
    create_table :spree_alternative_payment_sources do |t|
      t.integer :payment_method_id
      t.string :billet_url
      t.date :expire_date

      t.timestamps
    end
  end

end
