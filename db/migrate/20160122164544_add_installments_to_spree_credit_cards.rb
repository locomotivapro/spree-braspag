class AddInstallmentsToSpreeCreditCards < ActiveRecord::Migration

  def change
    add_column :spree_credit_cardss, :installments, :integer
  end

end
