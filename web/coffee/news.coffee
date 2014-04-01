window.load_news = ->
  $.ajax(type: "GET", cache: false, url: "/api/news")
  .done (data) ->
      html = ''
#      months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December']
#      months = ['一月', '二月', '三月', '四月', '五月', '六月', '七月', '八月', '九月', '十月', '十一月', '十二月']
      for d in data
        html += "<li>"
        try
          raw_date_string = d['date'];
          date_string = raw_date_string.split(" ")[0]
          date = new Date(Date.parse(date_string))
          day = date.getDate()
          month = date.getMonth()
          year = date.getFullYear()
          hourminute = raw_date_string.split(" ")[1]
          html += "<time class=\"cbp_tmtime\" datetime=\"#{raw_date_string}\"><span>#{year}年</span><span>#{if month < 10 then '0' else ''}#{month}月#{if day < 10 then '0' else ''}#{day}日</span><span>#{hourminute}</span></time>"
        html += "<div class=\"cbp_tmlabel\">";
        html += "<h3>#{d['header']}</h3>"
        html += "<p>" + d['articlehtml'] + "</p>"
        html += "</div>";
        html += "</li>"
      $("#news_holder").html html
