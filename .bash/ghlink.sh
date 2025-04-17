ghlink() {
  absolute_path=$(realpath $1)
  if [[ ! -f $absolute_path ]]; then
    echo "No such file: $1"
    return 1
  fi
  repo_path=$(echo $absolute_path | cut -d/ -f 1-6)
  relative_path=${absolute_path#"$repo_path/"}
  wdir=$(pwd)
  cd $repo_path
  git_sha=$(git rev-parse HEAD)
  repo_url="https://$(git config --get remote.origin.url | cut -d@ -f2 | tr ":" "/")"
  cd $wdir

  link="$repo_url/blob/$git_sha/$relative_path"
  if [[ $2 ]]; then
    link+="#L$2"
  fi
  echo "$link"
}
