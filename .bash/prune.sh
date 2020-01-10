prune() {
  stat /tmp/prune &> /dev/null || mkdir /tmp/prune
  git branch -a > /tmp/prune/a
  git fetch --prune
  git branch -a > /tmp/prune/b
  BRANCHES=$(diff /tmp/prune/a /tmp/prune/b | grep ">" | cut -d '/' -f 3-)
  for b in $BRANCHES; do
    git branch -D $b
  done
  rm -rf /tmp/prune
}
