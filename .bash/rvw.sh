rvw() {
  set -e
  repo=$(git rev-parse --show-toplevel)
  mkdir -p /tmp/rvw
  rm -rf /tmp/rvw/*
  main=$(git symbolic-ref refs/remotes/origin/HEAD | cut -d/ -f4)
  base=$(git merge-base $main HEAD)
  files=$(git diff $base --name-only)

  echo "$files" > $repo/file_changes.txt

  for f in $files; do
    dir_path=$(echo /tmp/rvw/$f | rev | cut -d/ -f 2- | rev)
    mkdir -p $dir_path
    touch /tmp/rvw/$f
    git show $base:$f > /tmp/rvw/$f 2> /dev/null || true
  done
  if [[ "$TERM_PROGRAM" == "vscode" ]]; then
    for f in $(cat $repo/file_changes.txt); do
      code --diff /tmp/rvw/$f $f
    done
  else
    for f in $(cat ./file_changes.txt); do
      read -r -p "view $f? (Y/N/[Q]uit): " answer
      show=""
      quit=""
      case $answer in
        [Yy]* ) show="true"
          ;;
        [Qq]* ) quit="true"
          ;;
      esac
      if [[ $quit ]]; then
        break
      fi
      if [[ $show ]]; then
        vim -O /tmp/rvw/$f $f
      fi
    done
  fi
  rm $repo/file_changes.txt
}
