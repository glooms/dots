emoji() {
  if [[ -z $1 ]]; then
    __emoji_help
    return 1
  fi
  case $1 in
    "flower")
      echo 🌸
      ;;
    "heart")
      echo ❤️
      ;;
    *)
      echo "No such emoji"
      return 1
  esac
}

__emoji_help() {
  echo "emoji <name>"
  echo ""
  echo "Currently supported emojis:"
  echo "  flower"
  echo "  heart"
}

_emoji() {
  COMPREPLY=($(cat << EOF | grep "^$2"
flower
heart
EOF
))
}

complete -o default -F _emoji emoji
