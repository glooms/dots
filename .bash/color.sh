color() {
  _color | less -R
}

_color() {
  echo "COLORS"
  echo "  bash: \e[38;5;<code>m"
  echo "  go:   \x1b[38;5;<code>m\n"
  entries_per_line=$(expr $(tput cols) / 10)
  for i in {0..255}; do
    s=$(printf "%03d" $i)
    echo -e "$s:\e[38;5;"$i"m███████████████\e[0m "
    # echo -en $s:"\e[38;5;"$i"m█████\e[0m "
    # if [[ $i -gt 0 && $(expr $(($i + 1)) % $entries_per_line) -eq 0 ]]; then
    #   echo
    # fi
  done
  # echo
}
