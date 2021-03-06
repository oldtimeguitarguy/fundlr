express       = require 'express'
session       = require 'express-session'
path          = require 'path'
favicon       = require 'serve-favicon'
logger        = require 'morgan'
cookieParser  = require 'cookie-parser'
bodyParser    = require 'body-parser'
routes        = require './routes'
mongoose      = require 'mongoose'
mongooseTypes = require 'nifty-mongoose-types'
passport      = require 'passport'
app           = express()

mongooseTypes.loadTypes(mongoose);
mongoUri = "mongodb://localhost/fundlr"
mongoose.connect mongoUri
db = mongoose.connection
db.on "error", console.error.bind(console, "connection error:")
db.once "open", callback = ->
  console.log "DB CONNECTION SUCCESSFUL!"
  return

# view engine setup
app.set "views", path.join(__dirname, "views")
app.set "view engine", "jade"

# uncomment after placing your favicon in /public
#app.use(favicon(__dirname + '/public/favicon.ico'));
app.use logger("dev")
app.use bodyParser.json()
app.use bodyParser.urlencoded(extended: false)
app.use cookieParser()
app.use require("stylus").middleware(path.join(__dirname, "public"))
app.use express.static(path.join(__dirname, "public"))
app.use session secret: 'fundlr session secret'
app.use passport.initialize()
app.use passport.session()
routes(app)

# error handlers

# development error handler
# will print stacktrace
if app.get("env") is "development"
  app.use (err, req, res, next) ->
    res.status err.status or 500
    res.render "error",
      message: err.message
      error: err
    return


# production error handler
# no stacktraces leaked to user
app.use (err, req, res, next) ->
  res.status err.status or 500
  res.render "error",
    message: err.message
    error: {}
  return

app.set "port", process.env.PORT or 3000
server = app.listen(app.get("port"), ->
  console.log "Express server listening on port " + server.address().port
  return
)