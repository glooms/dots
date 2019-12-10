anchr() {
  if [[ $# -gt 0 ]]; then
    case $1 in
      "?")
        if [[ $_ANCHOR ]]; then
          echo $_ANCHOR
        else
          echo "No anchor"
        fi;;
      "n")
        _ANCHOR=$(pwd);;
      "b")
        _TEMP=$(pwd)
        cd $_ANCHOR
        _ANCHOR=$_TEMP
        _TEMP="";;
      *)
        echo "Invalid argument"
        echo "anchr <arg>"
        echo "       anchr without arg jumps to anchor if set, otherwise sets anchor to wd"
        echo "  ?    prints the current anchor"
        echo "  n    overrides the current anchor with wd"
        echo "  b    anchr back but store pwd as next anchr"
    esac
    return
  fi
  if [[ $_ANCHOR ]]; then
    cd $_ANCHOR
    _ANCHOR=""
  else
    _ANCHOR=$(pwd)
  fi
}
