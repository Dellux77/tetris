#!/bin/bash

# Woodle Screw Jam - Word Scramble Game

# Game settings
WORDS=("bash" "linux" "script" "terminal" "command" "puzzle" "function" "variable" "array" "loop")
MAX_ATTEMPTS=3
POINTS_PER_WORD=100
BONUS_POINTS=50

# Game variables
score=0
current_word=""
scrambled_word=""

# Function to scramble a word
scramble_word() {
    local word=$1
    echo "$word" | fold -w1 | shuf | tr -d '\n'
}

# Function to select a new word
new_word() {
    local index=$((RANDOM % ${#WORDS[@]}))
    current_word=${WORDS[$index]}
    scrambled_word=$(scramble_word "$current_word")
}

# Function to display game header
display_header() {
    clear
    echo "╔══════════════════════════════╗"
    echo "║        WOODLE SCREW JAM      ║"
    echo "╠══════════════════════════════╣"
    echo "║ Score: $score                 "
    echo "║ Scrambled: $scrambled_word    "
    echo "║ Attempts left: $attempts      "
    echo "╚══════════════════════════════╝"
    echo
}

# Main game loop
while true; do
    new_word
    attempts=$MAX_ATTEMPTS
    solved=false
    
    while [[ $attempts -gt 0 && $solved == false ]]; do
        display_header
        
        read -p "Your guess: " guess
        
        if [[ "$guess" == "$current_word" ]]; then
            echo "Correct! 🎉"
            score=$((score + POINTS_PER_WORD))
            
            # Bonus for solving with remaining attempts
            if [[ $attempts -gt 1 ]]; then
                bonus=$(( (attempts - 1) * BONUS_POINTS ))
                echo "Bonus: +$bonus points for ${attempts} attempts left!"
                score=$((score + bonus))
            fi
            
            solved=true
            read -p "Press enter to continue..."
        else
            attempts=$((attempts - 1))
            if [[ $attempts -gt 0 ]]; then
                echo "Try again! Hint: It's a ${#current_word}-letter word about programming."
            else
                echo "Out of attempts! The word was: $current_word"
            fi
        fi
    done
    
    display_header
    read -p "Play again? (y/n): " choice
    if [[ "$choice" != "y" ]]; then
        break
    fi
done

echo "Game over! Final score: $score"
