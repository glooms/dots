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
  vim_args=$(cat ~/.bash/$cache | head -n $1 | tail -n 1 | cut -d ':' -f 1-2 --output-delimiter=' +')
  echo "vim $vim_args"
  vim $vim_args
}
