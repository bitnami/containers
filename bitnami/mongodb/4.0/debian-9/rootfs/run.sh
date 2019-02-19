#!/bin/bash
. /opt/bitnami/base/functions
. /opt/bitnami/base/helpers

DAEMON=mongod
USER=mongo
EXEC=$(which $DAEMON)
ARGS="--config /opt/bitnami/mongodb/conf/mongodb.conf"

function mongodbStart {
    # If container is started as `root` user
    if [ $EUID -eq 0 ]; then
        exec gosu ${USER} ${EXEC} ${ARGS}
    else
        exec ${EXEC} ${ARGS}
    fi
}

# configure extra command line flags
if [[ -n $MONGODB_EXTRA_FLAGS ]]; then
    ARGS+=" $MONGODB_EXTRA_FLAGS"
fi

# log output to stdout
sed -i 's/path: .*\/mongodb.log/path: /' /opt/bitnami/mongodb/conf/mongodb.conf

# allow running custom initialization scripts
if [[ -n $(find /docker-entrypoint-initdb.d/ -type f -regex ".*\.\(sh\|js\)") ]] && [[ ! -f /bitnami/mongodb/.user_scripts_initialized ]] ; then
    mongodbStart &
    pidfile="/opt/bitnami/mongodb/tmp/mongodb.pid"
    dbpath="/bitnami/mongodb/data/db"

    # check to see that "mongod" actually did start up
    tries=30
    while true; do
        sleep 1
        if ! { [ -s "$pidfile" ] && ps "$(< "$pidfile")" &> /dev/null; }; then
            # fail ASAP if "mongod" isn't even running
            error "error: ${DAEMON} does not appear to be running -- perhaps it had an error?"
            exit 1
        fi
        if mongo 'admin' --eval 'quit(0)' &> /dev/null; then
            # success!
            break
        fi
        (( tries-- ))
        if [ "$tries" -le 0 ]; then
            error "error: ${DAEMON} does not appear to have accepted connections quickly enough -- perhaps it had an error?"
            exit 1
        fi
        sleep 1
    done

    info "Loading user files from /docker-entrypoint-initdb.d";
    if [[ -n "$MONGODB_ROOT_PASSWORD" ]]; then
        mongo=( mongo admin --username root --password $MONGODB_ROOT_PASSWORD --host localhost --quiet )
    else
        mongo=( mongo admin --host localhost --quiet )
    fi

    tmp_file=/tmp/filelist
    find /docker-entrypoint-initdb.d/ -type f -regex ".*\.\(sh\|js\)" > $tmp_file
    while read -r f; do
        case "$f" in
            *.sh)
                if [ -x "$f" ]; then
                    echo "Executing $f"; "$f"
                else
                    echo "Sourcing $f"; . "$f"
                fi
                ;;
            *.js)   echo "Executing $f"; "${mongo[@]}" "$f"; echo ;;
            *)      echo "Ignoring $f" ;;
        esac
    done < $tmp_file
    rm $tmp_file
    touch /bitnami/mongodb/.user_scripts_initialized
    if ! ${EXEC} --dbpath="$dbpath" --pidfilepath="$pidfile" --shutdown || ! rm -f "$pidfile"; then
        echo >&2 'MongoDB init process failed.'
        exit 1
    fi
fi

info "Starting ${DAEMON}..."
mongodbStart
