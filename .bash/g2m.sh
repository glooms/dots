# Go 2 mod.
g2m() {
  mod_path=${GOPATH}/pkg/mod/
  src_path=${GOROOT}/src/
  if [[ "$#" -eq 2 ]]; then
    filename=$(echo $2 | cut -d ':' -f 1)
    if [[ -d $mod_path$1 ]]; then
      vim $mod_path$1/$filename
    elif [[ -d $src_path$1 ]]; then
      vim $src_path$1/$filename
    fi
  fi
  if [[ -f $mod_path$1 ]]; then
    vim $mod_path$1
  elif [[ -d $mod_path$1 ]]; then
    cd $mod_path$1
  elif [[ -f $src_path$1 ]]; then
    vim $src_path$1
  elif [[ -d $src_path$1 ]]; then
    cd $src_path$1
  fi
}

# $1 is the function being completed.
# $2 is the word being completed.
# $3 is the word preceding the word being completed.
__g2m() {
  mod_path=${GOPATH}/pkg/mod/
  src_path=${GOROOT}/src/
  if [[ $DEBUG ]]; then
    echo $# $@ >> $DEBUG
    echo $COMP_CWORDS ${COMP_WORDS[@]} >> $DEBUG
  fi
  comp=""
  if [[ "$3" = "g2m" ]] || [[ "$2" = "g2m" ]]; then
    comp=$(ls $mod_path$2* -d 2> /dev/null | sed "s:$mod_path::")
    comp+=" $(ls $src_path$2* -d 2> /dev/null | sed "s:$src_path::")"
  else
    if [[ -d $mod_path$3 ]]; then
      cur_path=$mod_path$3
    elif [[ -d $src_path$3 ]]; then
      cur_path=$src_path$3
    else
      cur_path=""
    fi
    if [[ $cur_path ]]; then
      comp=$(grep -oP "func (\(.+\) )?\K$2\w*" $cur_path/* 2> /dev/null | sed "s:$cur_path/::")
      comp+=" $(grep -oP "type (\(.+\) )?\K$2\w*" $cur_path/* 2> /dev/null | sed "s:$cur_path/::")"
    fi
  fi
  if [[ $DEBUG ]]; then
    echo $comp >> $DEBUG
  fi
  i=0
  for c in $comp; do
    i=$((i+1))
  done
  if [[ $i -eq 1 ]]; then
    for c in $comp; do
      if [[ -d $mod_path$c || -d $src_path$c ]]; then
        c=$c/
      fi
      COMPREPLY+=("$c")
    done
  else
    for c in $comp; do
      COMPREPLY+=("$c")
    done
  fi
}

complete -o nospace -F __g2m g2m
