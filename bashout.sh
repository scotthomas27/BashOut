#!/bin/bash

# Add an affirmation to yourself
AFFIRM="DESCRIBE EVERYTHING!"

# Configure the save file path and extract the manuscript name
SAVE_FILE="RMN_Nano_2023.txt"
MANUSCRIPT_NAME=$(head -n 1 "$SAVE_FILE")

# Initialize session and total word counts
SESSION_WORD_COUNT=0
STARTING_WORD_COUNT=$(wc -w "$SAVE_FILE" | cut -f1 -d ' ')
TOTAL_WORD_COUNT=$(wc -w "$SAVE_FILE" | cut -f1 -d ' ')

# ANSI colour. Get from https://en.wikipedia.org/wiki/ANSI_escape_code#Colors
TEXT_COLOUR='\e[34m'
RESET_COLOUR='\e[0m'

# Function to update word counts
update_word_counts() {
    # Calculate sentence word count (based on spaces)
    SENTENCE_WORD_COUNT=$(echo "$1" | wc -w)

    # Get new total word count
    TOTAL_WORD_COUNT=$(wc -w "$SAVE_FILE" | cut -f1 -d ' ')

    # Update the session word count
    SESSION_WORD_COUNT=$((TOTAL_WORD_COUNT - STARTING_WORD_COUNT))
}

trap 'exit' INT  # Terminate the script with Ctrl-C

while true; do
    # Clear the terminal screen
    clear

    # Display the manuscript name as the window title
    printf "\033]0;%s\007" "$MANUSCRIPT_NAME"

    # Display session and total word counts and an affirmation
    echo "${TEXT_COLOUR}[${SESSION_WORD_COUNT}/${TOTAL_WORD_COUNT} | ${AFFIRM}]${RESET_COLOUR}"

    # Display the last sentence from the save file
    LAST_SENTENCE=$(tail -n 1 "$SAVE_FILE")
    echo "$LAST_SENTENCE"

    # Read user input
    read -p ": " NEW_SENTENCE

    # Check for multiple consecutive blank lines and reduce to one
    if [[ "$NEW_SENTENCE" == "" && "$(tail -n 1 "$SAVE_FILE")" == "" ]]; then
        # Do nothing, skip this line
        :
    else
        # Append the new sentence to the save file
        echo "" >> "$SAVE_FILE"
        echo "$NEW_SENTENCE" >> "$SAVE_FILE"
    fi

    # Update word counts
    update_word_counts "$NEW_SENTENCE"
done