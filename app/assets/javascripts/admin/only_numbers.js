$(document).ready(function() {
    $("#new_payment #card_number, #new_payment #security_code").keydown(function(event) {
        // Allow: backspace, delete, tab, escape, and enter
        if ( event.keyCode == 46 || event.keyCode == 8 || event.keyCode == 9 || event.keyCode == 27 || event.keyCode == 13 ||
             // Allow: Ctrl+A
            (event.keyCode == 65 && event.ctrlKey === true) ||
             // Allow: home, end, left, right
            (event.keyCode >= 35 && event.keyCode <= 39)) {
                 // let it happen, don't do anything
                 return;
        }
        else {
            // Ensure that it is a number and stop the keypress
            if (event.shiftKey || (event.keyCode < 48 || event.keyCode > 57) && (event.keyCode < 96 || event.keyCode > 105 )) {
                event.preventDefault();
            }
        }
    });

  $('#payment_amount').bind('change', function() {
  $.ajax({
    url: $('#payment_parcels_number').data('url'),
    type: 'GET',
    data: { amount: $('#payment_amount').val(),
            prefix: $('#payment_parcels_number select').attr('id'),
            minimun: $('#payment_parcels_number').data('minimun-parcel'),
            parcels: $('#payment_parcels_number').data('max-parcels')
          }
    });
  });

});
