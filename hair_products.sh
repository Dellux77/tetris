#!/bin/bash
# InfiniteHair - CLI Product Browser

categories=("Shampoo" "Conditioner" "Oil" "Mask" "Serum" "Spray" "Gel" "Wax" "Dye")
benefits=("Hydrating" "Repairing" "Volumizing" "Color-safe" "Anti-frizz" "Growth" "Thermal" "Organic" "Vegan")
types=("Curly" "Straight" "Fine" "Thick" "Damaged" "Oily" "Dry" "Color-treated")

generate_product() {
  c=${categories[$RANDOM % ${#categories[@]}]}
  b=${benefits[$RANDOM % ${#benefits[@]}]}
  t=${types[$RANDOM % ${#types[@]}]}
  price=$((5 + RANDOM % 50)).$((RANDOM % 99))
  echo "$b $c for $t Hair|$$price"
}

while true; do
  clear
  echo -e "Infinite Hair Products (Ctrl+C to exit)\n"
  for i in {1..5}; do
    printf "%2d) %s\n" "$i" "$(generate_product)"
  done
  echo -e "\n6) More products\n7) View cart\n8) Checkout"
  read -p "Select: " choice
  
  case $choice in
    [1-5]) echo "Added to cart"; sleep 1 ;;
    6) continue ;;
    7) echo "Cart: 0 items"; sleep 1 ;;
    8) echo "Checkout complete!"; exit ;;
    *) echo "Invalid option"; sleep 1 ;;
  esac
done
