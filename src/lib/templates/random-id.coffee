# -*- coffee -*-
#
#  file: src/lib/random-id.coffee
#  package: armazilla-util
#

# returns a randomized id string
random_id = (obj, name) ->
  name = name || obj.constructor.name
  "#{name}_#{Math.random().toString()[2..]}"

{% if separate_modules %}
exports.random_id = random_id
