module Spree
  module Braspag
    class Utils

      def self.payment_parcels_array(amount, max_parcels, minimun_value, context)
        for parcel in 1..max_parcels
          parcel_value = (amount / parcel).to_f
          break if minimun_value.to_f > parcel_value && parcel != 1
          (final_array ||=[]) << ["#{parcel}x de #{context.number_to_currency parcel_value}","#{parcel}"]
        end
        final_array
      end

      def self.format_amount(amount)
        raise ArgumentError unless amount.is_a?(Integer)
        amount = amount.to_s

        cents = amount.reverse!.slice!(0..1).reverse!
        integer = amount.reverse!

        integer = "0" if integer == ''
        cents = "0#{cents}" if cents.size == 1

        "#{integer},#{cents}"
      end

    end
  end
end
