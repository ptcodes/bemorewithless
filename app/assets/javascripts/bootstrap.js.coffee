jQuery ->
  $("a[rel=popover]").popover()
  $(".tooltip").tooltip()
  $("a[rel=tooltip]").tooltip()

  # Anchors in the links didn't work as expected
  hash = window.location.hash
  hash and $("ul.nav a[href=\"" + hash + "\"]").tab("show")
  $(".nav-tabs a").click (e) ->
    $(this).tab "show"
    window.location.hash = @hash

