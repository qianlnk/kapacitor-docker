#!/bin/bash
set -e

if [ "${1:0:1}" = '-' ]; then
    set -- kapacitord "$@"
fi

# TODO remove -config from this for 0.13 (leaving -log-file only)
if [ "$1" = 'kapacitord' ]; then
    shift
    set -- kapacitord -config /etc/kapacitor/kapacitor.conf -log-file STDERR "$@"
fi

exec "$@"
