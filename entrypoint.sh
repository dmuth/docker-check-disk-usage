#!/bin/sh
#
# This script checks our used disk space, and if it is over a percentage, 
# fires off an alert to Slack.
#

# Errors are fatal
set -e


#
# Keep track of our state
#
STATE=""
#STATE="danger" # Debugging to test to the All Clear message


#
# Get our total and used bytes
#
TOTAL=$(df -B 1 | grep ^overlay | awk '{ print $2 }')
USED=$(df -B 1 | grep ^overlay | awk '{ print $3 }')


#
# Calculate ther percentage of disk space used
#
MATH="scale=2; pct=$USED / $TOTAL * 100; scale=0; pct / 1"
PCT=$(echo "$MATH" | bc )


#
# Loop and check our disk free percentage
#
while true
do


	if test $PCT -gt $MAX_PCT
	then

		MESSAGE="Disk usage of ${PCT}% is >= warning threshold of ${MAX_PCT}%"
		echo "# ${MESSAGE}"

		if test ! "${STATE}"
		then
			DATA="{ \"attachments\": [{ \"text\": \"${MESSAGE}\", \"color\": \"danger\" }] }"
			curl -X POST -H 'Content-type: application/json' --data "$DATA" $WEBHOOK

			#
			# Set this after our message has been successfully sent off to Slack.
			#
			STATE="danger"

		else
			echo "# State is already set to '${STATE}', not sending a duplicate message."
		fi

	else
		MESSAGE="All clear!  Disk usage of ${PCT}% is under our threshold of ${MAX_PCT}%!"
		echo "# ${MESSAGE}"

		if test "${STATE}"
		then
			DATA="{ \"attachments\": [{ \"text\": \"${MESSAGE}\", \"color\": \"good\" }] }"
			curl -X POST -H 'Content-type: application/json' --data "$DATA" $WEBHOOK

		else
			echo "# State was already set to empty, not sending another All Clear message."

		fi

		STATE=""

	fi



	echo "Now sleeping for ${INTERVAL} seconds..."
	sleep $INTERVAL

done

