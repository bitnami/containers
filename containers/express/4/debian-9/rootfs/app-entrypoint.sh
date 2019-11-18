#!/bin/bash -e

. /opt/bitnami/base/functions
. /opt/bitnami/base/helpers

print_welcome_page
#!/bin/bash

. /opt/bitnami/express/functions

if [ "$1" = npm ] && [ "$2" = "start" -o "$2" = "run" ]; then
  bootstrap_express_app

  add_dockerfile

  install_packages

  wait_for_db

  if ! fresh_container; then
    echo "#########################################################################"
    echo "                                                                       "
    echo " App initialization skipped:"
    echo " Delete the file $INIT_SEM and restart the container to reinitialize"
    echo " You can alternatively run specific commands using docker-compose exec"
    echo " e.g docker-compose exec myapp npm install angular"
    echo "                                                                       "
    echo "#########################################################################"
  else
    # Perform any app initialization tasks here.
    log "Initialization finished"
  fi

  migrate_db

  touch "$INIT_SEM"
fi


exec tini -- "$@"
