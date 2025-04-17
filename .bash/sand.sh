sand() {
  local mode file files path
  if [[ -z $1 ]]; then
    echo "Specify project name"
    return 1
  fi
  if [[ $2 ]]; then
    case $2 in
      "--go")
        mode="go"
        ;;
      "--bash")
        mode="bash"
        ;;
      "--py")
        mode="py"
        ;;
      *)
        echo "Invalid argument $2"
        echo "  sand <name> [mode]"
        echo ""
        echo "  --go\t for go sandbox"
        echo "  --bash\t for bash sandbox"
        echo ""
        echo "Default mode is go."
    esac
  else
    mode="go"
  fi
  path="$HOME/algee/sandbox/$1"
  if [[ ! -d $path ]]; then
    mkdir $path
    case $mode in
      "go")
        # mod file
        echo "module $1" >> $path/go.mod
        echo "" >> $path/go.mod
        echo "go 1.22" >> $path/go.mod
        # main file
        echo "package main" >> $path/main.go
        echo "" >> $path/main.go
        echo "import ()" >> $path/main.go
        echo "" >> $path/main.go
        echo "func main() {" >> $path/main.go
        echo "" >> $path/main.go
        echo "}" >> $path/main.go
        file=main.go
        ;;
      "bash")
        touch $path/script.sh
        chmod +x $path/script.sh
        file=script.sh
        ;;
      "py")
        echo "#!$(which python3)" > $path/main.py
        chmod +x $path/main.py
        file=main.py
        ;;
    esac
  else
    files=( $(ls $path/*.go 2> /dev/null) ) && file=${files[0]}
    if [[ ! $file ]]; then
      files=( $(ls $path/*.sh 2> /dev/null) ) && file=${files[0]}
    fi
    if [[ ! $file ]]; then
      files=( $(ls $path/*.py 2> /dev/null) ) && file=${files[0]}
    fi
    if [[ $file ]]; then
      file=$(basename $file)
    fi
  fi

  cd ~/algee/sandbox/$1
  if [[ $file ]]; then
    vim $file
  fi
}

__sand() {
  if [[ $1 != $3 ]]; then
    return
  fi
  local comp
  comp=$(ls -d ~/algee/sandbox/$2* 2> /dev/null | xargs -n 1 basename 2> /dev/null)
  for c in $comp; do
    COMPREPLY+=("$c")
  done
}

complete -F __sand sand
