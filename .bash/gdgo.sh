gd() {
  local res
  res="$(git diff master --name-status)"
  case $1 in
    "-g"|"--go")
      res=$(echo "$res" | grep -v vendor | grep \.go$)
      ;;
    "-y"|"--yaml")
      res=$(echo "$res" | grep "\.ya\?ml$")
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

gdgo() {
  if [[ -z $1 ]]; then
    echo "gdgo <number>"
    echo "Open file from the gd_cache"
    return
  fi
  local file
  file=$(cat ~/.bash/.gd_cache | head -n $1 | tail -n 1)
  vim $file
}

_cache_gd() {
  local m a
  base=$(pwd)
  m="\e[33m"
  a="\e[32m"
  echo -n > ~/.bash/.gd_cache
  echo -e $m"MODIFIED\e[0m\t"$a"ADDED\e[0m"
  i=1
  while read line
  do
    stat=${line:0:1}
    file=$(echo $line | cut -d ' ' -f 2)
    if [[ $stat == "M" ]]; then
      echo -e $m"$i:\e[0m\t$file"
    elif [[ $stat == "A" ]]; then
      echo -e $a"$i:\e[0m\t$file"
    else
      echo -e "\e[36m$i:\e[0m\t$file"
    fi
    echo $base/$file >> ~/.bash/.gd_cache
    i=$((i+1))
  done <&0
}
