# Grep in git project root folder
lkup() {
  local from_root exclude_tests
  while [[ $1 ]]; do
    match=""
    case $1 in
      "-l")
        from_root=true
        match=$1
        ;;
      "-xt")
        exclude_tests=true
        match=$1
        ;;
    esac
    if [[ -z "$match" ]]; then
      break
    fi
    set -- "${@:2}"
  done
  WDIR=$(pwd)
  if [[ -z "$from_root" ]]; then
    PROOT=$(git rev-parse --show-toplevel 2> /dev/null)
    if [[ $? == 0 ]]; then
      cd $PROOT
    else
      echo "You are not in a git repository"
      return 1
    fi
  fi
  echo "Searching from: $(pwd)" >&2
  if [[ "$exclude_tests" ]]; then
    echo "Excluding tests" >&2
    grep -rnPI --color=always \
      --exclude-dir={test,npm,npm-public,dist,.venv,venv,vendor,.git,node_modules,docs,target,__pycache__,.mypy_cache,__tests__} \
      --exclude={*-lock.*,*.lock,*.log,*.sum,*_test.*,*.test.*} "$@" | _cache_lkup
  else
    grep -rnPI --color=always \
      --exclude-dir={npm,npm-public,dist,.venv,venv,vendor,.git,node_modules,docs,target,__pycache__,.mypy_cache} \
      --exclude={*.lock,*.log,*.sum} "$@" | _cache_lkup
  fi
  cd $WDIR
}

lkup2() {
  if [[ -z $1 ]]; then
    echo -e "\e[38;5;199mlkup2\e[0m is a fancy find-exec-grep shorthand."
    echo "Usage:"
    echo "  lkup2 [+<ext> ...] [-<ext> ...] <grep-args>"
    return 1
  fi
  local ext_str first args arg i ext
  first="true"
  args=($@)
  i=0;
  while [[ "$i" -lt "$#" ]]; do
    arg=${args[$i]}
    case $arg in
      -*)
        ext=$(echo "$arg" | rev | cut -d- -f1 | rev)
        if [[ $first ]]; then
          ext_str+="-name \"*.$ext\""
          first=""
        else
          ext_str+=" -o -name \"*.$ext\""
        fi
        ;;
      *)
        break
        ;;
    esac
    ((i++))
  done
  ((i++))
  if [[ -z $ext_str ]]; then
    ext_str="-name \"*\""
  fi
  eval "find . \( -name \"vendor\" -o -name \"npm\" -o -name \"dist\" \) -type d -prune -o \
    \( $ext_str \) -type f \
    -exec grep -nIP --color=always \"${@:$i}\" {} + | _cache_lkup"
}

_cache_lkup() {
  echo -n > ~/.bash/.lkup_cache
  base=$(pwd)
  i=1
  while read line
  do
    echo -e "\e[36m$i:\t$line"
    echo $base/$line | sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[mGK]//g" >> ~/.bash/.lkup_cache
    i=$((i+1))
  done <&0
}
