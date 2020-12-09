--
-- xmonad example config file for xmonad-0.9
--
-- A template showing all available configuration hooks,
-- and how to override the defaults in your own xmonad.hs conf file.
--
-- Normally, you'd only override those defaults you care about.
--
-- NOTE: Those updating from earlier xmonad versions, who use
-- EwmhDesktops, safeSpawn, WindowGo, or the simple-status-bar
-- setup functions (dzen, xmobar) probably need to change
-- xmonad.hs, please see the notes below, or the following
-- link for more details:
--
-- http://www.haskell.org/haskellwiki/Xmonad/Notable_changes_since_0.8
--

-- TODO
-- - Volume
-- - Brightness

import qualified Codec.Binary.UTF8.String       as UTF8
import qualified Data.Map                       as M
import           Data.Monoid
import qualified DBus                           as D
import qualified DBus.Client                    as D
import           Graphics.X11.ExtraTypes.XF86
import           System.Exit
import           System.IO
import           XMonad
import           XMonad.Actions.FloatKeys
import           XMonad.Actions.FloatSnap
import           XMonad.Actions.GroupNavigation
import           XMonad.Actions.Navigation2D
import           XMonad.Actions.SpawnOn
import           XMonad.Actions.Submap
import           XMonad.Hooks.DynamicLog
import           XMonad.Hooks.EwmhDesktops
import           XMonad.Hooks.ManageDocks
import           XMonad.Hooks.ManageHelpers
import           XMonad.Hooks.Place
import qualified XMonad.Layout.BoringWindows    as B
import           XMonad.Layout.Grid
import           XMonad.Layout.LayoutModifier
import           XMonad.Layout.Minimize
import           XMonad.Layout.NoBorders
import           XMonad.Layout.Renamed
import           XMonad.Layout.Spacing
import           XMonad.Layout.ThreeColumns
import qualified XMonad.StackSet                as W
import           XMonad.Util.EZConfig           (additionalKeys,
                                                 additionalKeysP)
import           XMonad.Util.Run                (spawnPipe)
import           XMonad.Util.SpawnOnce

-- The preferred terminal program, which is used in a binding below and by
-- certain contrib modules.
--

fg        = "#C4C7C5"
bg        = "#212B30"
gray      = "#a89984"
bg1       = "#3c3836"
bg2       = "#5C6F7B"
ac        = "#4DD0E1"

green     = "#b8bb26"
darkgreen = "#98971a"
red       = "#EC7875"
darkred   = "#cc241d"
yellow    = "#fabd2f"
blue      = "#83a598"
purple    = "#d3869b"
aqua      = "#8ec07c"

myTerminal      = "kitty"

-- Whether focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

-- Width of the window border in pixels.
--
myBorderWidth   = 2

-- modMask lets you specify which modkey you want to use. The default
-- is mod1Mask ("left alt").  You may also consider using mod3Mask
-- ("right alt"), which does not conflict with emacs keybindings. The
-- "windows key" is usually mod4Mask.
--
myModMask       = mod4Mask

-- NOTE: from 0.9.1 on numlock mask is set automatically. The numlockMask
-- setting should be removed from configs.
--
-- You can safely remove this even on earlier xmonad versions unless you
-- need to set it to something other than the default mod2Mask, (e.g. OSX).
--
-- The mask for the numlock key. Numlock status is "masked" from the
-- current modifier status, so the keybindings will work with numlock on or
-- off. You may need to change this on some systems.
--
-- You can find the numlock modifier by running "xmodmap" and looking for a
-- modifier with Num_Lock bound to it:
--
-- > $ xmodmap | grep Num
-- > mod2        Num_Lock (0x4d)
--
-- Set numlockMask = 0 if you don't have a numlock key, or want to treat
-- numlock status separately.
--
-- myNumlockMask   = mod2Mask -- deprecated in xmonad-0.9.1
------------------------------------------------------------


