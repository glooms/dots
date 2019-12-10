# Grep in git project root folder
lkup() {
  if [[ $1 == "-l" ]]; then
    grep -rnPI --color=always $2 | _cache_lkup
    return
  else
    WDIR=$(pwd)
    while [[ $(pwd) != '/' ]]; do
      if [[ -d '.git' ]]; then
        grep -rnPI --exclude-dir={vendor,.git,node_modules} --color=always $1 | _cache_lkup
        break
      fi
      cd ..
    done
    cd $WDIR
  fi
}

_cache_lkup() {
  echo -n > ~/.bash/.lkup_cache
  base=$(pwd)
  i=1
  while read line
  do
    echo -e "\e[36m$i:\e[0m\t$line"
    echo $base/$line | sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[mGK]//g" >> ~/.bash/.lkup_cache
    i=$((i+1))
  done <&0
}
