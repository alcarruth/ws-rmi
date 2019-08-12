#!/usr/bin/env node

require('coffeescript/register')

lib = require('./src/lib/index')

exports.Connection = lib.Connection
exports.Object = lib.Object
exports.Stub = lib.Stub

exports.Server = lib.Server
exports.Client = lib.Client
