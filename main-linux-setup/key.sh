#!/bin/bash

# Check if xclip is installed
if ! command -v xclip &> /dev/null
then
    echo "xclip could not be found, please install it to use this script."
    exit 1
fi

# Hardcoded variable
KEY=""

# Prompt for user input if KEY is empty
if [ -z "$KEY" ]; then
    read -sp "Please enter your key: " KEY
    echo
fi

# Ask for sudo password (optional, if your script requires elevated privileges)
if ! sudo -n true 2>/dev/null; then
    echo "This script requires sudo privileges. Please enter your password."
    sudo -v
fi

# Copy the hardcoded or user-provided text to the clipboard
echo "$KEY" | xclip -selection clipboard

echo "Copied."