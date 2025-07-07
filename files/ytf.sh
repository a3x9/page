#!/bin/bash

# Check if a query is provided
if [ $# -eq 0 ]; then
  echo "Usage: yt-x <search-query>"
  exit 1
fi

# Combine all arguments into a single search query
query="$*"

# Use yt-dlp with optimized options to fetch titles and IDs only
selection=$(yt-dlp --flat-playlist --dump-json "ytsearch20:$query" | \
  jq -r '.title + " | " + .id' | \
  fzf --prompt="Select a video: " --layout=reverse --exit-0)

# Handle no selection
if [ -z "$selection" ]; then
  echo "No selection made. Exiting."
  exit 1
fi

# Extract and clean the video ID
video_id=$(echo "$selection" | awk -F'|' '{print $2}' | xargs)

# Open the video in mpv
mpv "https://www.youtube.com/watch?v=$video_id"

