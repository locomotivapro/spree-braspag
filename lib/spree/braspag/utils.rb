module Spree
  module Braspag
    class Utils

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
