jQuery ->
  Stripe.setPublishableKey($('meta[name="stripe-key"]').attr('content'))
  purchase.setupPurchaseForm()
  subscription.setupSubscriptionForm()

  if $('#stripe_card_id_').is(':checked')
    $("#creditCardInputs").slideToggle();

  $(':radio').click ->
    if $('#existing_card_id_').is(':checked')
      $("#creditCardInputs").slideDown();
    else
      $("#creditCardInputs").slideUp();
    if $('#stripe_card_id_').is(':checked')
      $("#creditCardInputs").slideDown();
    else
      $("#creditCardInputs").slideUp();

  

subscription =
  setupSubscriptionForm: ->
    $("#price").text()
    $(':radio').click ->
      $('input[type=submit]').attr('disabled', false)
      if $('#existing_card_id_').is(':checked')
        $('#new_subscription').submit ->
          $('input[type=submit]').attr('disabled', true)
          if $('#card_number').length
            subscription.processSubscriptionCard()
            false
          else
            true
      else
        $('#new_subscription').submit ->
          $('#new_subscription').submit();
  
  processSubscriptionCard: ->
    card =
      number: $('#card_number').val()
      cvc: $('#card_code').val()
      expMonth: $('#card_month').val()
      expYear: $('#card_year').val()
    Stripe.createToken(card, subscription.handleSubscriptionResponse)
  
  handleSubscriptionResponse: (status, response) ->
    if status == 200
      $('#stripe_card_id').val(response.id)
      $('#new_subscription')[0].submit()
    else
      $('#stripe_error').text(response.error.message).fadeIn();

      $('input[type=submit]').attr('disabled', false)

purchase =
  setupPurchaseForm: ->
    $(':radio').click ->
      $('input[type=submit]').attr('disabled', false)
      if $('#stripe_card_id_').is(':checked')
        $('#new_purchase').submit ->
          $('input[type=submit]').attr('disabled', true)
          if $('#card_number').val().length == 16
            purchase.processPurchaseCard()
            false
          else
            true
      else
        $('#new_purchase').submit ->
          $('#stripe_card_id').val($(':radio:checked').val());
          $('#new_purchase').submit();

  processPurchaseCard: ->
    card =
      number: $('#card_number').val()
      cvc: $('#card_code').val()
      expMonth: $('#card_month').val()
      expYear: $('#card_year').val()
    Stripe.createToken(card, purchase.handlePurchaseResponse)
  
  handlePurchaseResponse: (status, response) ->
    if status == 200
      $('#stripe_card_id').val(response.id);
      $('#new_purchase')[0].submit();
    else
      $('#stripe_error').text(response.error.message).fadeIn();
      $('input[type=submit]').attr('disabled', false)
