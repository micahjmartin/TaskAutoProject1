# Launches all of the given programs
# Author: Micah Martin
# Task Auto mini project 1

function launch_programs() {
    # Launch all of the needed programs for APM to monitor
    programs="APM1 APM2 APM3 APM4 APM5 APM6"
    ip=`ifconfig | grep "eth3" -A 1 | tail -n 1 | awk '{print $2}'`
    echo "[*] Spawning processes...."
    for prog in $programs; do
        ./$prog $ip &>/dev/null & 
        pid=$!
        echo "[+] Launched command: '$prog $ip' as PID $pid"
        PIDS="$PIDS $pid"
    done
}

function cleanup() {
    echo " [*] Cleaning up spawned processes and exiting...."
    echo -n "[+] Killed process"
    for pid in $PIDS; do
        kill -9 $pid
        echo -n " $pid"
    done
    echo ""
    exit
}

function main() {
    while [ 1 ]; do
        sleep 5
        echo "[*] Sleeping for 5 seconds"
    done
}

trap cleanup INT
launch_programs
main
cleanup