-- The default number of workspaces (virtual screens) and their names.
-- By default we use numeric strings, but any string may be used as a
-- workspace name. The number of workspaces is determined by the length
-- of this list.
--
-- A tagging example:
--
-- > workspaces = ["web", "irc", "code" ] ++ map show [4..9]
--
myWorkspaces =
    [ "1•\62601"
    , "2•\62057"
    , "3•\63213"
    , "4•\64366"
    , "5•\61820"
    , "6•\61820"
    , "7•\61820"
    , "8•\63942"
    , "9•\63608"]

-- Border colors for unfocused and focused windows, respectively.
--
myNormalBorderColor  = "#212B30"
myFocusedBorderColor = "#5C6F7B"

------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
--
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $

    -- launch a terminal
    [ ((modm .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf)

    -- launch dmenu
    --, ((modm,               xK_p     ), spawn "~/.config/rofi/bin/launcher_colorful")
    , ((modm,               xK_p     ), spawn "~/.xmonad/confs/rofi/launchers/misc/launcher.sh")

    -- launch command runner
    , ((modm,               xK_r     ), spawn "~/.xmonad/confs/rofi/launchers/text/launcher.sh")

    -- launch 1password
    , ((modm .|. shiftMask, xK_p     ), spawn "~/.xmonad/confs/rofi/powermenu/powermenu.sh")

    -- close focused window
    , ((modm .|. shiftMask, xK_c     ), kill)

     -- Rotate through the available layout algorithms
    , ((modm,               xK_space ), sendMessage NextLayout)

    --  Reset the layouts on the current workspace to default
    , ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)

    -- Resize viewed windows to the correct size
    , ((modm,               xK_n     ), refresh)

    -- Move focus to the next window
    , ((modm,               xK_Tab   ), windows W.focusDown)

    -- Move focus to the next window
    , ((modm,               xK_j     ), windows W.focusDown)

    -- Move focus to the previous window
    , ((modm,               xK_k     ), windows W.focusUp  )

    -- Move focus to the master window
    , ((modm,               xK_m     ), windows W.focusMaster  )

    -- Swap the focused window and the master window
    , ((modm,               xK_Return), windows W.swapMaster)

    -- Swap the focused window with the next window
    , ((modm .|. shiftMask, xK_j     ), windows W.swapDown  )

    -- Swap the focused window with the previous window
    , ((modm .|. shiftMask, xK_k     ), windows W.swapUp    )

    -- Shrink the master area
    , ((modm,               xK_h     ), sendMessage Shrink)

    -- Expand the master area
    , ((modm,               xK_l     ), sendMessage Expand)

    -- Push window back into tiling
    , ((modm,               xK_t     ), withFocused $ windows . W.sink)

    -- Increase window spacing
    , ((modm,               xK_g     ), setSpacing(0))

    -- Decrease window spacing
    , ((modm .|. shiftMask, xK_g     ), setSpacing(10))

    -- Increment the number of windows in the master area
    , ((modm              , xK_comma ), sendMessage (IncMasterN 1))

    -- Deincrement the number of windows in the master area
    , ((modm              , xK_period), sendMessage (IncMasterN (-1)))

    -- Toggle the status bar gap
    -- Use this binding with avoidStruts from Hooks.ManageDocks.
    -- See also the statusBar function from Hooks.DynamicLog.
    -- (Hide Polybar)
    , ((modm              , xK_b     ), sendMessage ToggleStruts)

    -- Quit xmonad
    , ((modm .|. shiftMask, xK_q     ), io (exitWith ExitSuccess))

    -- Restart xmonad
    , ((modm              , xK_q     ), spawn "xmonad --recompile; xmonad --restart")

    -- Screenshot controls
    , ((0, xK_Print),    spawn "flameshot full -c -p ~/Pictures/Screenshots/")
    , ((modm, xK_Print), spawn "flameshot gui  -p    ~/Pictures/Screenshots/")

    -- Lock Screen
    , ((modm .|. shiftMask, xK_l     ), spawn "~/.xmonad/scripts/lock.sh")

    -- Programs

    -- Galculator
    , ((modm              , xK_c     ), spawn "galculator")

    -- Firefox
    , ((modm              , xK_f     ), spawn "firefox")

    -- Spotify
    , ((modm              , xK_s     ), spawn "spotify")

    -- File Manager
    , ((modm .|. shiftMask, xK_f     ), spawn "nautilus")

    -- Brightness Commands
    , ((0, xF86XK_MonBrightnessUp)    , spawn "~/.xmonad/scripts/brightness.sh -i 5 -pyn")
    , ((0, xF86XK_MonBrightnessDown)  , spawn "~/.xmonad/scripts/brightness.sh -d 5 -pyn")

      -- Volume Notifications
    , ((0, xF86XK_AudioLowerVolume)   , spawn "~/.xmonad/scripts/volume.sh -d 5 -pnyl")
    , ((0, xF86XK_AudioMute)          , spawn "~/.xmonad/scripts/volume.sh      -nyml")
    , ((0, xF86XK_AudioRaiseVolume)   , spawn "~/.xmonad/scripts/volume.sh -i 5 -pnyl")
    ]
    ++

    --
    -- mod-[1..9], Switch to workspace N
    --
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    --
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]

