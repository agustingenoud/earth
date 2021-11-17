#!/usr/bin/env bash

function token {
  echo 'Your TOKEN for Jupyter Notebook is:'
  SERVER=$(docker exec -it earth_jupyter jupyter notebook list)
  echo "${SERVER}" | grep '/notebook' | sed -E 's/^.*=([a-z0-9]+).*$/\1/'
}

case $1 in
  token )
  token
    ;;

  * )
  printf "ERROR: Missing command\n  Usage: `basename $0` (start|stop|cleanup|token|logs|update|superset-start|superset-stop|superset-init)\n"
  exit 1
    ;;
esac