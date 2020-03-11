gd() {
  if [[ $1 == "" ]]; then
    git diff master
    return
  fi
  local res
  res="$(git diff master --name-status)"
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
  if [[ -z $1 ]]; then
    echo "gdd <number>"
    echo "Show diff of a file against master (from the gd_cache)"
    return
  fi
  local file
  file=$(cat ~/.bash/.gd_cache | head -n $1 | tail -n 1)
  echo -e "$(git diff --color=always master $file)"
}

_cache_gd() {
  local m a
  base=$(pwd)
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
