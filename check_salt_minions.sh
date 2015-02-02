#!/bin/sh

# Written by Jan Scheufler in late 2014
# Feel free to share, modify and improve

OK=0
UNKNOWN=0
WARNING=0
CRITICAL=0

# get all unresponsive minions
OUTPUT=`/usr/bin/sudo /usr/bin/salt-run manage.down`
# store return code
EC1=$?

# replace all new lines in the output with commas
OUTPUT="${OUTPUT//$'\n'/, }"

# OK - if return code 0 AND output empty
if [ $EC1 -eq 0 ] && [ -z "$OUTPUT" ]; then
        echo "OK - all known salt minions report for duty"
        ((OK++))
# CRITICAL - if return code 0 AND output not empty
elif [ $EC1 -eq 0 ] && [ ! -z "$OUTPUT" ]; then
        echo "CRITICAL - the following minion(s) do(es) not report for duty: $OUTPUT"
        ((CRITICAL++))
# CRITICAL - if return code not 0
elif [ $EC1 -ne 0 ]; then
        echo "CRITICAL - the command used to check for unresponsive minions failed"
        ((CRITICAL++))
# UNKOWN - if none ob the above match, something is wrong
else
        echo "UNKOWN - I don't even want to know how you got here; something is REALLY wrong"
        ((UNKNOWN++))
fi

# set exit code of the script
if [ $CRITICAL -gt 0 ]; then
        exit 2
elif [ $UNKNOWN -gt 0 ]; then
        exit 3
else
        exit 0
fi
