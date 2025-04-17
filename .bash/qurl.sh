qurl() {
  mkdir -p /tmp/qurl
  local name host headers ctype
  name=$(qlik context get | grep -oP "^name: \K.+")
  host=$(qlik context get | grep -oP "^server: \K.+")
  headers=$(yq ".contexts[\"$name\"].headers" ~/.qlik/contexts.yml)
  # echo "curl -sL $host/$1 -H \"$headers\""
  echo "curl -svL $host$1 -H \"Authorization: Bearer ...\" ${@:2}"
  curl -svL $host/$1 -H "$headers" ${@:2} 2> /tmp/qurl/err > /tmp/qurl/out
  ctype=$(grep -ioP "content-type: \K[\w\-/]+" /tmp/qurl/err)
  echo "Content-Type: $ctype"
  if [[ $ctype == "application/json" ]]; then
    cat /tmp/qurl/out | jq -C . | less -R
  else
    cat /tmp/qurl/out | less
  fi
}


