#!/usr/bin/env coffee
#

generate_nginx_conf = (spec) ->

  # required
  name = spec.name
  path = spec.path
  access_log = spec.access_log
  error_log = spec.error_log

  # optional
  host = spec.host || 'localhost'
  port = spec.port || 8080
  auth = spec.auth || { type: null, path: null }

  return """

    location #{path} {

        #{auth.type};
        #{auth.path};

        # mozilla sends a different origin than chrome
        proxy_http_version 1.1;
        proxy_read_timeout 3600s;

        # proxy to port #{port}
        proxy_pass http://#{host}:#{port}/;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";

        proxy_redirect http://#{host}:#{port}/ #{path};
        proxy_set_header X-Forwarded-Host $host:$server_port;
        proxy_set_header X-Forwarded-Server $host;

        access_log #{access_log};
        error_log #{error_log};
    }
"""


spec =
  name: 'web-tix'
  path: '/wss/tickets_coffee'
  access_log: '/var/log/alcarruth/tickets.log'
  error_log: '/var/log/alcarruth/tickets.err'
  host: 'localhost'
  port: 8086
  auth:
    type: 'auth_basic "alcarruth"'
    path: 'auth_basic_user_file /etc/nginx/htpasswd'



if module.parent
  exports.generate_nginx_conf = generate_nginx_conf

else
  conf = generate_nginx_conf(spec)
  console.log conf
