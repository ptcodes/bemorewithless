$ ->
  cookie = $.cookie('lang')
  if cookie == 'es'
    locale = 'es-ES'
  else
    locale = ''

  $('#gift_description').wysihtml5({locale: locale, link: false, image: false})
  $('#user_profile').wysihtml5({locale: locale, link: false, image: false})

