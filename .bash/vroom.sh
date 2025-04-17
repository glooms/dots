vroom() {
  local path dc_file
  path="$HOME/hax/vroom"
  dc_file=$path/docker-compose.yml
  if [[ ! -f $dc_file ]]; then
    echo "Setting up the vroom things"
    mkdir -p $path
    echo "Need sudo to change ownership to 1910:1910 for"
    echo "  $path/apps"
    echo "  $path/data"
    mkdir $path/apps && sudo chown 1910:1910 $path/apps
    mkdir $path/data && sudo chown 1910:1910 $path/data
  fi
  cat <<EOF > $path/docker-compose.yml
version: "3.3"
services:
  qix-engine-std:
    container_name: vroom-vroom
    image: ghcr.io/qlik-trial/engine:12.1849.0
    ports:
      - 10000:9076
    command: |
      -S AcceptEULA=yes
      -S DocumentDirectory=/apps
      -S SessionTimeoutSec=3600
    volumes:
      - ./apps:/apps
      - ./data:/data
EOF
  which docker >& /dev/null && docker ps >& /dev/null || \
    (echo "sudo service docker start" && sudo service docker start)

  if [[ "$1" == "down" ]]; then
    docker-compose -f $dc_file down
    return
  fi
  for i in {1..10}; do
    if [[ -z $(docker ps 2>/dev/null | grep "10000->9076") ]]; then
      docker-compose -f $dc_file up -d > /dev/null
      break
    fi
    sleep 1
  done
}
