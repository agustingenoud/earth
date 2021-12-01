#!/usr/bin/env bash
function start {
  echo 'Starting Docker environment . . .'
  docker-compose --project-name earth up -d
  echo 'opening browser . . . '
  python3 -m webbrowser http://localhost:80
  echo "You'll need this, maybe . . ."
  token
}

function stop {
  echo 'Stoping environment . . .'
  docker-compose --project-name earth down
}

function token {
  echo 'Notebook Token:'
  SERVER=$(docker exec -it earth_jupyter jupyter notebook list)
  echo "${SERVER}" | grep '/notebook' | sed -E 's/^.*=([a-z0-9]+).*$/\1/'
}

function superset-init {
  echo 'Initializing Superset database using sqlite'
  docker exec -it earth_superset superset-init
}

function superset-ip {
  echo 'Superset ip for db: '
  docker container inspect -f '{{ .NetworkSettings.Networks.earth_default.IPAddress }}' earth_postgres
}

function cleanup {
  echo "Removing volume"
  docker volume rm earth_postgres-data
  docker volume rm earth_superset
}

case $1 in

start)
  start
  ;;

stop)
  stop
  ;;

token)
  token
  ;;

superset-init)
  superset-init
  ;;

superset-ip)
  superset-ip
  ;;

cleanup)
  cleanup
  ;;

*)
  printf "ERROR: Missing command\n  Usage: $(basename $0) (start|stop|cleanup|token|logs|update|superset-start|superset-stop|superset-init)\n"
  exit 1
  ;;
esac
