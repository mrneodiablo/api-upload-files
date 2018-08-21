#!/usr/bin/env bash

set -e

# ======config for app=====
PORT=80
PROCESS=4
THREADS=2
PROJECT_DIR=`pwd`/..
LOG_FILE_WEB=${PROJECT_DIR}"/logs/uwsgi_web.log"
LOG_FILE_DEAMON=${PROJECT_DIR}"/logs/uwsgi_deamon.log"

# ======end for app========

DAEMON=`which uwsgi`
#CONFIG="uwsgi_webapp.ini"
DESC="start_web_app"
NAME="uwsgi_web"



[[ -x $DAEMON ]] || exit 0


do_pid_check()
{
    local PIDFILE=$1
    [[ -f $PIDFILE ]] || return 0
    local PID=$(cat $PIDFILE)
    for p in $(pgrep $NAME); do
        [[ $p == $PID ]] && return 1
    done
    return 0
}


do_start()
{
    local PIDFILE=${PROJECT_DIR}/run/uwsgi_web.pid
    local START_OPTS="--http=0.0.0.0:${PORT} --module=main.wsgi:application --processes=${PROCESS}  --threads=${THREADS}  --master  --enable-threads --pidfile=${PIDFILE}  --logto=${LOG_FILE_DEAMON} --daemonize=${LOG_FILE_WEB}"

    if do_pid_check $PIDFILE; then
        cd ${PROJECT_DIR}
        $DAEMON $START_OPTS
    else
        echo "Already running!"
    fi
}

send_sig()
{

    local PIDFILE=${PROJECT_DIR}/run/uwsgi_web.pid
    set +e
    [[ -f $PIDFILE ]] && kill $1 $(cat $PIDFILE) > /dev/null 2>&1
    set -e
}

wait_and_clean_pidfile()
{
    local PIDFILE=${PROJECT_DIR}/run/uwsgi_web.pid
    until do_pid_check $PIDFILE; do
        echo -n "";
    done
    rm -f $PIDFILE
}

do_stop()
{
    send_sig -3
    wait_and_clean_pidfile
}

do_reload()
{
    send_sig -1
}

do_force_reload()
{
    send_sig -15
}

get_status()
{
    send_sig -10
}

case "$1" in
    start)
        echo "Starting $DESC: "
        do_start
        echo "$NAME."
        ;;
    stop)
        echo -n "Stopping $DESC: "
        do_stop
        echo "$NAME."
        ;;
    reload)
        echo -n "Reloading $DESC: "
        do_reload
        echo "$NAME."
        ;;
    force-reload)
        echo -n "Force-reloading $DESC: "
        do_force_reload
        echo "$NAME."
       ;;
    restart)
        echo  "Restarting $DESC: "
        do_stop
        sleep 1
        do_start
        echo "$NAME."
        ;;
    status)
        get_status
        ;;
    *)
        N=${PROJECT_DIR}/tool/start_web_app.sh
        echo "Usage: $N {start|stop|restart|reload|force-reload|status}">&2
        exit 1
        ;;
esac
exit 0