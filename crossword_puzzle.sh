#!/bin/bash

# Crossword Puzzle Generator in Bash

# Define the crossword grid size
ROWS=15
COLS=15

# Initialize an empty grid
declare -A grid
for ((i=0; i<ROWS; i++)); do
    for ((j=0; j<COLS; j++)); do
        grid[$i,$j]='.'
    done
done

# List of words to place (you can customize this)
words=(
    "BASH"
    "LINUX"
    "TERMINAL"
    "SCRIPT"
    "COMMAND"
    "PUZZLE"
    "FUNCTION"
    "VARIABLE"
    "ARRAY"
    "LOOP"
)

# Function to place a word horizontally
place_horizontal() {
    local word=$1 row=$2 col=$3
    local len=${#word}
    
    # Check if word fits
    if (( col + len > COLS )); then
        return 1
    fi
    
    # Check for conflicts
    for ((i=0; i<len; i++)); do
        local cell=${grid[$row,$((col+i))]}
        if [[ "$cell" != "." && "$cell" != "${word:i:1}" ]]; then
            return 1
        fi
    done
    
    # Place the word
    for ((i=0; i<len; i++)); do
        grid[$row,$((col+i))]=${word:i:1}
    done
    
    return 0
}

# Function to place a word vertically
place_vertical() {
    local word=$1 row=$2 col=$3
    local len=${#word}
    
    # Check if word fits
    if (( row + len > ROWS )); then
        return 1
    fi
    
    # Check for conflicts
    for ((i=0; i<len; i++)); do
        local cell=${grid[$((row+i)),$col]}
        if [[ "$cell" != "." && "$cell" != "${word:i:1}" ]]; then
            return 1
        fi
    done
    
    # Place the word
    for ((i=0; i<len; i++)); do
        grid[$((row+i)),$col]=${word:i:1}
    done
    
    return 0
}

# Try to place each word
for word in "${words[@]}"; do
    # Randomly decide orientation (0=horizontal, 1=vertical)
    orientation=$((RANDOM % 2))
    placed=false
    
    # Try up to 100 times to place the word
    for ((attempt=0; attempt<100; attempt++)); do
        row=$((RANDOM % ROWS))
        col=$((RANDOM % COLS))
        
        if (( orientation == 0 )); then
            if place_horizontal "$word" $row $col; then
                placed=true
                break
            fi
        else
            if place_vertical "$word" $row $col; then
                placed=true
                break
            fi
        fi
    done
    
    if ! $placed; then
        echo "Failed to place: $word" >&2
    fi
done

# Print the crossword puzzle
echo "Crossword Puzzle:"
echo "-----------------"
for ((i=0; i<ROWS; i++)); do
    for ((j=0; j<COLS; j++)); do
        echo -n "${grid[$i,$j]} "
    done
    echo
done

# Print word list
echo
echo "Words to find:"
printf "%s\n" "${words[@]}" | sort
