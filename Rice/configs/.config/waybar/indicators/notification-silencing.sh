#!/bin/bash
if [ "$(dunstctl is-paused)" = "true" ]; then
    echo '{"text":"","tooltip":"Notifications silenced"}'
else
    echo '{"text":"","tooltip":"Notifications enabled"}'
fi
