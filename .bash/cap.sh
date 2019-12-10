cap () {
  if [[ -z $1 ]]; then
    echo -n > ~/.bash/.cap_cache
  else
    echo -e "\e[36mcap\e[0m takes no arguments, it only pipes selected output to ~/.cap_cache."
    echo "Use:"
    echo
    echo "  cmd 2>&1 | cap"
    echo
    return
  fi
  local match base
  base=$(pwd)
  i=1
  while read line
  do
    match=$(echo $line | grep -P --color=always "\.\w+:\d+:\d+")
    if [[ -z $match ]]; then
      echo $line
    else
      echo -e "\e[36m$i:\e[0m\t$match"
      echo $base/$match | sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[mGK]//g" >> ~/.bash/.cap_cache
      i=$((i+1))
    fi
  done <&0
}
