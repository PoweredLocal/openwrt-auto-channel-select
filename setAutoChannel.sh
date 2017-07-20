#!/bin/ash

# Basic Wi-Fi auto channel selector by PoweredLocal
# (c) 2017 PoweredLocal, Melbourne, Australia
# https://www.poweredlocal.com
#
# Denis Mysenko 20/07/2017

# Config
TEST_INTERVAL=5
ITERATIONS=3

# No need to touch anything below, in most cases
if [[ -z $1 ]]; then
  echo "# Basic Wi-Fi auto channel selector by PoweredLocal"
  echo $0 [interface index]
  exit 1
fi

INTERFACE_INDEX=$1
SIGNAL=NO

scan() {
 /usr/sbin/iw wlan${INTERFACE_INDEX} scan | grep -E "primary channel|signal" | {
  while read line
  do
    FIRST=`echo "$line" | awk '{ print $1 }'`
    if [[ "$FIRST" == "signal:" ]]; then
      SIGNAL=`echo $line | awk '{ print ($2 < -60) ? "NO" : $2 }'`
    fi

    if [[ "$FIRST" == "*" -a "$SIGNAL" != "NO" ]]; then
      CHANNEL=`echo "$line" | awk '{ print $4 }'`
      eval "CURRENT_VALUE=CHANNEL_$CHANNEL"
      eval "CURRENT_VALUE=$CURRENT_VALUE"
      SUM=$(( $CURRENT_VALUE + 1 ))
      eval "CHANNEL_${CHANNEL}=$SUM"
    fi
  done

  echo $CHANNEL_1 $CHANNEL_6 $CHANNEL_11
 }
}

for ITERATION in $(seq 1 1 $ITERATIONS)
do
  [[ -n $DEBUG ]] && echo Iteration $ITERATION
  RESULT=$(scan)
  eval "RESULT_${ITERATION}_1=`echo $RESULT | awk '{ print $1 }'`"
  eval "RESULT_${ITERATION}_6=`echo $RESULT | awk '{ print $2 }'`"
  eval "RESULT_${ITERATION}_11=`echo $RESULT | awk '{ print $3 }'`"
  [[ $ITERATION -lt $ITERATIONS ]] && sleep $TEST_INTERVAL
done

for ITERATION in $(seq 1 1 $ITERATIONS)
do
  for CHANNEL in 1 6 11
  do
    eval "CURRENT_VALUE=RESULT_${ITERATION}_${CHANNEL}"
    eval "CURRENT_VALUE=$CURRENT_VALUE"
    eval "CURRENT_AVG=AVG_$CHANNEL"
    eval "CURRENT_AVG=$CURRENT_AVG"
    eval "AVG_$CHANNEL=$(( ($CURRENT_AVG + $CURRENT_VALUE + 1) / 2 ))"

    [[ $ITERATION -eq $ITERATIONS -a -n $DEBUG ]] && echo Channel $CHANNEL has an average of $(( ($CURRENT_AVG + $CURRENT_VALUE + 1) / 2 )) networks
  done
done

if [ $AVG_1 -le $AVG_6 -a $AVG_1 -le $AVG_11 ]; then
  CHANNEL=1
elif [ $AVG_6 -le $AVG_1 -a $AVG_6 -le $AVG_11 ]; then
  CHANNEL=6
elif [ $AVG_11 -le $AVG_1 -a $AVG_11 -le $AVG_6 ]; then
  CHANNEL=11
fi

if [[ -n "$CHANNEL" ]]; then
  echo Setting channel to $CHANNEL
  /sbin/uci set wireless.radio${INTERFACE_INDEX}.channel="$CHANNEL"
  /sbin/uci commit
fi