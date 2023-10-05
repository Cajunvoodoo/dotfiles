#!/bin/bash
MUTE=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print $3}')
VOLUME=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print $2}')

if [ "$MUTE" = "[MUTED]" ]; then
    echo "<fc=#696B71><fn=3></fn></fc> "
elif [ "$VOLUME" -eq 0 ]; then
    echo "<fc=#696B71><fn=3></fn></fc>   "
elif [ "$VOLUME" -lt 77 ]; then
    echo "<fc=#DFDFDF><fn=3></fn></fc>  "
else
    echo "<fc=#DFDFDF><fn=3></fn></fc>"
fi