------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--
myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $

    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster))

    -- mod-button2, Raise the window to the top of the stack
    , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modm, button3), (\w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster))

    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]

------------------------------------------------------------------------
-- Layouts:

-- You can specify and transform your layouts by modifying these values.
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
--
-- * NOTE: XMonad.Hooks.EwmhDesktops users must remove the obsolete
-- ewmhDesktopsLayout modifier from layoutHook. It no longer exists.
-- Instead use the 'ewmh' function from that module to modify your
-- def as a whole. (See also logHook, handleEventHook, and
-- startupHook ewmh notes.)
--
-- The available layouts.  Note that each layout is separated by |||,
-- which denotes layout choice.
--
myLayouts = renamed [CutWordsLeft 1] .
    avoidStruts . minimize .  B.boringWindows $
    smartBorders
        ( aTiled
				||| aGrid
				||| aThreeCol
        ||| aFullscreen
        )
  where
    aFullscreen = renamed [Replace "Full"] $ noBorders $ Full
    aThreeCol = renamed [Replace "ThreeCol"] $ smartSpacingWithEdge 10 $ ThreeCol 1 (3/100) (1/2)
    aGrid = renamed [Replace "Grid"] $ smartSpacingWithEdge 10 $ Grid
    aTiled = renamed [Replace "Tile"] $ smartSpacingWithEdge 10 $ Tall 1 (3 / 100) (1 / 2)

------------------------------------------------------------------------
-- Window rules:

-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
--
myManageHook = composeAll
    [ className =? "MPlayer"            --> doFloat
    , className =? "Galculator"         --> doFloat
    , className =? "MEGAsync"           --> doFloat
    , className =? "Org.gnome.Nautilus" --> doFloat
    , className =? "Toggl Desktop"      --> doFloat
    , className =? "Clockify"           --> doFloat
    , resource  =? "desktop_window"     --> doIgnore
    , resource  =? "kdesktop"           --> doIgnore

    -- Assign programs to workspaces
    , className =? "firefox"       --> doF(W.shift (myWorkspaces !! 1))
    , className =? "Brave-browser" --> doF(W.shift (myWorkspaces !! 1))
    , className =? "Thunderbird"   --> doF(W.shift (myWorkspaces !! 2))
    , className =? "discord"       --> doF(W.shift (myWorkspaces !! 3))
    -- Spotify not working
    , className =? "spotify"       --> doF(W.shift (myWorkspaces !! 7))]


myManageHook' = composeOne [ isFullscreen -?> doFullFloat ]

------------------------------------------------------------------------
-- Event handling

-- Defines a custom handler function for X Events. The function should
-- return (All True) if the default handler is to be run afterwards. To
-- combine event hooks use mappend or mconcat from Data.Monoid.
--
-- * NOTE: EwmhDesktops users should use the 'ewmh' function from
-- XMonad.Hooks.EwmhDesktops to modify their def as a whole.
-- It will add EWMH event handling to your custom event hooks by
-- combining them with ewmhDesktopsEventHook.
--
-- myEventHook = mempty

------------------------------------------------------------------------
-- Status bars and logging

