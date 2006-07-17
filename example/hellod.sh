#!/bin/sh
# The hello daemon

trap 'exit' 1
while :
do
    if test -f /tmp/hello -a ! -f /tmp/world; then
	touch /tmp/world
    elif test ! -f /tmp/hello -a -f /tmp/world; then
        rm -f /tmp/world
    fi
    sleep 5
done
