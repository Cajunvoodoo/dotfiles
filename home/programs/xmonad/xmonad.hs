{-# OPTIONS_GHC -threaded #-}
module Main where
import XMonad

import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.StatusBar as SB
import XMonad.Hooks.StatusBar.PP as SBP

import XMonad.Util.EZConfig
import XMonad.Util.Loggers
-- NOTE: Importing XMonad.Util.Ungrab is only necessary for versions
-- < 0.18.0! For 0.18.0 and up, this is already included in the
-- XMonad import and will generate a warning instead!
import XMonad.Util.Ungrab
import XMonad.Util.NamedActions
import XMonad.Util.Run

import XMonad.Layout.Magnifier
import XMonad.Layout.ThreeColumns
import XMonad.Layout.MultiToggle.Instances
import qualified XMonad.Layout.MultiToggle as MT

import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.DynamicLog
import Graphics.X11.ExtraTypes.XF86
import Control.Concurrent (forkIO)
import Control.Monad (void)
import Data.List (stripPrefix)
import Data.Maybe (fromMaybe)
import System.IO


main :: IO ()
main = do
  -- barpipe <- spawnPipe "xmobar-single"
  xmonad
    . ewmhFullscreen
    . ewmh
    -- . withEasySB (statusBarProp "xmobar" (pure myXmobarPP)) defToggleStrutsKey
    . myStatusBar
    . docks
    . addDescrKeys ((mod4Mask, xK_F1), unlines . showKmSimple) myKeybindings
    $ myConfig

myConfig = def
    { modMask    = mod4Mask      -- Rebind Mod to the Super key
    , layoutHook = myLayout      -- Use custom layouts
    , manageHook = myManageHook  -- Match on certain windows
    , focusFollowsMouse = False
    , clickJustFocuses   = False
    , terminal = "kitty"
    , normalBorderColor  = "#dddddd" -- light gray (default)
    , focusedBorderColor = "#1681f2" -- blue
    , startupHook = myStartupHook
    -- , logHook = dynamicLogWithPP $ simplePP barpipe
    }
  `additionalKeysP`
    [ ("M-S-z", spawn "xscreensaver-command -lock")
    , ("M-C-s", unGrab *> spawn "scrot -s"        )
    -- , ("M-f"  , spawn "firefox"                   )
    ]

myStartupHook = do
  spawn "/home/cajun/.xmonad/lib/xmobars.sh"

myStatusBar = SB.withSB $ SB.statusBarPropTo "_XMONAD_LOG_1" "xmobar" (pure simplePP)

myKeybindings conf@XConfig {XMonad.modMask = modm} =
  keySet "Audio"
    [ key "Mute"          (0, xF86XK_AudioMute              ) $ spawn "amixer -q set Master toggle"
    , key "Lower volume"  (0, xF86XK_AudioLowerVolume       ) $ spawn "amixer -q set Master 5%-"
    , key "Raise volume"  (0, xF86XK_AudioRaiseVolume       ) $ spawn "amixer -q set Master 5%+"
    , key "Play / Pause"  (0, xF86XK_AudioPlay              ) $ spawn $ playerctl "play-pause"
    , key "Stop"          (0, xF86XK_AudioStop              ) $ spawn $ playerctl "stop"
    , key "Previous"      (0, xF86XK_AudioPrev              ) $ spawn $ playerctl "previous"
    , key "Next"          (0, xF86XK_AudioNext              ) $ spawn $ playerctl "next"
    , key "Inc Screen"    (0, xF86XK_MonBrightnessUp        ) $ spawn "/run/current-system/sw/bin/brightnessctl -q s +10%"
    , key "Dec Screen"    (0, xF86XK_MonBrightnessDown      ) $ spawn "/run/current-system/sw/bin/brightnessctl -q s 10%-"
    ] ^++^
  keySet "Launchers"
    [ -- key "Terminal"      (modm .|. shiftMask  , xK_Return  ) $ spawn (XMonad.terminal conf)
    -- , key "Lock screen"   (modm .|. controlMask, xK_l       ) $ spawn screenLocker
    ] ^++^
  keySet "Layouts"
    [ key "Next"          (modm              , xK_space     ) $ sendMessage NextLayout
    , key "Reset"         (modm .|. shiftMask, xK_space     ) $ setLayout (XMonad.layoutHook conf)
    , key "Fullscreen"    (modm              , xK_f         ) $ sendMessage (MT.Toggle NBFULL)
    ] ^++^
  keySet "Windows"
    [ key "Close focused"   (modm              , xK_BackSpace) kill
    ]
  where
    keySet s ks = subtitle s : ks
    key n k a = (k, addName n a)
    playerctl c  = "playerctl --player=spotify,%any " <> c

myManageHook :: ManageHook
myManageHook = composeAll
    [ className =? "Gimp" --> doFloat
    , isDialog            --> doFloat
    ]

myLayout = avoidStrutsOn [U] (tiled ||| Mirror tiled ||| Full ||| threeCol)
  where
    threeCol = magnifiercz' 1.3 $ ThreeColMid nmaster delta ratio
    tiled    = Tall nmaster delta ratio
    nmaster  = 1      -- Default number of windows in the master pane
    ratio    = 1/2    -- Default proportion of screen occupied by master pane
    delta    = 3/100  -- Percent of screen to increment by when resizing panes

myXmobarPP :: PP
myXmobarPP = def
    { ppSep             = magenta " • "
    , ppTitleSanitize   = xmobarStrip
    , ppCurrent         = wrap " " "" . xmobarBorder "Top" "#8be9fd" 2
    , ppHidden          = white . wrap " " ""
    , ppHiddenNoWindows = lowWhite . wrap " " ""
    , ppUrgent          = red . wrap (yellow "!") (yellow "!")
    , ppOrder           = \[ws, l, _, wins] -> [ws, l, wins]
    , ppExtras          = [logTitles formatFocused formatUnfocused]
    }
  where
    formatFocused   = wrap (white    "[") (white    "]") . magenta . ppWindow
    formatUnfocused = wrap (lowWhite "[") (lowWhite "]") . blue    . ppWindow

    -- | Windows should have *some* title, which should not not exceed a
    -- sane length.
    ppWindow :: String -> String
    ppWindow = xmobarRaw . (\w -> if null w then "untitled" else w) . shorten 30

    blue, lowWhite, magenta, red, white, yellow :: String -> String
    magenta  = xmobarColor "#ff79c6" ""
    blue     = xmobarColor "#bd93f9" ""
    white    = xmobarColor "#f8f8f2" ""
    yellow   = xmobarColor "#f1fa8c" ""
    red      = xmobarColor "#ff5555" ""
    lowWhite = xmobarColor "#bbbbbb" ""

-- simplePP :: PP
simplePP = SBP.def { SBP.ppLayout = const ""
                   , SBP.ppHidden = const ""
                   , SBP.ppCurrent = SBP.xmobarColor "gray40" ""
                   , SBP.ppTitle = ellipsis 35 . stripOrg
                   , SBP.ppSep = ":"
                   , SBP.ppUrgent = const (SBP.xmobarColor "orangered3" "" "*")
                   -- , SBP.ppOutput = hPutStrLn barpipe
                   }
  where ellipsis n s | length s > n = take (n - 3) s ++ " ..."
                     | otherwise = s
        stripOrg s = fromMaybe s (stripPrefix "~/org/doc/" s)