-- Perform an arbitrary action on each internal state change or X event.
-- See the 'XMonad.Hooks.DynamicLog' extension for examples.
--
--
-- * NOTE: EwmhDesktops users should use the 'ewmh' function from
-- XMonad.Hooks.EwmhDesktops to modify their def as a whole.
-- It will add EWMH logHook actions to your custom log hook by
-- combining it with ewmhDesktopsLogHook.
--
myLogHook :: D.Client -> PP
myLogHook dbus = def
    { ppOutput = dbusOutput dbus
    , ppCurrent = wrap ("%{B" ++ bg2 ++ "} ") " %{B-}"
    , ppVisible = wrap ("%{B" ++ bg1 ++ "} ") " %{B-}"
    , ppUrgent = wrap ("%{F" ++ red ++ "} ") " %{F-}"
    , ppHidden = wrap " " " "
    , ppWsSep = ""
    , ppSep = " : "
    , ppTitle = shorten 20
    }


-- Emit a DBus signal on log updates
dbusOutput :: D.Client -> String -> IO ()
dbusOutput dbus str = do
    let signal = (D.signal objectPath interfaceName memberName) {
            D.signalBody = [D.toVariant $ UTF8.decodeString str]
        }
    D.emit dbus signal
  where
    objectPath = D.objectPath_ "/org/xmonad/Log"
    interfaceName = D.interfaceName_ "org.xmonad.Log"
    memberName = D.memberName_ "Update"


------------------------------------------------------------------------
-- Startup hook

-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
--
-- By default, do nothing.
--
-- * NOTE: EwmhDesktops users should use the 'ewmh' function from
-- XMonad.Hooks.EwmhDesktops to modify their def as a whole.
-- It will add initialization of EWMH support to your custom startup
-- hook by combining it with ewmhDesktopsStartup.
--
--
myStartupHook = do
    spawnOnce "gsettings set org.gnome.settings-daemon.plugins.xsettings overrides '[{'Gdk/WindowScalingFactor', <2>}]'"
    spawnOnce "gsettings set org.gnome.desktop.interface scaling-factor 2"
    spawnOnce "/usr/lib/geoclue-2.0/demos/agent"
    spawnOnce "nitrogen --restore"
    -- spawnOnce "picom --experimental-backend --config ~/.xmonad/confs/picom.conf"
    spawnOnce "picom --config ~/.config/awesome/configuration/compton.conf"
    spawnOnce "dunst -conf ~/.xmonad/confs/dunstrc"
    spawn "~/.xmonad/confs/polybar/launch.sh"
    spawnOnce "redshift"
    spawnOnce "mntray"
    spawnOnce "~/.xmonad/scripts/locker.sh"


------------------------------------------------------------------------
-- Now run xmonad with all the defaults we set up.

-- Run xmonad with the settings you specify. No need to modify this.
--

main :: IO ()
main = do
    dbus <- D.connectSession
    -- Request access to the DBus name
    D.requestName dbus (D.busName_ "org.xmonad.Log")
        [D.nameAllowReplacement, D.nameReplaceExisting, D.nameDoNotQueue]

    xmonad . ewmh $ defaults
        { logHook = dynamicLogWithPP (myLogHook dbus) }

-- A structure containing your configuration settings, overriding
-- fields in the default config. Any you don't override, will
-- use the defaults defined in xmonad/XMonad/Config.hs
--
-- No need to modify this.
--
defaults = def {
      -- simple stuff
        terminal           = myTerminal,
        focusFollowsMouse  = myFocusFollowsMouse,
        borderWidth        = myBorderWidth,
        modMask            = myModMask,
        -- numlockMask deprecated in 0.9.1
        -- numlockMask        = myNumlockMask,
        workspaces         = myWorkspaces,
        normalBorderColor  = myNormalBorderColor,
        focusedBorderColor = myFocusedBorderColor,

      -- key bindings
        keys               = myKeys,
        mouseBindings      = myMouseBindings,

      -- hooks, layouts
        layoutHook         = myLayouts,
        manageHook         = placeHook (smart (0.5, 0.5))
            <+> manageDocks
            <+> myManageHook
            <+> manageHook def,
        handleEventHook    = docksEventHook
            <+> fullscreenEventHook,
        startupHook        = myStartupHook
    }
