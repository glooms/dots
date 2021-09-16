gd() {
  if [[ -z $BRANCH ]]; then
    BRANCH=$(le_git_main)
  fi
  if [[ $1 == "" ]]; then
    git diff $BRANCH
    return
  fi
  local res
  res="$(git diff $BRANCH --name-status)"
  case $1 in
    "-g"|"--go")
      res=$(echo "$res" | grep -v vendor | grep \.go$)
      ;;
    "-y"|"--yaml")
      res=$(echo "$res" | grep "\.ya\?ml$")
      ;;
    "-a"|"--all")
      ;;
    *)
      echo "Invalid arguments"
      echo "gd [filter]"
      echo "-g|--go\tfilter go files"
      echo "-y|--yaml\tfitler yaml files"
      return
  esac
  echo "$res" | _cache_gd
}

gdd() {
  __main=$(git symbolic-ref refs/remotes/origin/HEAD | rev | cut -d '/' -f 1 | rev)
  if [[ -z $1 ]]; then
    echo "gdd <number>|each"
    echo "Show diff of a file against $__main (from the gd_cache)"
    return
  fi
  local file
  if [[ $1 = "each" ]]; then
    while read file
    do
      git diff $__main $file
    done < ~/.bash/.gd_cache
  else
    file=$(cat ~/.bash/.gd_cache | head -n $1 | tail -n 1)
    git diff $__main $file
  fi
}

_cache_gd() {
  local m a
  base=$(git rev-parse --show-toplevel)
  m="\e[33m"
  a="\e[32m"
  d="\e[31m"
  echo -n > ~/.bash/.gd_cache
  echo -e $m"MODIFIED\t"$a"ADDED\t\t"$d"DELETED\e[0m"
  i=1
  while read line
  do
    stat=${line:0:1}
    file=$(echo $line | cut -d ' ' -f 2)
    if [[ -z $file ]]; then
      continue
    fi
    case $stat in
      "M")
        echo -e $m"$i:\e[0m\t$file"
        ;;
      "A")
        echo -e $a"$i:\e[0m\t$file"
        ;;
      "D")
        echo -e $d"$i:\e[0m\t$file"
        ;;
      *)
        continue
    esac
    echo $base/$file >> ~/.bash/.gd_cache
    i=$((i+1))
  done <&0
}
