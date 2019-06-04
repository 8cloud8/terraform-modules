#!/usr/bin/env bash

set -e

action="${1}"

main(){

  for bin in docker nc psql;do which $bin &>/dev/null || (echo $bin not found; exit); done

  local DOCKER="postgres"
  local VERSION="10.6"
  local PGHOST="${PGHOST:-0.0.0.0}"
  local PGPORT="${PGPORT:-5432}"
  local PGDATABASE="${PGDATABASE:-postgres}"
  local PGUSER="${PGUSER:-admin}"
  local PGPASSWORD="${PGPASSWORD:-admin123456}"

  case "$action" in

    create-db)
      if [ "$(docker inspect -f '{{.State.Running}}' "$DOCKER" 2>/dev/null)" != 'true' ];
      then
        docker pull ${DOCKER}:${VERSION}
        docker volume create "${DOCKER}"-data
        docker run -it -d \
            --label "$DOCKER" \
            --name "$DOCKER" \
            --rm \
            -e LANG=en_US.UTF-8 \
            -e POSTGRES_PASSWORD="${PGPASSWORD}" \
            -e POSTGRES_USER="${PGUSER}" \
            -p "${PGPORT}":5432 \
            -v "${DOCKER}"-data:/var/lib/postgresql/data \
          ${DOCKER}:${VERSION}

        while ! docker inspect --format='{{.State.Running}}' $DOCKER; do sleep 1; done
        while ! nc -z "${PGHOST}" "${PGPORT}"; do sleep 1; done
        docker exec -it $DOCKER localedef -i da_DK -c -f UTF-8 -A /usr/share/locale/locale.alias da_DK.UTF-8
        sleep 1
      fi
      ;;

    pg_settings)
        echo "SELECT name, setting, boot_val, reset_val, unit FROM pg_settings ORDER by name;" \
          | PGPORT=${PGPORT} PGHOST=${PGHOST} PGDATABASE=${PGDATABASE} PGUSER=${PGUSER} PGPASSWORD=${PGPASSWORD} psql -v ON_ERROR_STOP=1 -tAe;
        ;;

    pg_extensions)
        echo "SELECT * FROM pg_extension;" \
          | PGPORT=${PGPORT} PGHOST=${PGHOST} PGDATABASE=${PGDATABASE} PGUSER=${PGUSER} PGPASSWORD=${PGPASSWORD} psql -v ON_ERROR_STOP=1 -tAe;
      ;;

    pg_available_extensions)
        echo "SELECT * FROM pg_available_extensions;" \
          | PGPORT=${PGPORT} PGHOST=${PGHOST} PGDATABASE=${PGDATABASE} PGUSER=${PGUSER} PGPASSWORD=${PGPASSWORD} psql -v ON_ERROR_STOP=1 -tAe;
      ;;

    pg_stat_activity)
       echo "SELECT * FROM pg_stat_activity ORDER BY pid;" \
          | PGPORT=${PGPORT} PGHOST=${PGHOST} PGDATABASE=${PGDATABASE} PGUSER=${PGUSER} PGPASSWORD=${PGPASSWORD} psql -v ON_ERROR_STOP=1 -tAe;
      ;;

    pg_database_size)
      echo "SELECT pg_database.datname, pg_database_size(pg_database.datname), pg_size_pretty(pg_database_size(pg_database.datname)) FROM pg_database ORDER BY pg_database_size DESC;" \
          | PGPORT=${PGPORT} PGHOST=${PGHOST} PGDATABASE=${PGDATABASE} PGUSER=${PGUSER} PGPASSWORD=${PGPASSWORD} psql -v ON_ERROR_STOP=1 -tAe;
    ;;

    pg_shell)
        PGPORT=${PGPORT} PGHOST=${PGHOST} PGDATABASE=${PGDATABASE} PGUSER=${PGUSER} PGPASSWORD=${PGPASSWORD} psql
      ;;

    shell)
      if [ "$(docker inspect --format='{{.State.Running}}' $DOCKER)" ];then
        docker exec -it ${DOCKER} bash
      fi
      ;;

    clean-db)
      echo "Cleaning up ..."
      docker stop ${DOCKER} 2>/dev/null
      docker volume rm "${DOCKER}"-data 2>/dev/null
      ;;

    *)
      echo "Doing nothing here ..."
      ;;

  esac

}

main "$@"
