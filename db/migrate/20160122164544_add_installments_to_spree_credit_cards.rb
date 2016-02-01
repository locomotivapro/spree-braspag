class AddInstallmentsToSpreeCreditCards < ActiveRecord::Migration

  def change
    add_column(:spree_credit_cards, :installments, :integer) unless column_exists?(:spree_credit_cards, :installments)
  end

end
