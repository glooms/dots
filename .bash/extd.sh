extd() {
  case $# in
    "0")
      vim ~/.bash/.bashrc_extend && source ~/.bash/.bashrc_extend
      ;;
    "1")
      vim ~/.bash/$1
      if [[ -f ~/.bash/$1 ]]; then
        source ~/.bash/$1
      fi
      ;;
    *)
      echo "Invalid arguments"
      echo "extd [arg]"
      echo "    extd opens a file in the ~/.bash directory, .bashrc_extend by default"
      ;;
  esac
}

__extd() {
  local comp
  comp=$(ls ~/.bash/$2*.sh | xargs -n 1 basename)
  for c in $comp; do
    COMPREPLY+=("$c")
  done
}

complete -F __extd extd
