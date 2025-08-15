#!/bin/bash

# Fruit Merge Game

# Game variables
score=0
grid_size=4
declare -A grid
game_over=0

# Fruits and their values
fruits=("🍎" "🍊" "🍐" "🍇" "🍉" "🍍" "🥝" "🍓" "🍒" "🥥")
values=(1 2 3 5 8 13 21 34 55 89)

# Initialize the grid
init_grid() {
    for ((i=0; i<grid_size; i++)); do
        for ((j=0; j<grid_size; j++)); do
            grid[$i,$j]=0 # 0 means empty
        done
    done
    add_random_fruit
    add_random_fruit
}

# Add a random fruit to an empty cell
add_random_fruit() {
    local empty_cells=()
    
    # Find all empty cells
    for ((i=0; i<grid_size; i++)); do
        for ((j=0; j<grid_size; j++)); do
            if [[ ${grid[$i,$j]} -eq 0 ]]; then
                empty_cells+=("$i,$j")
            fi
        done
    done
    
    # If there are empty cells, add a random fruit
    if [[ ${#empty_cells[@]} -gt 0 ]]; then
        local random_cell=${empty_cells[$RANDOM % ${#empty_cells[@]}]}
        IFS=',' read -r i j <<< "$random_cell"
        grid[$i,$j]=1 # Start with the first fruit
    else
        # Check if game is over (no possible merges)
        check_game_over
    fi
}

# Display the grid
display_grid() {
    clear
    echo -e "\n  FRUIT MERGE GAME"
    echo -e "  Score: $score\n"
    
    for ((i=0; i<grid_size; i++)); do
        echo -n "  "
        for ((j=0; j<grid_size; j++)); do
            local val=${grid[$i,$j]}
            if [[ $val -eq 0 ]]; then
                echo -n "    "
            else
                echo -n "${fruits[val-1]} "
            fi
        done
        echo
    done
    
    echo -e "\n  Controls:"
    echo "  W - Up, A - Left, S - Down, D - Right"
    echo "  Q - Quit Game"
}

# Move fruits in a direction
move_fruits() {
    local direction=$1
    local moved=0
    
    case $direction in
        w) # Up
            for ((j=0; j<grid_size; j++)); do
                for ((i=1; i<grid_size; i++)); do
                    if [[ ${grid[$i,$j]} -ne 0 ]]; then
                        local k=$i
                        while [[ $k -gt 0 ]]; do
                            # If cell above is empty, move up
                            if [[ ${grid[$((k-1)),$j]} -eq 0 ]]; then
                                grid[$((k-1)),$j]=${grid[$k,$j]}
                                grid[$k,$j]=0
                                moved=1
                                ((k--))
                            # If cell above has same value, merge
                            elif [[ ${grid[$((k-1)),$j]} -eq ${grid[$k,$j]} ]]; then
                                merge_fruits $((k-1)) $j $k $j
                                moved=1
                                break
                            else
                                break
                            fi
                        done
                    fi
                done
            done
            ;;
        s) # Down
            for ((j=0; j<grid_size; j++)); do
                for ((i=grid_size-2; i>=0; i--)); do
                    if [[ ${grid[$i,$j]} -ne 0 ]]; then
                        local k=$i
                        while [[ $k -lt $((grid_size-1)) ]]; do
                            if [[ ${grid[$((k+1)),$j]} -eq 0 ]]; then
                                grid[$((k+1)),$j]=${grid[$k,$j]}
                                grid[$k,$j]=0
                                moved=1
                                ((k++))
                            elif [[ ${grid[$((k+1)),$j]} -eq ${grid[$k,$j]} ]]; then
                                merge_fruits $((k+1)) $j $k $j
                                moved=1
                                break
                            else
                                break
                            fi
                        done
                    fi
                done
            done
            ;;
        a) # Left
            for ((i=0; i<grid_size; i++)); do
                for ((j=1; j<grid_size; j++)); do
                    if [[ ${grid[$i,$j]} -ne 0 ]]; then
                        local k=$j
                        while [[ $k -gt 0 ]]; do
                            if [[ ${grid[$i,$((k-1))]} -eq 0 ]]; then
                                grid[$i,$((k-1))]=${grid[$i,$k]}
                                grid[$i,$k]=0
                                moved=1
                                ((k--))
                            elif [[ ${grid[$i,$((k-1))]} -eq ${grid[$i,$k]} ]]; then
                                merge_fruits $i $((k-1)) $i $k
                                moved=1
                                break
                            else
                                break
                            fi
                        done
                    fi
                done
            done
            ;;
        d) # Right
            for ((i=0; i<grid_size; i++)); do
                for ((j=grid_size-2; j>=0; j--)); do
                    if [[ ${grid[$i,$j]} -ne 0 ]]; then
                        local k=$j
                        while [[ $k -lt $((grid_size-1)) ]]; do
                            if [[ ${grid[$i,$((k+1))]} -eq 0 ]]; then
                                grid[$i,$((k+1))]=${grid[$i,$k]}
                                grid[$i,$k]=0
                                moved=1
                                ((k++))
                            elif [[ ${grid[$i,$((k+1))]} -eq ${grid[$i,$k]} ]]; then
                                merge_fruits $i $((k+1)) $i $k
                                moved=1
                                break
                            else
                                break
                            fi
                        done
                    fi
                done
            done
            ;;
    esac
    
    if [[ $moved -eq 1 ]]; then
        add_random_fruit
    fi
}

# Merge two fruits
merge_fruits() {
    local i1=$1 j1=$2 i2=$3 j2=$4
    local val=${grid[$i1,$j1]}
    
    # Increase fruit value (but don't exceed max)
    if [[ $val -lt ${#fruits[@]} ]]; then
        grid[$i1,$j1]=$((val + 1))
        score=$((score + values[val-1]))
    fi
    grid[$i2,$j2]=0
}

# Check if game is over
check_game_over() {
    local empty_cells=0
    local possible_merges=0
    
    for ((i=0; i<grid_size; i++)); do
        for ((j=0; j<grid_size; j++)); do
            if [[ ${grid[$i,$j]} -eq 0 ]]; then
                ((empty_cells++))
            else
                # Check adjacent cells for possible merges
                if [[ $i -gt 0 && ${grid[$i,$j]} -eq ${grid[$((i-1)),$j]} ]]; then
                    ((possible_merges++))
                fi
                if [[ $i -lt $((grid_size-1)) && ${grid[$i,$j]} -eq ${grid[$((i+1)),$j]} ]]; then
                    ((possible_merges++))
                fi
                if [[ $j -gt 0 && ${grid[$i,$j]} -eq ${grid[$i,$((j-1))]} ]]; then
                    ((possible_merges++))
                fi
                if [[ $j -lt $((grid_size-1)) && ${grid[$i,$j]} -eq ${grid[$i,$((j+1))]} ]]; then
                    ((possible_merges++))
                fi
            fi
        done
    done
    
    if [[ $empty_cells -eq 0 && $possible_merges -eq 0 ]]; then
        game_over=1
    fi
}

# Main game loop
main() {
    init_grid
    
    while [[ $game_over -eq 0 ]]; do
        display_grid
        
        read -rsn1 input
        case $input in
            w|a|s|d) move_fruits "$input" ;;
            q) echo -e "\n  Thanks for playing!"; exit 0 ;;
            *) continue ;;
        esac
    done
    
    display_grid
    echo -e "\n  GAME OVER! Final Score: $score"
}

main
