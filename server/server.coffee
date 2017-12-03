# signature plugin, server-side component
# These handlers are launched with the wiki server. 

newkey = () -> Math.floor(Math.random()*1000000).toString()

startServer = (params) ->
  app = params.app
  argv = params.argv
  keys = {public: newkey(), private: newkey()}

  app.get '/plugin/signature/key', (req, res) ->
    console.log 'keys', keys
    res.json {public: keys.public, algo:'trivial'}

  app.get '/plugin/signature/:thing', (req, res) ->
    thing = req.params.thing
    res.json {thing}

module.exports = {startServer}
