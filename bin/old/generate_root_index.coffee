#!/usr/bin/env coffee
#
# file: /src/generate_root_index.coffee
# package: wss-nginx
# 

fs = require('fs')
{ pkg_name, pkg_src, pkg_branch } = require('./pkg_info.json')

generate_root_index = -> """
#!/usr/bin/env coffee
#
# file: /src/root_index.coffee
# package: #{pkg_name}
#
module.exports = require("./#{pkg_branch}")
"""

fs.writeFileSync("#{pkg_src}/root_index.coffee", generate_root_index())
