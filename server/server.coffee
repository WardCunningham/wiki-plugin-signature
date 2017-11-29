# signature plugin, server-side component
# These handlers are launched with the wiki server. 

startServer = (params) ->
  app = params.app
  argv = params.argv

  app.get '/plugin/signature/:thing', (req, res) ->
    thing = req.params.thing
    res.json {thing}

module.exports = {startServer}
