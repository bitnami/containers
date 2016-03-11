#!/bin/bash
set -e

print_welcome_page() {
  GITHUB_PAGE=https://github.com/bitnami/bitnami-docker-${BITNAMI_APP_NAME}
cat << EndOfMessage
       ___ _ _                   _
      | _ |_) |_ _ _  __ _ _ __ (_)
      | _ \\ |  _| ' \\/ _\` | '  \\| |
      |___/_|\\__|_|_|\\__,_|_|_|_|_|

  *** Welcome to the ${BITNAMI_APP_NAME} image ***
  *** More information: ${GITHUB_PAGE} ***
  *** Issues: ${GITHUB_PAGE}/issues ***

EndOfMessage
}

check_for_updates() {
  UPDATE_SERVER="https://container.checkforupdates.com"
  ORIGIN=${BITNAMI_CONTAINER_ORIGIN:-DHR}

  RESPONSE=$(curl -s --connect-timeout 20 \
    --cacert /opt/bitnami/updates-ca-cert.pem \
    "$UPDATE_SERVER/api/v1?image=$BITNAMI_APP_NAME&version=$BITNAMI_APP_VERSION&origin=$ORIGIN" \
    -w "|%{http_code}")

  VERSION=$(echo $RESPONSE | cut -d '|' -f 1)
  if [[ ! $VERSION =~ [0-9.-] ]]; then
    return
  fi

  STATUS=$(echo $RESPONSE | cut -d '|' -f 2)

  if [ "$STATUS" = "200" ]; then
    COLOR="\e[0;30;42m"
    MSG="Your container is up to date!"
  elif [ "$STATUS" = "201" ]; then
    COLOR="\e[0;30;43m"
    if [ "x$IS_BITNAMI_STACK" = "x" ] ; then
      MSG="New version available: run docker pull bitnami/$BITNAMI_APP_NAME:$VERSION to update."
    else
      MSG="New version available $BITNAMI_APP_NAME:$VERSION : this all-in-one container is intended for development usage. It does not support automatic upgrades."
    fi
  fi

  if [ "$MSG" ]; then
    printf "\n$COLOR*** $MSG ***\e[0m\n\n"
  fi
}

print_welcome_page
check_for_updates &

if [ "$1" == "harpoon" ]; then
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

  chown -R $BITNAMI_APP_USER: \
    $BITNAMI_APP_DIR/logs \
    $BITNAMI_APP_DIR/conf \
    $BITNAMI_APP_DIR/data || true
fi

exec tini -- $@
