snr() {
  if [[ -z $1 ]]; then
    __snr_usage
    return
  fi
  file_ext=""
  if [[ $3 ]]; then
    file_ext=".$3"
  fi
  find . -name "*$file_ext" -type f -exec sed -r -i "s/$1/$2/g" -- {} +
}

__snr_usage() {
  echo "Usage: snr <regex> <replace> [<file_extension>]"
}
