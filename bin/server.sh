#!/bin/bash
HOME="$(cd `dirname "${BASH_SOURCE-$0}"`/..; pwd)"
PID_FILE=pid.log

for d in logs upload thumbnail
do
    DIR=$HOME/$d
    if [ ! -d $DIR ]; then
        mkdir $DIR
    fi
done

start() {
    nginx -p $HOME/ -c conf/nginx.conf
    if [ $? -eq 0 ]; then
        echo "server is started!"
        echo $! > $PID_FILE
    else
        echo "start server failed: $?"
    fi
}

stop() {
    if [ ! -f $PID_FILE ]; then
        echo "server is not started!"
        return
    fi
    nginx -p $HOME/ -c conf/nginx.conf -s stop
    rm $PID_FILE
    echo "server is stopped!"
}

restart() {
    if [ -f $PID_FILE ]; then
        echo "server is running, just reload it!"
        nginx -p $HOME/ -c conf/nginx.conf -s reload
        return
    fi

    stop
    start
}

case "$1" in
    start|stop|restart)
        $1
        ;;
    *)
        echo "Usage: $0 {start|stop|restart}"
        exit 2
esac