glone() {
  git clone git@github.com:$1
}

__glone() {
  if [[ -z $2 ]]; then
    orgs="qlik-trial/ golang/ go-delve/ other/" #TODO this should be generated somehow
    echo "" > ~/.bash/.glone_cache
    for org in $orgs; do
      COMPREPLY+=("$org")
      (gurl "$org" &)
    done
  else
    repos=$(cat ~/.bash/.glone_cache)
    for r in $repos; do
      if [[ $r = $2* ]]; then
        COMPREPLY+=("$r")
      fi
    done
  fi
}

gurl() {
  token=$(cat ~/.github/token)
  repos=$(curl -s -H "Authorization: $token" "https://api.github.com/orgs/$1repos" | grep -oP "full_name\": \"\K$1.+?(?=\")")
  for r in $repos; do
    echo $r >> ~/.bash/.glone_cache
  done
}

complete -F __glone glone
