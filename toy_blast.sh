#!/bin/bash

# Toy Last-In implementation in Bash (stack)

stack=()  # Initialize an empty array for our stack

function push() {
    # Add item to the top of the stack
    local item="$1"
    stack+=("$item")
    echo "Pushed: $item"
}

function pop() {
    # Remove and return the top item from the stack
    if [ ${#stack[@]} -eq 0 ]; then
        echo "Stack is empty!"
        return 1
    fi
    
    local last_index=$(( ${#stack[@]} - 1 ))
    local item="${stack[$last_index]}"
    unset "stack[$last_index]"
    echo "Popped: $item"
}

function peek() {
    # View the top item without removing it
    if [ ${#stack[@]} -eq 0 ]; then
        echo "Stack is empty!"
        return 1
    fi
    
    local last_index=$(( ${#stack[@]} - 1 ))
    echo "Top item: ${stack[$last_index]}"
}

function show() {
    # Display the current stack
    if [ ${#stack[@]} -eq 0 ]; then
        echo "Stack: []"
        return
    fi
    
    echo "Stack: [${stack[@]}] (left is bottom, right is top)"
}

# Simple menu interface
while true; do
    echo
    echo "1. Push item"
    echo "2. Pop item"
    echo "3. Peek at top"
    echo "4. Show stack"
    echo "5. Exit"
    read -p "Choose an option (1-5): " choice
    
    case $choice in
        1)
            read -p "Enter item to push: " item
            push "$item"
            ;;
        2)
            pop
            ;;
        3)
            peek
            ;;
        4)
            show
            ;;
        5)
            echo "Goodbye!"
            exit 0
            ;;
        *)
            echo "Invalid option!"
            ;;
    esac
done
