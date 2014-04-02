window.show_site_down_error = ->
  $(".contentbox").html "<div class=\"row-fluid\"><div class=\"offset1 span10\"><div class=\"alert\"><button type=\"button\" class=\"close\" data-dismiss=\"alert\">&times;</button>发生了未知错误. 请联系<a href=\"mailto:actf.zju@gmail.com\">actf.zju@gmail.com</a></div></div></div>"
  return

#window.is_zju_text = {'true': '（校内用户）', 'false': '（校外用户）'}
window.scoreboard_text_zju = {'true': '排名（校内）', 'false': '排名（校外）'}

window.set_navbar_zju = (teamname, is_zju_user) ->
  i = 0
  while i < tabsLI.length
    if tabsLI[i][0] == 'account'
      tabsLI[i][1] = teamname
    if tabsLI[i][0] == 'scoreboard'
      tabsLI[i][1] = scoreboard_text_zju[is_zju_user]
    i++

window.build_navbar = (tabs) ->
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

###
window.add_certs_link = ->
  ohtml = $("#navbar")[0].innerHTML
  unless window.location.href.indexOf("certificates") is -1
    ohtml = "<li class=\"ts_selected\" id=\"ts_certificates\"><a href=\"certificates\">Certificates</a></li>" + ohtml
  else
    ohtml = "<li id=\"ts_certificates\"><a href=\"certificates\">Certificates</a></li>" + ohtml
  $("#navbar")[0].innerHTML = ohtml
  return
  
window.check_certs_link_necessary = ->
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
###

window.display_navbar = ->
  unless typeof (Storage) is "undefined"
    if sessionStorage.signInStatus is "loggedIn"
      set_navbar_zju sessionStorage.teamname, sessionStorage.is_zju_user
      build_navbar tabsLI
      # check_certs_link_necessary()
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
        sessionStorage.teamname = data['teamname']
        sessionStorage.is_zju_user = data['is_zju_user']
        set_navbar_zju sessionStorage.teamname, sessionStorage.is_zju_user
        build_navbar tabsLI
        # check_certs_link_necessary()
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
      if data['success']
        set_navbar_zju data['teamname'], data['is_zju_user']
      build_navbar (if data["success"] is 1 then tabsLI else tabsNLI)
      return
    ).fail ->
      build_navbar tabsFail
      show_site_down_error()
      return

  return

window.load_footer = ->
  $.ajax(
    type: "GET"
    cache: false
    url: "deps/footer.html"
  ).done (data) ->
    $("#footer").html data
    return

  return

window.handle_submit = (prob_id) ->
  challenge = Recaptcha.get_challenge()
  response = Recaptcha.get_response()
  console.log(challenge)
  console.log(response)

  $.ajax(
    type: "POST"
    cache: false
    url: "/api/submit"
    dataType: "json"
    data:
      pid: prob_id
      key: $("#" + prob_id).val()
      "recaptcha_challenge": challenge
      "recaptcha_response": reponse
  ).done (data) ->
    prob_msg = $("#msg_" + prob_id)
    alert_class = ""
    if data["status"] is 0
      alert_class = "alert-danger"
    else alert_class = "alert-success"  if data["status"] is 1
    prob_msg.hide().html("<div class=\"alert alert-dismissable " + alert_class + "\"><button type=\"button\" class=\"close\" data-dismiss=\"alert\" aria-hidden=\"true\">&times;</button>" + data["message"] + "</div>").slideDown "normal"
    setTimeout (->
      prob_msg.slideUp "normal", ->
        prob_msg.html("").show()
        window.location.reload()  if data["status"] is 1
        return

      return
    ), 10000
    return

  return false

window.redirect_if_not_logged_in = ->
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

window.tabsLI = [
  [
    "rules"
    "规则"
  ]
  [
    "problems"
    "题目"
  ]
  [
    "scoreboard"
    "排名（校外）"
  ]
  [
    "account"
    "账户信息"
  ]
  [
    "logout"
    "注销"
  ]
]

window.tabsNLI = [
  [
    "rules"
    "规则"
  ]
  [
    "scoreboard"
    "排名（校外）"
  ]
  [
    "registration"
    "注册"
  ]
  [
    "login"
    "登录"
  ]
]

window.tabsFail = [
  [
    "rules"
    "规则"
  ]
  [
    "registration"
    "注册"
  ]
  [
    "login"
    "登录"
  ]
]
