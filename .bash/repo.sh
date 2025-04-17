repo() {
  if [[ -z $1 ]]; then
    repo_path=$(git rev-parse --show-toplevel 2> /dev/null)
    if [[ $? -eq 0 && $repo_path ]]; then
      cd $repo_path
      return
    else
      echo "repo - cd to a repo (~/git/*/<repo-name>)"
      echo "  repo <repo-name>"
      return 1
    fi
  fi
  repo_path=$(ls -d ~/git/*/* | grep "/$1$")
  line_count=$(echo "$repo_path" | wc -l)
  if [[ $line_count -gt 1 ]]; then
    # TODO handle multiple results through dialog.
    echo "Ambiguous result, multiple repos:"
    i=1
    for f in $repo_path; do
      echo "$i  $f"
      i=$(expr $i + 1)
    done
    read -p "Specify which repo: " n
    repo_path=$(echo $repo_path | cut -d ' ' -f $n)
    if [[ -z $repo_path ]]; then
      echo "Invalid index: '$n'"
      return 1
    fi
  fi
  if [[ $line_count -eq 0 ]]; then
    echo "Repo not found."
    return 1
  fi
  if [[ -z $repo_path ]]; then
    echo "Invalid repo: $1"
    return 1
  fi
  cd $repo_path
}

ovr() {
  if [[ -z $1 ]]; then
    echo "ovr - cd to a repo and do 'pnpm start', use with overrides in import-map"
    echo "  ovr <repo-name>"
    return 1
  fi
  if [[ $1 != "." ]]; then
    repo $1
  fi
  pnpm install && pnpm start
}

_repo() {
  comp=$(ls -d ~/git/*/* | rev | cut -d/ -f1 | rev | grep "^$2")
  for c in $comp; do
    COMPREPLY+=("$c")
  done
}

_ovr() {
  comp=$(ls ~/git/*/*/package.json | rev | cut -d/ -f2 | rev | grep "^$2")
  for c in $comp; do
    COMPREPLY+=("$c")
  done
}

complete -o default -F _repo repo
complete -o default -F _ovr ovr
