viz() {
  filepath="$(echo $1 | cut -d '.' -f 1).png"
  visualize $1 | dot -T png -o $filepath && wslview $filepath
}
