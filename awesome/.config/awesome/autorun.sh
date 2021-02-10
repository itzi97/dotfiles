#!/usr/bin/env bash

function run {
  if ! pgrep -f $1 ;
  then
    $@&
  fi
}

run picom --experimental-backends --config ~/.config/awesome/confs/picom.conf
run nitrogen --restore
run megasync
