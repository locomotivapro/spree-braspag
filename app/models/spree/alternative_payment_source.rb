module Spree
  class AlternativePaymentSource < Spree::Base
    belongs_to :payment_method
    has_many :payments, as: :source

    scope :with_payment_profile, -> {}

    def actions
      %w{capture void credit}
    end

    # Indicates whether its possible to void the payment.
    def can_void?(payment)
      !payment.void?
    end

    # Indicates whether its possible to capture the payment
    def can_capture?(payment)
      payment.pending? || payment.checkout?
    end

  end
end
