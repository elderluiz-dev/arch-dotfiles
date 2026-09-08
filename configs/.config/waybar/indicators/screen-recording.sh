#!/bin/bash
if pgrep -x "wf-recorder" > /dev/null; then
    echo '{"text":"","class":"active","tooltip":"Recording"}'
else
    echo '{"text":"","tooltip":"Not recording"}'
fi
