$('form.new_comment').submit ->
  false unless $(@).find('#comment_content').val().length

  $(".alert").delay(500).fadeIn "normal", ->
    $(@).delay(2500).fadeOut()

  #$('.alert').delay 500, ->
    #$(@).animate {
      #opacity: 0
      #height: 0
    #}, "slow", ->
      #$(@).hide()
