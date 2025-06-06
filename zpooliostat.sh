#
# PROVIDE: zpooliostat
# REQUIRE: NETWORKING syslogd DAEMON
# KEYWORD: shutdown
#
# Add the following lines to /etc/rc.conf to enable zpooliostat:
#
#zpooliostat_enable="YES"

. /etc/rc.subr

name="zpooliostat"
rcvar="zpooliostat_enable"

load_rc_config $name

: ${rtl433_user:="root"}
: ${rtl433_enable:="NO"}
: ${rtl433_facility:="daemon"}
: ${rtl433_priority:="debug"}

command="/usr/local/bin/zp.pl"
procname="/usr/local/bin/zp.pl"
#home/jcmichot/bin/${name}"
home="/root"

pidfile="/var/run/${name}.pid"

start_cmd="${name}_start"
stop_cmd="${name}_stop"

zpooliostat_start() {

        ( ${command} 2>&1 ) > /var/tmp/zpooliostat.log &
        pid_start=$! 
        echo $pid_start > $pidfile

}

zpooliostat_stop()
{
        pidstart=`/bin/cat $pidfile`

        parent=`/bin/ps -adp $pidstart "-o pid="`

        echo $parent;

        for pid in $parent
        do
                echo 'kill -9 ' $pid
                kill -9 $pid
        done
}

run_rc_command "$1"
