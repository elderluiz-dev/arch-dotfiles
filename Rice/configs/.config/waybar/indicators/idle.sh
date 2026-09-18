#!/bin/bash
if [ "$(xset q | grep -c "DPMS is Enabled")" -eq 1 ]; then
    echo '{"text":"","tooltip":"Idle enabled"}'
else
    echo '{"text":"","tooltip":"Idle disabled"}'
fi
