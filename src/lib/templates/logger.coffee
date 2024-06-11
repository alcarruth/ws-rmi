# -*- coffee -*-
#
#  file: /src/lib/logger.coffee
#  package: armazilla-util
#

{% if separate_modules %}
if window?
  inspect = (x, options) ->
    return x
else
  { inspect } = require('util')

stacktrace = require('./stacktrace')
{% endif %}

class Logger

  constructor: ({ obj, options, threshold }) ->
    @owner_id = obj?.id || null
    @options =
      colors: options?.colors || true
      depth: options?.depth || null
    @threshold = if threshold? then threshold else 2

  _log: (xs, type='') =>
    function_name = (await stacktrace.get())[2].functionName
    console.log("\n#{type}#{function_name}():")
    for x in xs
      console.log(inspect(x, @options))
    return undefined

  log_level: (level, xs...) =>
    if level >= @threshold
      @log(xs...)

  log: (xs...) =>
    @_log(xs)

  info: (xs...) =>
    @_log(xs, 'INFO: ')

  warn: (xs...) =>
    @_log(xs, 'WARNING: ')

  error: (xs...) =>
    @log(xs, 'ERROR: ')


{% if separate_modules %}
exports.Logger = Logger
{% endif %}
