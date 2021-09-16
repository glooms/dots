#!/bin/bash

# check sanity first
$(complete 2&> /dev/null)
if [ $? -ne 0 ]; then
  echo "could not found 'complete' which is required"
  echo "If you're running zsh try adding:"
  echo
  echo "  autoload bashcompinit"
  echo "  bashcompinit"
  echo
  echo "to your .zshrc file."
  fail=true
fi
if [ ! -f ~/.github/token ]; then
  echo "Could not find GitHub token (PAT) in the ~/.github/token file."
  echo "To create one, head to:"
  echo
  echo "  https://github.com/settings/tokens"
  echo
  echo "Using the APIs without a PAT will surely (99%) lead to rate-limiting."
  echo "To access public repos however a PAT without any privilege-scope"
  echo "may be used."
  echo "For private repo access the 'repo' privilege-scope is needed."
  echo "Also note, if you wish to access private repos behind SSO you"
  echo "need to hit the 'Enable SSO' button."
  fail=true
fi
if [ $fail ]; then
  return 1
fi

# glone, git(Hub)-clone, is the actual command.
# It is quite simple, the nifty stuff is in the completion function __glone.
glone() {
  case $1 in
    "")
      #TODO improve usage documentation.
      echo "Usage: glone <owner>/<repo>"
      echo "Usage: glone --reset"
      ;;
    "--reset")
      echo "Resetting owner and repo list"
      if [[ -f ~/.glone/owner.cache ]]; then
        echo -n "" > ~/.glone/owner.cache
      fi
      if [[ -f ~/.glone/repo.cache ]]; then
        echo -n "" > ~/.glone/repo.cache
      fi
      ;;
    */)
      echo "Usage: glone $1<repo>"
      ;;
    */*)
      git clone git@github.com:$1
      ;;
    *)
      # try to fetch, omitting the / is probably a common mistake.
      (__fetch_repos $1/ &)
      echo "Usage: glone <owner>/<repo>"
  esac
}

# __glone is the completion function for glone.
# Note that all functions prefixed with '__' are intended only for generating completion.
__glone() {
  # Create necessary files.
  mkdir -p ~/.glone
  mkdir -p /tmp/glone
  owner_cache=~/.glone/owner.cache
  repo_cache=~/.glone/repo.cache
  touch $owner_cache
  touch $repo_cache
  case $2 in
    "")
      if [[ -f "/tmp/glone/fetching" ]]; then
        __list_owners
      else
        __glone_debug "Listing owners, fetch repos"
        owners=$(cat $owner_cache 2> /dev/null)
        for owner in $owners; do
          COMPREPLY+=("$owner")
        done
        # truncate repo_cache
        echo -n "" > $repo_cache
        (__fetch_repos $owners &)
      fi
      ;;
    */)
      owners=$(cat $owner_cache 2> /dev/null)
      if [[ $owners == *$2* ]]; then
        __glone_debug "Listing repos for $2"
        __list_repos $2
      else
        __glone_debug "Adding new owner $2"
        (__fetch_repos $2 &)
      fi
      ;;
    */*)
      __glone_debug "Listing repos matching $2"
      __list_repos $2
      rm -f /tmp/glone/fetching
      ;;
    *)
      __list_owners $2
  esac
}

# __fetch_repos fetches a repositories for a list of owners.
# It will fetch repos with the owner as both org and user.
# The fetching is concurrent to speed up completion generation.
# Results are cached in the repo_cache and new owners are added
# to the owner_cache.
__fetch_repos() {
  owners=$(cat $owner_cache)
  sub=()
  # If /tmp/glone/fetching exists, the initial completion (for empty argument)
  # will not run. This is to protect from tab-spamming.
  touch /tmp/glone/fetching
  for owner in $@; do
    __glone_debug "Fetching repos for $owner"
    if [[ $owners != *$owner* ]]; then
      echo $owner >> $owner_cache
    fi
    __fetch_repo ${owner} orgs &
    sub+=("$!")
    __fetch_repo ${owner} users &
    sub+=("$!")
  done
  for pid in ${sub[*]}; do
    wait $pid
  done
  rm -f /tmp/glone/fetching
}

# __fetch_repo fetches one list of repos using gurl and writes the results to
# the repo_cache.
__fetch_repo() {
  gurl "$2/$1repos" | grep -o "full_name\": \"$1.\+\"" | cut -d ' ' -f 2 | cut -d '"' -f 2 >> $repo_cache
}

# __list_repos lists all the repos from the repo_cache.
__list_repos() {
  repos=$(cat $repo_cache)
  for r in $repos; do
    if [[ $r = $1* ]]; then
      COMPREPLY+=("$r")
    fi
  done
}

# __list_owners lists all the owners from the owner_cache.
__list_owners() {
  __glone_debug "Listing owners"
  owners=$(cat $owner_cache 2> /dev/null)
  for owner in $owners; do
    if [[ $owner == $1* ]]; then
      COMPREPLY+=("$owner")
    fi
  done
}

# __glone_debug is used for debugging the completion.
# Recommended use is:
#
#   export $DEBUG_FILE=<file>
#   mkfifo $DEBUG_FILE
#
# In another shell you can then listen for input to the fifo:
#
#   while true; do cat <file>; done
#
# So you can see the output in real-time. Pretty neat.
__glone_debug() {
  if [[ $DEBUG_FILE ]]; then
    echo $@ >> $DEBUG_FILE
  fi
}

# gurl (github-cURL) retrieves all (handles pagination) the results from a
# github api v3 call.
# It assumes there is a Personal Access Token stored in plaintext in the file ~/.github/token
# Pagination calls are made in parallel, except for the first call of course.
gurl() {
  local token url_path
  url_path=$1
  __glone_debug "gurling: https://api.github.com/$url_path"
  token=$(cat ~/.github/token)
  mkdir -p /tmp/glone
  exec 3>/tmp/glone/err
  # verbose so we can parse the 'Link' header.
  2>&3 curl -svfH "Authorization: token $token" "https://api.github.com/$url_path" || return 1
  exec 4</tmp/glone/err
  link=$(cat <&4 | grep "\(L\|l\)ink:" | rev | cut -d ',' -f 1 | rev | grep -o "<.\+page=[0-9]\+")
  last=$(echo ${link:1} | cut -d '=' -f 2)
  link=$(echo ${link:1} | cut -d '=' -f 1)
  sub=()
  for (( i=2; i<=last; i++ )); do
    curl -sfH "Authorization: token $token" $link=$i # &
    #sub+=("$!")
  done
  #for pid in ${sub[*]}; do
  #  wait $pid
  #done
}

complete -o nospace -F __glone glone
