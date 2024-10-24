#!/bin/bash

# Kill any previously running process to prevent multiple daemons causing lag
killall swaybg

# Directory containing wallpapers
WALLPAPER_DIR="$HOME/Wallpapers"

# Select a random wallpaper from all subdirectories
RANDOM_WALLPAPER=$(fd "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" \) | shuf -n 1)

# Set the wallpaper using swaybg in a non-blocking way
swaybg -i "$RANDOM_WALLPAPER" -m fill
