#!/bin/bash

if [ -z $WERCKER_SSH_TUNNEL_SOURCE_PORT ]; then
  fail "You must specify a source port to forward"
fi

if [ -z $WERCKER_SSH_TUNNEL_DESTINATION_HOST ]; then
  fail "You must specify a destination host"
fi

if [ -z $WERCKER_SSH_TUNNEL_DESTINATION_PORT ]; then
  fail "You must specify a destination port"
fi

if [ $WERCKER_SSH_TUNNEL_CONNECTION_PORT ]; then
  SSH_PORT="-p $WERCKER_SSH_TUNNEL_CONNECTION_PORT"
fi

SSH_CONNECTION="$WERCKER_SSH_TUNNEL_CONNECTION_STRING $SSH_PORT"
echo "SSH Connection: $SSH_CONNECTION"

SSH_TUNNEL="$WERCKER_SSH_TUNNEL_SOURCE_PORT:$WERCKER_SSH_TUNNEL_DESTINATION_HOST:$WERCKER_SSH_TUNNEL_DESTINATION_PORT"
echo "Opening tunnel with $SSH_TUNNEL"

if  ! ssh -f -o ExitOnForwardFailure=yes -L $SSH_TUNNEL $SSH_CONNECTION sleep 10; then
  fail "\nUnable to connect to host"
fi

echo "\nPort forwarded successfully"