module Spree
  class AlternativePaymentSource < Spree::Base
    belongs_to :payment_method
    has_many :payments, as: :source

    scope :with_payment_profile, -> {}

  end
end
