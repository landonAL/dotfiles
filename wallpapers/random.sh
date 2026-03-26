WALLPAPER_DIR="$HOME/wallpapers/"
RANDOM_WALLPAPER=$(find "$WALLPAPER_DIR" -type f ! -name "*.sh" | shuf -n 1)
swaybg -i "$RANDOM_WALLPAPER" -m fill
