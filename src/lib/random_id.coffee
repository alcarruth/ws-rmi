# -*- coffee -*-
#
#  file: src/lib/random_id.coffee
#

# returns a randomized id string
random_id = (name) ->
  "#{name}_#{Math.random().toString()[2..]}"

exports.random_id = random_id
