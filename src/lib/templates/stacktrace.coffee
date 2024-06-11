#!/usr/bin/env coffee
#
#  file: /src/lib/stacktrace.coffee
#  package: armazilla-util
#

stacktrace = require('stacktrace-js')

if window?
  window.stacktrace = stacktrace
else
  module.exports = stacktrace

