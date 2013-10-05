$ ->
  $('.promise').click ->
    if $(@).is(':checked')
      $('ul.thumbnails li.wisher').addClass('promised')
    else
      $('ul.thumbnails li.wisher').removeClass('promised')
    $(@).submit()
