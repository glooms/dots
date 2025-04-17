prune() {
  mkdir -p /tmp/prune
  git branch -a > /tmp/prune/a
  git fetch --prune
  git branch -a > /tmp/prune/b
  BRANCHES=$(comm /tmp/prune/a /tmp/prune/b -23 | cut -d '/' -f 3-)
  for b in $BRANCHES; do
    git branch -D $b
  done
}
