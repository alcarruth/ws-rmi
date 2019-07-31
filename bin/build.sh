#!/bin/sh

rm -rf ./example/ ./lib/
mkdir -p ./example/ ./lib/

cp src/example/*.coffee ./example/
cp src/lib/*.coffee ./lib/
