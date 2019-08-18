#!/usr/bin/env node
// file: index.js
// package: ws-rmi

lib = require('./lib/index')

exports.Connection = lib.Connection
exports.Object = lib.Object
exports.Stub = lib.Stub

exports.Server = lib.Server
exports.Client = lib.Client
