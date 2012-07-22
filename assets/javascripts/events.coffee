source = new EventSource('/events')

template = _.template "<li><%=user.screen_name%> : <%=text%></li>"

source.addEventListener 'open', (event) ->
  console.log 'connected'
, false

source.addEventListener 'tweet', (event) ->
  $('#tweets').prepend template jQuery.parseJSON(event.data)
, false
