source = new EventSource('/events')

template = _.template "<div class='well'><%=user.screen_name%> : <%=text%></div>"

source.addEventListener 'open', (event) ->
  console.log 'connected'
, false

source.addEventListener 'tweet', (event) ->
  $('#tweets').prepend template jQuery.parseJSON(event.data)
, false
