__make_dot() {
  MOD_NAME=$(go list -m)
  echo "digraph dep {"
  if [[ $1 = "true" || $MOD_NAME = "std" ]]; then
    go list -f '{{$package := .ImportPath}}{{range $_, $import := .Imports}}{{printf "%q -> %q\n" $package $import}}{{end}}' ./... | sed -r "s:$MOD_NAME/::g"
  else
    go list -f '{{$package := .ImportPath}}{{range $_, $import := .Imports}}{{printf "%q -> %q\n" $package $import}}{{end}}' ./... | grep " \"$MOD_NAME" | sed -r "s:$MOD_NAME/::g"
  fi
  echo "}"
}

dep() {
  case $1 in
    "-v"|"--verbose")
      _verbose=true
      ;;
    "")
      ;;
    *)
      echo "Usage: dep [-v|--verbose]"
      return
    esac
  __make_dot $_verbose | dot -T png -o graph.png
  xdg-open graph.png
}

