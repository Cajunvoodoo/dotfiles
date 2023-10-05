Config { font = "Roboto Bold 10"
       , additionalFonts =
          [ "FontAwesome 12"
          , "FontAwesome Bold 8"
          , "FontAwesome 14"
          , "Hack 19"
          , "Hack 14"
          ]
       , border = NoBorder
       , bgColor = "#2B2E37"
       , fgColor = "#929AAD"
       , alpha = 255
       , position = TopSize L 100 40
       -- , textOffset = 24
       -- , textOffsets = [ 25, 24 ]
       , lowerOnStart = True
       , allDesktops = True
       , persistent = False
       , hideOnStart = False
       , iconRoot = "/home/cajun/dotfiles/home/programs/xmobar/icons/"
       , commands =
         [ Run UnsafeXPropertyLog "_XMONAD_LOG_0"
         , Run Date "%a, %d %b   <fn=5>󰥔</fn>     %H:%M:%S" "date" 10
         , Run Memory ["-t","Mem: <fc=#AAC0F0><usedratio></fc>%"] 10
         , Run Com "/home/cajun/dotfiles/home/programs/xmobar/cpu_temp.sh" [] "cpu" 10
         , Run Com "/home/cajun/dotfiles/home/programs/xmobar/gpu_temp.sh" [] "gpu" 10
         , Run Com "/home/cajun/dotfiles/home/programs/xmobar/volume.sh" [] "volume" 10
         , Run Com "/home/cajun/dotfiles/home/programs/xmobar/bluetooth.sh" [] "bluetooth" 10
         , Run Com "/home/cajun/dotfiles/home/programs/xmobar/wifi.sh" [] "network" 10
         ]
       , sepChar = "%"
       , alignSep = "}{"
       , template = "\
            \    \
            \%_XMONAD_LOG_0%\
            \}\
            \<action=xdotool key super+r>%date%</action>\
            \{\
            \<action=xdotool key super+y>\
            \     \
            \%memory%\
            \     \
            \|\
            \     \
            \%cpu%\
            \     \
            \|\
            \     \
            \%gpu%\
            \       \
            \</action>"
       }
