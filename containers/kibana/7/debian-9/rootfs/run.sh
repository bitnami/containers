#!/bin/bash
# shellcheck disable=SC1090
# shellcheck disable=SC1091

. /opt/bitnami/base/functions
. /opt/bitnami/base/helpers

readonly KIBANA_DAEMON_USER="kibana"
readonly kibana_cmd=$(command -v kibana)
readonly kibana_args=("serve")

cd /opt/bitnami/kibana || exit 1

# Allow running custom initialization scripts
if [[ $(find /docker-entrypoint-initdb.d/ -type f -regex ".*\.sh") != "" ]] &&  [[ ! -f /bitnami/kibana/.user_scripts_initialized || "$KIBANA_FORCE_INITSCRIPTS" == "true" ]]; then
    readonly log_file=/opt/bitnami/kibana/logs/kibana.log
    # If container is started as `root` user
    if [[ "$EUID" -eq 0 ]]; then
        gosu "${KIBANA_DAEMON_USER}" "${kibana_cmd}" "${kibana_args[@]}" > "$log_file" 2>&1 &
    else
        bash -c "${kibana_cmd}" "${kibana_args[@]}" > "$log_file" 2>&1 &
    fi
    kibana_pid="$!"

    if [[ "$KIBANA_FORCE_INITSCRIPTS" == "true" ]]; then
        info "Forcing execution of user files"
    fi
    info "Kibana started with PID ${kibana_pid}. Waiting for it to be started"
    retries="${KIBANA_INITSCRIPTS_MAX_RETRIES:-30}"
    until curl 127.0.0.1:5601/api/status 2>&1 | grep '"overall":{"state":"green"' > /dev/null || [ "$retries" -eq 0 ]; do
        info "Waiting for Kibana server: $((retries--)) remaining attempts..."
        sleep 2
    done
    if [[ "$retries" == 0 ]]; then
        echo "Error: Kibana is not available after ${KIBANA_INITSCRIPTS_MAX_RETRIES:-30} retries"
        exit 1
    fi
    info "Loading user files from /docker-entrypoint-initdb.d"

    readonly tmp_file=/tmp/filelist
    find /docker-entrypoint-initdb.d/ -type f -regex ".*\.sh" > "$tmp_file"
    while read -r f; do
        case "$f" in
            *.sh)
                if [ -x "$f" ]; then
                    echo "Executing $f"; "$f"
                else
                    echo "Sourcing $f"; . "$f"
                fi
                ;;
            *)
                echo "Ignoring $f"
                ;;
        esac
    done < $tmp_file
    rm "$tmp_file"
    touch /bitnami/kibana/.user_scripts_initialized
    echo "Tailing $log_file"
    readonly tail_cmd="$(command -v tail)"
    readonly tail_flags=("--pid=${kibana_pid}" "-n" "1000" "-f" "$log_file")
    if [[ $EUID -eq 0 ]]; then
        exec gosu "${KIBANA_DAEMON_USER}" "${tail_cmd}" "${tail_flags[@]}"
    else
        exec "${tail_cmd}" "${tail_flags[@]}"
    fi
else
    # If container is started as `root` user
    if [[ $EUID -eq 0 ]]; then
        exec gosu "${KIBANA_DAEMON_USER}" "${kibana_cmd}" "${kibana_args[@]}"
    else
        exec "${kibana_cmd}" "${kibana_args[@]}"
    fi
fi