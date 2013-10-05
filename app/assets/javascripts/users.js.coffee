$ ->
  state_update = (elem, model) ->
    select_wrapper = $('.state_code_wrapper')
    $('select', select_wrapper).attr('disabled', true)
    country_code = $(elem).val()
    url = "/addresses/subregion_options?parent_region=#{country_code}&model=#{model}&locale=#{locale}"
    select_wrapper.load(url)

  $('select#gift_address_attributes_country_code').change ->
    state_update(@, 'gift')

  $('select#user_address_attributes_country_code').change ->
    state_update(@, 'user')

  if $('select#gift_address_attributes_country_code').length > 0
    unless $('select#gift_state_code').length > 0
      state_update('select#gift_address_attributes_country_code', 'gift')

  if $('select#user_address_attributes_country_code').length > 0
    unless $('select#user_state_code').length > 0
      state_update('select#user_address_attributes_country_code', 'user')

  $('#first_visit').click ->
    $.cookie('first_visit', true)
