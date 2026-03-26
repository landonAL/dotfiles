#!/bin/sh
EWM_MODULE_PATH=/home/landon/Documents/ewm/compositor/target/debug/libewm_core.so \
  emacs --fg-daemon -L /home/landon/Documents/ewm/lisp -l ewm -f ewm-start-module
