sand() {
  echo "Opening new shell, just exit to get back."
  bash --rcfile <(echo '. ~/.bashrc; cd ~/algee/sandbox; vim main.go')
}
