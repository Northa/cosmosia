# usage: ./run.sh chain_name
# eg., ./run.sh cosmoshub

chain_name="$1"

if [[ -z $chain_name ]]
then
  echo "No chain_name. usage eg., ./run.sh cosmoshub"
  exit
fi

cd $HOME

pacman -Syu --noconfirm
pacman -S --noconfirm base-devel dnsutils python caddy logrotate screen

echo "read chain info:"
eval "$(curl -s https://raw.githubusercontent.com/notional-labs/cosmosia/main/data/chain_registry.ini |awk -v TARGET=$chain_name -F ' = ' '
  {
    if ($0 ~ /^\[.*\]$/) {
      gsub(/^\[|\]$/, "", $0)
      SECTION=$0
    } else if (($2 != "") && (SECTION==TARGET)) {
      print $1 "=" $2
    }
  }
  ')"

echo "json_rpc=$json_rpc"

########################################################################################################################
# dynamic upstream

CONFIG_FILE="/etc/caddy/Caddyfile"
TMP_CONFIG_FILE="/etc/caddy/Caddyfile.tmp"

# functions
generate_new_upstream_config () {
  # use dig to figure out IPs of service
  new_ips=$(dig +short "tasks.$chain_name" |sort)

  rpc_str=""
  api_str=""
  ws_str=""
  grpc_str=""
  jsonrpc_str=""
  if [[ -z "$new_ips" ]]; then
      rpc_str="to http://$chain_name"
      api_str="to http://$chain_name:1317"
      ws_str="to http://$chain_name"
      grpc_str="to http://$chain_name:9090"
      jsonrpc_str="to http://$chain_name:8545"
  else
    while read -r ip_addr || [[ -n $ip_addr ]]; do
        if [[ -z "$rpc_str" ]]; then
          rpc_str="to"
          api_str="to"
          ws_str="to"
          grpc_str="to"
          jsonrpc_str="to"
        fi
        rpc_str="$rpc_str http://$ip_addr"
        api_str="$api_str http://$ip_addr:1317"
        ws_str="$ws_str http://$ip_addr"
        grpc_str="$grpc_str h2c://$ip_addr:9090"
        jsonrpc_str="$jsonrpc_str http://$ip_addr:8545"
    done < <(echo "$new_ips")
  fi


JSONRPC_CONFIG=""

if [[ $json_rpc == "true" ]]; then
  JSONRPC_CONFIG=$( cat <<EOT
#JSON-RPC
:8004 {
  reverse_proxy {
    $jsonrpc_str
    health_uri      /healthcheck
    health_port     80
    health_interval 30s
    health_timeout  30s
  }
}
EOT
  )
fi

cat <<EOT > $TMP_CONFIG_FILE
# This file is generated dynamically, dont edit.

{
  admin :2019
	servers {
		protocol {
		  	allow_h2c
		}
	}
}

# RPC
http://:8000 {
  reverse_proxy /* {
    $rpc_str
    health_uri      /healthcheck
    health_port     80
    health_interval 30s
    health_timeout  30s
  }
}

#API
http://:8001 {
  reverse_proxy /* {
    $api_str
    health_uri      /healthcheck
    health_port     80
    health_interval 30s
    health_timeout  30s
  }
}

#WS
http://:8002 {
  rewrite * /websocket
    reverse_proxy {
      $ws_str
      health_uri      /healthcheck
      health_port     80
      health_interval 30s
      health_timeout  30s
  }
}

#gRPC
:8003 {
  reverse_proxy {
    $grpc_str
    health_uri      /healthcheck
    health_port     80
    health_interval 30s
    health_timeout  30s
  }
}

$JSONRPC_CONFIG
EOT

}

########################################################################################################################
# caddy

# generate new config file and copy to $CONFIG_FILE
generate_new_upstream_config
cat $TMP_CONFIG_FILE > $CONFIG_FILE

screen -S caddy -dm /usr/sbin/caddy run --config $CONFIG_FILE
sleep 5

########################################################################################################################
## logrotate



########################################################################################################################
# big loop

sleep 60

while true; do
  generate_new_upstream_config

  if cmp -s "$CONFIG_FILE" "$TMP_CONFIG_FILE"; then
    # the same => do nothing
    echo "no config change, do nothing..."
  else
    # different => show the diff
    diff -c "$CONFIG_FILE" "$TMP_CONFIG_FILE"

    echo "found config changes, updating..."
    cat $TMP_CONFIG_FILE > $CONFIG_FILE

#    # need to use cron job for logrotate?
#    logrotate /etc/logrotate.d/caddy

    /usr/sbin/caddy reload --config $CONFIG_FILE
  fi

  # sleep 300 seconds...
  sleep 300
done
