goto() {
  local vim_args
  cache=".lkup_cache"
  case $2 in
    "-c")
      cache=".cap_cache"
      ;;
    "-g")
      cache=".gd_cache"
      ;;
    "-l"|"")
      cache=".lkup_cache"
      ;;
    *)
      echo "Invalid argument"
      echo
      echo -e "\e[36mgoto\e[0m <number> -c|-g|-l"
      echo "  -c  Use result from 'cap' (.cap_cache)"
      echo "  -g  Use result from 'gd' (.gd_cache) which does not point to specific lines"
      echo "  -l  Default, use result from 'lkup' (.lkup_cache)"
      echo
      return
  esac
  cache=~/.bash/$cache
  if [[ $1 = "each" ]]; then
    l=$(cat $cache | wc -l)
    i=1
    while [[ $i -le $l ]]; do
      goto $i $2
      i=$((i+1))
    done
    return
  fi
  pat="[^0-9]"
  if [[ $1 =~ $pat ]]; then
    _goto_parse $1
    return
  fi
  vim_args=$(cat $cache | head -n $1 | tail -n 1 | cut -d ':' -f 1-2 --output-delimiter=' +')
  if [[ -z $vim_args ]]; then
    echo "Not found: $1 $2"
    return 1
  fi
  echo "vim $vim_args"
  history -s "vim $vim_args"
  history -w
  vim $vim_args
}

_goto_parse() {
  file=$(echo $@ | cut -d ':' -f 1)
  line=$(echo $@ | cut -d ':' -f 2)
  vim $file "+$line"
}
