#!/bin/bash
source coti-node-functions.sh
# Variables #############
FULL_NODE_PROPERTIES_PATH="/home/coti/coti-node/fullnode.properties"
NODE_MONITOR_PROPERTIES_PATH="/home/coti/coti-node-monitor/coti-node-monitor.properties"
INDEX_COMPARE_URL="testnet-financialserver.coti.io"
###########################
# Randomise a sleep to protect the node manager from too many requests at the same time
# Generate a random number between 1 and 100
random_seconds=$((1 + RANDOM % 5))

echo "Pausing for $random_seconds seconds..."
sleep $random_seconds
echo "Resuming after sleep..."
#########################


if get_coti_config_value "network"
then
NETWORK="$global_value" 
fi

if get_monitor_config_value "TELEGRAM_CHAT_ID"
then
TELEGRAM_CHAT_ID="$(remove_double_quotes "$global_value")"
fi


if get_monitor_config_value "TELEGRAM_BOT_API_KEY"
then
TELEGRAM_BOT_API_KEY=$(remove_double_quotes "$global_value") 
fi


echo "NETWORK is set to ${NETWORK}"
echo "Check node status and restart if necessary"
echo "Performing status check:" $(date '+%A %d %m %Y %X')

HTTP_CODE=$(curl -o /dev/null -s -w '%{http_code}\n' https://${NETWORK}-nodemanager.coti.io/nodes)


if get_coti_config_value "server.url"
then
SERVERNAME=$(echo "$global_value" | sed -E 's/^\s*.*:\/\///g')
fi

if get_monitor_config_value "UNSYNC_TOLERANCE"
then
UNSYNC_TOLERANCE=$(remove_double_quotes "$global_value")  
fi


Restart="false"

#Check if the index on your node is within a threshold of acceptable difference
MyLastIndex=$(get_last_index ${SERVERNAME})
TheirLastIndex=$(get_last_index $INDEX_COMPARE_URL)
echo "My/Their Node Index: $MyLastIndex/$TheirLastIndex"


if [ -n "$MyLastIndex" ] && [ -n "$TheirLastIndex" ]; then
  Index_Diff=$(($MyLastIndex - $TheirLastIndex))
  if [ $Index_Diff -le $UNSYNC_TOLERANCE ]; then
    echo "✅ Node is synced (difference=$Index_Diff)."
  else
    sendTelegramMsg "❌ ${SERVERNAME} Node is unsync.  Index difference is $Index_Diff"
    echo "Node is unsynced (difference=$Index_Diff). Performing restart."
    Restart="true" #CHANGE TO TRUE
  fi
else
  echo "One or both of the variables (MyLastIndex or TheirLastIndex) is empty. Unable to perform the comparison."
fi


#Check if your node is part of the nodemanagers list
if [ "$HTTP_CODE" == "200" ]; then
    if curl -s https://${NETWORK}-nodemanager.coti.io/nodes | grep -q ${SERVERNAME}; then
        echo  "✅ ${SERVERNAME} - $NETWORK - Node Found"
    else
        echo  "❌ ${SERVERNAME} - $NETWORK - Node not found."
        Restart="true"
    fi

elif [ "$HTTP_CODE" == "000" ]; then
#No reporting of 000 status
echo "Http code is 000. Taking no action"
else
    echo "Node manager returned unusual status code:" $HTTP_CODE
   # sendTelegramMsg "${SERVERNAME} Node manager returned unusual status code: $HTTP_CODE"
fi


if [ "$Restart" == "true" ]; then
  echo "⛔ Restarting Node! ⛔"

  # Usage: get_last_10_lines <filename>
    lines=$(get_last_10_lines "/home/coti/coti-node/logs/FullNode1.log")
  sendTelegramMsg "⛔ ${SERVERNAME} is being restarted on ${NETWORK}! Node manager returned status code: $HTTP_CODE. Last 10 lines of log: $lines"

  systemctl restart cnode.service
else
  echo "✅ No Restart Needed"
fi
