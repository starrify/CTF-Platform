window.load_problems = ->
  $.ajax(type: "GET", cache: false, url: "/api/problems", dataType: "json")
    .done (data) ->
      categories = ['WEB', 'EXPLOIT', 'REVERSE', 'CRYPTO', 'MISC']
      label_names = ['primary', 'success', 'info', 'warning', 'danger']
      for d in data
        id = d['pid']
        for i in [0..4]
          if categories[i] == d['category']
            label_name = label_names[i]
            break

        $("#problems-accordion").append """
          <div class="panel panel-default">
            <div class="panel-heading">
              <h4 class="panel-title">
                <a data-toggle="collapse" data-parent="#problems-accordion" href="#problem-#{id}" class="problem-title">
                  #{if d['correct'] then '<span class="solved">[已解决]</span>' else '<span class="unsolved">[未解决]</span>'}
                  #{d['displayname']}
                  <div class="pull-right">
                    <span class="label label-default">#{d['basescore']}</span>
                    <span class="label label-#{label_name}">#{d['category']}</span>
                  </div>
                </a>
              </h4>
            </div>
            <div id="problem-#{id}" class="panel-collapse collapse">
              <div class="panel-body">
                #{d['desc']}
                <hr>
                <div class="flag-panel">
                  <div id=msg_#{id}></div>
                  <form onsubmit="handle_submit('#{id}'); return false;" class="flag-form" id="form_#{id}">
                      <div class="recaptcha-container" id="recaptcha-#{id}"></div>
                      <input id="#{id}" type="text" class="form-control flag-input" placeholder="FLAG">
                      <button class="btn btn-primary pull-right" type="submit">提交!</button>
                  </form>
                </div>
              </div>
            </div>
          </div>"""
        $("#problem-#{id}").on "show.bs.collapse", ()->
          $(this).find(".recaptcha-container").hide().show(500)
          rid = $(this).find(".recaptcha-container").attr("id")
          $(".recaptcha-container").empty()
          $(this).find(".recaptcha-container").html """
            <div onClick="javascript:Recaptcha.reload()" title="点击图片以切换验证码" id="recaptcha_image" data-toggle="tooltip" data-placement="bottom"></div>
            <input type="text" id="recaptcha_response_field" name="recaptcha_response_field" class="form-control" placeholder="CAPTCHA" />
            """
          $("#recaptcha_image").tooltip()
          Recaptcha.destroy()
          Recaptcha.create(
            "6LcPFPESAAAAALdVWq62jvJ3HEEBvkcOfUOSZ9PV",
            rid,
            {
              theme: "custom",
              custom_theme_widget: "#{rid}"
#              callback: Recaptcha.focus_response_field
            }
          )
      $(window.location.hash).collapse("show");
