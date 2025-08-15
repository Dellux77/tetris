#!/bin/bash
# DellShow - Terminal Product Display

# Product data
declare -A products=(
    ["XPS 13"]="Ultrabook|1299.99|https://i.dell.com/das/dih.ashx/1000w/sites/csimages/Banner_Imagery/all/xps-13-9315-blue-gallery-1.png"
    ["Alienware m16"]="Gaming|2499.99|https://i.dell.com/das/dih.ashx/1000w/sites/csimages/Banner_Imagery/all/alienware-m16-r1-gallery-1.png"
    ["Latitude 7440"]="Business|1799.99|https://i.dell.com/das/dih.ashx/1000w/sites/csimages/Banner_Imagery/all/latitude-14-7440-gallery-1.png"
)

# Display function
show_products() {
    clear
    echo -e "\n\033[34mDell Product Showcase\033[0m\n"
    echo -e "\033[34m------------------------------------------------\033[0m"
    printf "%-15s %-10s %-10s %s\n" "Model" "Type" "Price" "Image URL"
    echo -e "\033[34m------------------------------------------------\033[0m"
    
    for model in "${!products[@]}"; do
        IFS='|' read -r type price url <<< "${products[$model]}"
        printf "%-15s %-10s \$%-10s %s\n" "$model" "$type" "$price" "$url"
    done
    
    echo -e "\033[34m------------------------------------------------\033[0m"
    echo -e "Products: ${#products[@]} | \033[32mUse 'links' or 'w3m' to view images\033[0m"
    echo -e "Press \033[31mCtrl+C\033[0m to exit\n"
}

# Main loop
while true; do
    show_products
    read -p "Enter product name for details (or 'q' to quit): " choice
    [[ "$choice" == "q" ]] && exit 0
    
    if [[ -v products["$choice"] ]]; then
        IFS='|' read -r type price url <<< "${products[$choice]}"
        echo -e "\n\033[1m$choice\033[0m"
        echo "Type: $type"
        echo "Price: \$$price"
        echo "Image: $url"
        echo -e "\nOpen image in:\n1) Terminal browser\n2) Default browser\n3) Back"
        read -p "Select: " opt
        
        case $opt in
            1) links "$url" 2>/dev/null || echo "Install 'links' for terminal browsing" ;;
            2) xdg-open "$url" 2>/dev/null || echo "Couldn't open browser" ;;
        esac
    else
        echo "Invalid product!"
        sleep 1
    fi
done
