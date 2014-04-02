display_progress = (problems, solved) ->
  progress_html = "<ul class=\"scoreboard-progress\">"
  for problem in problems
    progress_html += """
      <li>
        <a target="_blank" href="/problems#problem-#{problem["pid"]}" class="progress-bullet #{if problem["pid"] in solved then "solved" else "unsolved"}" data-toggle="tooltip" data-placement="bottom" title="#{problem["displayname"]}">#{if problem["pid"] in solved then "O" else "X"}</a>
      </li>"""
  progress_html += "</ul>"


window.load_scoreboards = ->
  $.ajax(type: "GET", cache: false, url: "/api/scoreboards", dataType: "json")
  .done (data) ->
    problems = data["problems"]
    teamscores = data["teamscores"]
    i = 1
    for score in teamscores
      progress_html = display_progress problems, score["solved"]
      $("#scoreboard-table").append """
        <tr>
          <td>#{i}</td>
          <td>#{score["teamname"]}</td>
          <td>#{progress_html}</td>
          <td>#{score["score"]}</td>
        </tr>"""
      i++
    $(".progress-bullet").tooltip()
