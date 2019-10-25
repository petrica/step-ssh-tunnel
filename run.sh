#!/bin/bash

if [ -z "$WERCKER_SSH_TUNNEL_SOURCE_PORT" ]; then
  fail "You must specify a source port to forward"
fi

if [ -z "$WERCKER_SSH_TUNNEL_DESTINATION_HOST" ]; then
  WERCKER_SSH_TUNNEL_DESTINATION_HOST="127.0.0.1"
fi

if [ -z "$WERCKER_SSH_TUNNEL_DESTINATION_PORT" ]; then
  WERCKER_SSH_TUNNEL_DESTINATION_PORT="$WERCKER_SSH_TUNNEL_SOURCE_PORT"
fi

if [ "$WERCKER_SSH_TUNNEL_CONNECTION_PORT" ]; then
  SSH_PORT="$WERCKER_SSH_TUNNEL_CONNECTION_PORT"
fi

if [ -z "$WERCKER_SSH_TUNNEL_KEEPALIVE" ]; then
  WERCKER_SSH_TUNNEL_KEEPALIVE="10"
fi

SSH_CONNECTION="$WERCKER_SSH_TUNNEL_CONNECTION_STRING"
echo "SSH Connection: $SSH_CONNECTION $SSH_PORT"

SSH_TUNNEL="$WERCKER_SSH_TUNNEL_SOURCE_PORT:$WERCKER_SSH_TUNNEL_DESTINATION_HOST:$WERCKER_SSH_TUNNEL_DESTINATION_PORT"
info "Opening tunnel with $SSH_TUNNEL"

if [ "${WERCKER_SSH_TUNNEL_FORWARD_ONLY,,}" == "yes" ];then
  if  ! ssh -N -f -o ExitOnForwardFailure=yes -L "$SSH_TUNNEL" "$SSH_CONNECTION" -p  "$SSH_PORT"; then
    fail "Unable to connect to host"
  fi
else
  if  ! ssh -f -o ExitOnForwardFailure=yes -L "$SSH_TUNNEL" "$SSH_CONNECTION" -p "$SSH_PORT" sleep $WERCKER_SSH_TUNNEL_KEEPALIVE; then
    fail "Unable to connect to host"
  fi
fi

success "Port forwarded successfully"
