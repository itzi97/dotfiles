#!/bin/sh

exec xautolock \
  -detectsleep \
  -time 10 \
  -locker "i3lock-fancy" \
  -nowlocker "i3lock" \
  -notify 30 \
  -notifier "dunstify -u critical -t 10000 -- 'LOCKING screen in 30 seconds'" &

exec xidlehook \
  --not-when-fullscreen \
  --timer 1200 "systemctl suspend" - &
