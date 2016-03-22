#!/bin/bash
set -e

#!/bin/bash
set -e

if [[ "$1" == "harpoon" && "$2" == "start" ]]; then
  status=`harpoon inspect $BITNAMI_APP_NAME`
  if [[ "$status" == *'"lifecycle": "unpacked"'* ]]; then
    harpoon initialize $BITNAMI_APP_NAME --password ${MARIADB_PASSWORD:-password}

    ## disable DNS lookups
    # this should happen in harpoon initialize, controlled by a argument, eg. --skip-name-resolve
    (
      echo ""
      echo "[mysqld]"
      echo "skip-name-resolve"
    ) >> $BITNAMI_APP_DIR/conf/my.cnf
  fi

  chown -R $BITNAMI_APP_USER: $BITNAMI_APP_DIR/data || true
fi

exec /entrypoint.sh "$@"
