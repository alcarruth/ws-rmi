# name: logger.js
# version: 0.0.1
# http:#github.com/quirkey/node-logger

{ normalize } = require('path')
fs   = require('fs')

class Logger

  @levels = ['fatal', 'error', 'warn', 'info', 'debug']

  constructor: (log_path = null) ->
    if log_path
      options = { flags: 'a', encoding: 'utf8', mode: 0666 }
      @stream = fs.createWriteStream( normalize(log_path), options)
      @stream.write("\n")
    else
      @stream = console._stdout
      @set_level('info')

  write: (text) =>
    @stream.write(text)

  format: (level, date, message) =>
    "#{level} [#{date}] #{message}"

  # Set the maximum log level. The default level is "info".
  set_level: (level) =>
    i = @levels.indexOf(level)
    if i >= 0
      @log_level_index = i

  log: (args...) =>

    if args[0] in @levels
      log_index = @levels.indexOf(args[0])
      args.shift()
    else
      log_index = @log_level_index

    if log_index <= @log_level_index
      msg = ''
      for arg in args
        if typeof(arg) != 'string'
          arg = util.inspect(arg, false, null)
        msg += arg
      msg = @format(@levels[log_index], new Date(), msg)
      @write(msg + "\n")
      return msg

    return false



exports.Logger = Logger
