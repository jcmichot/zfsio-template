#!/bin/sh

FILE="/var/tmp/zpooliostat.info.lines"

discovery() {

        zfsdata=$(zpool list -vH | awk '{ print $1 }' |  uniq | grep -Ev '^(mirror|raidz[1-3]|spare|cd[0-9])')

        echo '{"data":['
        first=1
        for zfs in $zfsdata; do

# Avoid FreeBSD USB disk or cd/dvd
#
#        if echo "$zfs" | grep -Eq '^da[0-9]'; then
#                continue
#        fi

            if [ $first -eq 0 ]; then
                echo ','
            fi
            echo "{\"{#ZFSSTATS}\":\"$zfs\"}"
            first=0
        done

        echo ']}'
}

stat() {
        pattern=$(echo "$1" | sed 's/_/ /g')
        cat "$FILE" | sed 's/_/ /g' | grep "$pattern " | awk '{print $NF}'
}

case "$1" in
    discovery)
        discovery
        ;;
    stat)
        stat "$2"
        ;;
    *)
        echo "Usage: $0 {discovery|stat}"
        exit 1
        ;;
esac


exit 0;
