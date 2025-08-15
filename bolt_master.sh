#!/bin/bash

# Bolt Master - A simple racing game in Bash

# Game settings
TRACK_LENGTH=50
PLAYER_CHAR='>'
OBSTACLE_CHAR='X'
FINISH_LINE_CHAR='|'
EMPTY_CHAR=' '
SPEED=0.1  # Delay between frames (seconds)

# Game variables
player_pos=1
score=0
game_over=0
obstacles=()

# Initialize obstacles (random positions)
for ((i=0; i<5; i++)); do
    obstacles+=($((RANDOM % TRACK_LENGTH + 1)))
done

# Function to draw the game track
draw_track() {
    clear
    echo "BOLT MASTER - Score: $score"
    echo -n "["
    for ((i=1; i<=TRACK_LENGTH; i++)); do
        # Check what to draw at this position
        if [[ " ${obstacles[@]} " =~ " $i " ]]; then
            if [[ $i -eq $player_pos ]]; then
                echo -n "💥"  # Collision!
                game_over=1
            else
                echo -n "$OBSTACLE_CHAR"
            fi
        elif [[ $i -eq $player_pos ]]; then
            echo -n "$PLAYER_CHAR"
        elif [[ $i -eq $TRACK_LENGTH ]]; then
            echo -n "$FINISH_LINE_CHAR"
        else
            echo -n "$EMPTY_CHAR"
        fi
    done
    echo "]"
}

# Function to move obstacles left
move_obstacles() {
    for ((i=0; i<${#obstacles[@]}; i++)); do
        obstacles[$i]=$((obstacles[i] - 1))
        if [[ ${obstacles[$i]} -lt 1 ]]; then
            obstacles[$i]=$TRACK_LENGTH  # Wrap around
        fi
    done
}

# Function to handle player input
handle_input() {
    read -rsn1 -t $SPEED input
    case "$input" in
        " ")  # Space to jump (move forward)
            player_pos=$((player_pos + 2))
            ;;
        q)    # Quit game
            game_over=1
            ;;
    esac
    
    # Boundary check
    if [[ $player_pos -ge $TRACK_LENGTH ]]; then
        player_pos=$TRACK_LENGTH
        score=$((score + 100))
        game_over=2  # Win condition
    elif [[ $player_pos -lt 1 ]]; then
        player_pos=1
    fi
}

# Main game loop
while [[ $game_over -eq 0 ]]; do
    draw_track
    handle_input
    move_obstacles
    score=$((score + 1))
done

# Game over screen
draw_track
if [[ $game_over -eq 1 ]]; then
    echo "GAME OVER! Final score: $score"
else
    echo "YOU WIN! Final score: $score"
fi
