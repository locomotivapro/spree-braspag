class AddUserIdToAlternativePaymentSource < ActiveRecord::Migration

  def change
    add_column :spree_alternative_payment_sources, :user_id, :integer
    add_index :spree_alternative_payment_sources, :user_id
  end

end
