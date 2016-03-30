#!/bin/bash
set -e

if [ "${1:0:1}" = '-' ]; then
    set -- kapacitord "$@"
fi

if [ "$1" = 'kapacitord' ]; then
    set -- "$@"
fi

exec "$@"
