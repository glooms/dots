glone() {
  git clone git@github.com:$1
}

__glone() {
  if [[ -z $2 ]]; then
    return
  elif [[ $2 = */* ]]; then
    repos=$(tail -n+2 ~/.bash/.glone_cache)
    for r in $repos; do
      if [[ $r = $2* ]]; then
        COMPREPLY+=("$r")
      fi
    done
  else
    COMPREPLY+=(qlik-trial/)
    gurl "qlik-trial/"
  fi
}

gurl() {
  echo $1 > ~/.bash/.glone_cache
  token=$(cat ~/.github/token)
  repos=$(curl -s -H "Authorization: $token" "https://api.github.com/orgs/$1repos" | grep -oP "full_name\": \"\K$1.+?(?=\")")
  for r in $repos; do
    echo $r >> ~/.bash/.glone_cache
  done
}

complete -F __glone glone
