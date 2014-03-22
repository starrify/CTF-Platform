show_site_down_error = ->
  $(".contentbox").html "<div class=\"row-fluid\"><div class=\"offset1 span10\"><div class=\"alert\"><button type=\"button\" class=\"close\" data-dismiss=\"alert\">&times;</button>An error occured. picoCTF may be down. Please contact use at <a href=\"mailto:support@picoctf.com\">support@picoctf.com</a></div></div></div>"
  return
build_navbar = (tabs) ->
  ohtml = ""
  i = 0

  while i < tabs.length
    unless window.location.href.indexOf(tabs[i][0]) is -1
      ohtml += "<li class=\"ts_selected\" id=\"ts_" + tabs[i][0] + "\"><a href=\"" + tabs[i][0] + "\">" + tabs[i][1] + "</a></li>"
    else
      ohtml += "<li id=\"ts_" + tabs[i][0] + "\"><a href=\"" + tabs[i][0] + "\">" + tabs[i][1] + "</a></li>"
    i++
  $("#navbar")[0].innerHTML = ohtml
  return
add_certs_link = ->
  ohtml = $("#navbar")[0].innerHTML
  unless window.location.href.indexOf("certificates") is -1
    ohtml = "<li class=\"ts_selected\" id=\"ts_certificates\"><a href=\"certificates\">Certificates</a></li>" + ohtml
  else
    ohtml = "<li id=\"ts_certificates\"><a href=\"certificates\">Certificates</a></li>" + ohtml
  $("#navbar")[0].innerHTML = ohtml
  return
check_certs_link_necessary = ->
  unless typeof (Storage) is "undefined"
    if sessionStorage.showCertsLink is "true"
      add_certs_link()
    else
      $.ajax(
        type: "GET"
        url: "/api/getlevelcompleted"
        cache: false
      ).done((data) ->
        if data["success"] is 1 and data["level"] > 0
          sessionStorage.showCertsLink = "true"
          add_certs_link()
        else
          sessionStorage.showCertsLink = "false"
        return
      ).fail (data) ->
        sessionStorage.showCertsLink = "false"
        return

  else
    $.ajax(
      type: "GET"
      url: "/api/getlevelcompleted"
      cache: false
    ).done (data) ->
      add_certs_link()  if data["success"] is 1 and data["level"] > 0
      return

  return
display_navbar = ->
  unless typeof (Storage) is "undefined"
    if sessionStorage.signInStatus is "loggedIn"
      build_navbar tabsLI
      check_certs_link_necessary()
    else if sessionStorage.signInStatus is "notLoggedIn"
      build_navbar tabsNLI
    else if sessionStorage.signInStatus is "apiFail"
      build_navbar tabsFail
    else
      build_navbar tabsNLI
    $.ajax(
      type: "GET"
      url: "/api/isloggedin"
      cache: false
    ).done((data) ->
      if data["success"] is 1 and sessionStorage.signInStatus isnt "loggedIn"
        sessionStorage.signInStatus = "loggedIn"
        build_navbar tabsLI
        check_certs_link_necessary()
      else if data["success"] is 0 and sessionStorage.signInStatus isnt "notLoggedIn"
        sessionStorage.signInStatus = "notLoggedIn"
        build_navbar tabsNLI
      return
    ).fail ->
      unless sessionStorage.signInStatus is "apiFail"
        sessionStorage.signInStatus = "apiFail"
        build_navbar tabsFail
        show_site_down_error()
      return

  else
    $.ajax(
      type: "GET"
      url: "/api/isloggedin"
      cache: false
    ).done((data) ->
      build_navbar (if data["success"] is 1 then tabsLI else tabsNLI)
      return
    ).fail ->
      build_navbar tabsFail
      show_site_down_error()
      return

  return
load_footer = ->
  $.ajax(
    type: "GET"
    cache: false
    url: "deps/footer.html"
  ).done (data) ->
    $("#footer").html data
    return

  return
handle_submit = (prob_id) ->
  $.ajax(
    type: "POST"
    cache: false
    url: "/api/submit"
    dataType: "json"
    data:
      pid: prob_id
      key: $("#" + prob_id).val()
  ).done (data) ->
    prob_msg = $("#msg_" + prob_id)
    alert_class = ""
    if data["status"] is 0
      alert_class = "alert-error"
    else alert_class = "alert-success"  if data["status"] is 1
    prob_msg.hide().html("<div class=\"alert " + alert_class + "\">" + data["message"] + "</div>").slideDown "normal"
    setTimeout (->
      prob_msg.slideUp "normal", ->
        prob_msg.html("").show()
        window.location.reload()  if data["status"] is 1
        return

      return
    ), 2500
    return

  return
redirect_if_not_logged_in = ->
  $.ajax(
    type: "GET"
    url: "/api/isloggedin"
    cache: false
  ).done((data) ->
    window.location.href = "/login"  if data["success"] is 0
    return
  ).fail ->
    window.location.href = "/"
    return

  return
tabsLI = [
  [
    "compete"
    "Game"
  ]
  [
    "irc"
    "chat"
  ]
  [
    "webshell"
    "Shell"
  ]
  [
    "scoreboard"
    "Scoreboard"
  ]
  [
    "news"
    "News"
  ]
  [
    "learn"
    "Learn"
  ]
  [
    "faq"
    "FAQ"
  ]
  [
    "account"
    "Account"
  ]
  [
    "logout"
    "Logout"
  ]
]
tabsNLI = [
  [
    "about"
    "About"
  ]
  [
    "scoreboard"
    "Scoreboard"
  ]
  [
    "faq"
    "FAQ"
  ]
  [
    "registration"
    "Registration"
  ]
  [
    "news"
    "News"
  ]
  [
    "learn"
    "Learn"
  ]
  [
    "contact"
    "Contact"
  ]
  [
    "login"
    "Login"
  ]
]
tabsFail = [
  [
    "about"
    "About"
  ]
  [
    "faq"
    "FAQ"
  ]
  [
    "learn"
    "Learn"
  ]
  [
    "contact"
    "Contact"
  ]
]
