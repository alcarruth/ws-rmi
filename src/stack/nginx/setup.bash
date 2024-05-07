#!/bin/bash
#
#  file: /src/stack/nginx/setup.bash
#  package: ws-rmi-examples
#

app_dir = 
app_conf = ws-rmi-example.conf 

function setup(app_conf) {
  sudo cp app_conf /etc/nginx/apps-available
  sudo ln -s ../apps-avialable/${app_conf} /etc/nginx/apps-enabaled/
  sudo chmod root:www-data /etc/nginx/apps-available/${app_conf}
  sudo chmod -h root:www-data /etc/apps-enabled/${app_conf}
}
