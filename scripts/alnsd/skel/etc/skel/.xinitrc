#!/bin/bash

export DE=openbox

# Dbus fix
if [ -z "$DBUS_SESSION_BUS_ADDRESS" ]; then
    eval "$(dbus-launch --sh-syntax --exit-with-session)"
fi

/usr/bin/xdg-user-dirs-update

exec ck-launch-session dbus-launch --sh-syntax --exit-with-session openbox-session

