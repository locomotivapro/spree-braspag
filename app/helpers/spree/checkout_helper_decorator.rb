Spree::CheckoutHelper.class_eval do

  def payment_parcels_array(amount, max_parcels, minimun_value)
    for parcel in 1..max_parcels
      parcel_value = (amount / parcel).to_f
      break if minimun_value.to_f > parcel_value && parcel != 1
      (final_array ||=[]) << ["#{parcel}x de #{number_to_currency parcel_value}","#{parcel}"]
    end
    final_array
  end

end
