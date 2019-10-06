#!/usr/bin/env coffee
#
# 

defalt_config = {
   appspace        : 'app.',
   socketRoot      : '/tmp/',
   id              : os.hostname(),
   networkHost     : 'localhost',
   networkPort     : 8000,
   encoding        : 'utf8',
   rawBuffer       : false,
   sync            : false,
   silent          : false,
   logInColor      : true,
   logDepth        : 5,
   logger          : console.log,
   maxConnections  : 100,
   retry           : 500,
   maxRetries      : false,
   stopRetrying    : false,
   unlink          : true,
   interfaces      : {
     localAddress: false,
     localPort   : false,
     family      : false,
     hints       : false,
     lookup      : false
  }
}

config = {
   appspace        : 'scratch.',
   socketRoot      : '/tmp/',
   id              : os.hostname(),
}

exports.config = config
