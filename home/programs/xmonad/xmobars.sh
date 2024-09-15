#!/bin/sh

killall trayer

alpha=255

xsetroot -cursor_name left_ptr

# trayer --margin 2 --distancefrom left \
#        --distance 1 --edge top \
#        --align left --SetDockType true --SetPartialStrut false \
#        --widthtype request \
#        --height 21 --heighttype pixel \
#        --transparent true \
#        --alpha $alpha --padding 1 &

killall xmobar-single
xmobar-single $* &
