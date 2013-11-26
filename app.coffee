jsyaml     = require 'js-yaml'
express    = require 'express'
http       = require 'http'
stylus     = require 'stylus'
browserify = require 'browserify-express'
assets     = require 'connect-assets'
load       = require 'express-load'
nib        = require 'nib'

module.exports = app = express()

app.set 'port', process.env.PORT or 3000
app.set 'views', "#{__dirname}/views"
app.set 'view engine', 'jade'
app.use express.favicon()
app.use express.logger 'dev'
app.use express.bodyParser()
app.use express.methodOverride()
app.use app.router

# setup javascript middleware
app.use browserify
  entry: "#{__dirname}/assets/js/app/main.coffee"
  watch: "#{__dirname}/assets/js"
  mount: '/js/app.js'

# setup css middleware
app.use stylus.middleware
  src: "#{__dirname}/assets/css/"
  dest: "#{__dirname}/public/css/"
  force: app.get('env') is 'development'
  compile: (str, path) ->
    stylus(str).set('filename', path).use(nib());

app.use express.static "#{__dirname}/assets"
app.use express.static "#{__dirname}/public"

if 'development' is app.get('env')
  app.use express.errorHandler()

load('locals', extlist:['.yml']).into(app)
load('routes').into(app)

console.log app.locals

http.createServer(app).listen app.get('port'), ->
  console.log 'Express server listening on port ' + app.get('port')

