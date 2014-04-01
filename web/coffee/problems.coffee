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
                <a data-toggle="collapse" data-parent="#problems-accordion" href="#problem-#{id}">
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
                <div id=msg_#{id}></div>
                <form onsubmit="handle_submit('#{id}'); return false;" class="form-inline" id="form_#{id}">
                  <input id="#{id}" type="text" class="form-control">
                  <button class="btn btn-primary" type="submit">提交!</button>
                </form>
              </div>
            </div>
          </div>"""
        $("#problem-#{id}").collapse
