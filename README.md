# Open SSH Tunnel

A wercker step to open a ssh tunnel for the next command to make use of it.

Example:

    build:
      steps:
        - petrica/ssh-tunnel:
            source-port: 3306
            destination-port: 3306
            destination-host: 127.0.0.1
            connection-string: me@server
            connection-port: 22
