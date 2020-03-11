color() {
  echo "COLORS"
  echo "  bash: \e[38;5;<code>m"
  echo "  go:   \x1b[38;5;<code>m"
  file="$HOME/.bash/.color_cache"
  if [[ -f $file ]]; then
    echo -e $(cat $file)
  else
    colors=$(_color)
    echo -e $colors
    echo -e $colors > $file
  fi
}

_color() {
  for i in {0..15}; do
    for j in {0..15}; do
      c=$((i * 16 + j))
      c=$(printf "%03d" $c)
      echo -en $c:"\e[38;5;"$c"m█████\e[0m "
      if [[ $j == "7" || $j == "15" ]]; then
        echo
      fi
    done
  done
}
