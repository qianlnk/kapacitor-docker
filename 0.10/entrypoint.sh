#!/bin/bash
set -e

if [ "${1:0:1}" = '-' ]; then
    set -- kapacitord "$@"
fi

if [ "$1" = 'kapacitord' ]; then
    set -- "$@"
fi

if [ "$( echo $@ | grep "\-config /etc/kapacitor/kapacitor.conf")" != "" ]; then
    # Print the config file without the comments
    separatorLine="-------------------------------------------------"
    echo -e $separatorLine'\n'"Using Default Config"'\n'$separatorLine
    sed -e  's/^\ *#.*//' /etc/kapacitor/kapacitor.conf | awk '{if (NF > 0) print $0}'
    echo $separatorLine
fi

exec "$@"