color() {
  echo "COLORS"
  echo "  bash: \e[38;5;<code>m"
  echo "  go:   \x1b[38;5;<code>m"
  for i in {0..15}; do
    for j in {0..15}; do
      c=$((i * 16 + j))
      echo -en $c:"\t\e[38;5;"$c"m█████\e[0m "
      if [[ $j == "7" || $j == "15" ]]; then
        echo
      fi
    done
  done
}
