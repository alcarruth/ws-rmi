cp ../lib/ws_rmi_client.coffee web_client.coffee
cat stack.coffee settings.coffee client.coffee >> web_client.coffee

coffee -c web_client.coffee
