#!/bin/bash

# Step 1: List available audio sources
echo "Listing available audio sources..."
pactl list short sources

# Step 2: Prompt user to select an audio input source
read -p "Enter the number of the audio source to use: " AUDIO_SOURCE_NUMBER

# Get the selected audio source by number
AUDIO_SOURCE=$(pactl list short sources | sed -n "${AUDIO_SOURCE_NUMBER}p" | awk '{print $2}')

if [ -z "$AUDIO_SOURCE" ]; then
    echo "Invalid audio source selection. Exiting."
    exit 1
fi

# Step 3: Prompt for the output filename
read -p "Enter the output filename (e.g., output.mp4): " OUTPUT_FILENAME

# If no filename is provided, exit
if [ -z "$OUTPUT_FILENAME" ]; then
    echo "No output filename provided. Exiting."
    exit 1
fi

# Step 4: Check if the filename has an extension, default to .mp4 if not
if [[ ! "$OUTPUT_FILENAME" =~ \. ]]; then
    OUTPUT_FILENAME="$OUTPUT_FILENAME.mp4"
    echo "No extension provided, defaulting to .mp4"
fi

# Step 5: Start recording with ffmpeg
echo "Starting screen recording with audio source: $AUDIO_SOURCE..."

ffmpeg \
    -framerate 24 \
    -f x11grab -video_size 1366x720 -i :0.0 \
    -f pulse -i "$AUDIO_SOURCE.monitor" \
    -c:v libx264 -preset fast -crf 23 -pix_fmt yuv420p \
    -c:a aac -b:a 192k \
    -shortest \
    "$OUTPUT_FILENAME"

echo "Recording saved as $OUTPUT_FILENAME"
