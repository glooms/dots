cap () {
  if [[ -z $1 ]]; then
    echo -n > ~/.bash/.cap_cache
  else
    echo -e "\e[36mcap\e[0m takes no arguments, it only pipes selected output to ~/.cap_cache."
    echo "Use:"
    echo
    echo "  cmd |& cap"
    echo
    return
  fi
  local match base
  base=$(pwd)
  i=1
  while read line
  do
    match=$(echo $line | grep -P --color=always "\.\w+:\d+(:\d+| \+0x[0-9a-f]+)")
    if [[ -z $match ]]; then
      echo $line
    else
      echo -e "\e[36m$i:\e[0m\t$match"
      if [[ $match = ~/* ]]; then #Handle stack traces
        match=$(echo $match | cut -d ' ' -f 1)
        echo $match | sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[mGK]//g" >> ~/.bash/.cap_cache
      else #Handle build errors
        echo $base/$match | sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[mGK]//g" >> ~/.bash/.cap_cache
      fi
      i=$((i+1))
    fi
  done <&0
}
