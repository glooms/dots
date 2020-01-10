wwi() {
  file=~/.bash/.wherewasi
  case $1 in
    "clear")
      rm $file
      ;;
    "set")
      pwd > $file
      ;;
    "")
      if [[ -f $file ]]; then
        echo -e "You were at: \e[38;5;199m$(cat $file)\e[38;5;0m"
      fi
      ;;
    *)
      echo "Check the script, cba documenting"
  esac
}
