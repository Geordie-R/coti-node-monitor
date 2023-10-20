function get_coti_config_value(){
  global_value=$(grep -v '^#' "$FULL_NODE_PROPERTIES_PATH" | grep "^$1=" | awk -F '=' '{print $2}')
  if [ -z "$global_value" ]
  then
    return 1
  else
    return 0
  fi
}

function get_monitor_config_value(){
  global_value=$(grep -v '^#' "$NODE_MONITOR_PROPERTIES_PATH" | grep "^$1=" | awk -F '=' '{print $2}')
  if [ -z "$global_value" ]
  then
    return 1
  else
    return 0
  fi
}

function remove_double_quotes() {
  local input="$1"
  # Use parameter expansion to remove double quotes
  input="${input//\"/}"
  echo "$input"
}

function sendTelegramMsg(){
  if [ -z "${TELEGRAM_BOT_API_KEY}" ] && [ -z "${TELEGRAM_CHAT_ID}" ]
    then
    echo "Telegram variables not set."
  else
    curl -s -X POST https://api.telegram.org/bot${TELEGRAM_BOT_API_KEY}/sendMessage -d chat_id=$TELEGRAM_CHAT_ID -d text="$1" &>/dev/null
  fi
sleep 1
}

function get_last_index() {
  echo "$(curl -s "https://$1/transaction/lastIndex" | jq -r '.lastIndex')"
}

get_last_10_lines() {
  local file="$1"
  if [ -f "$file" ]; then
echo -e "\n"
    tail -n 10 "$file" | while IFS= read -r line; do
      echo -e "\n$line\n"
    done
  else
    echo "File '$file' not found."
  fi
  }
