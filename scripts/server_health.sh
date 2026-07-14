

#!/bin/bash

#===========================================================================

# TechCore Infrastructure Monitor

# Server Health Monitor Dashboard

#===========================================================================

# 1.Project Parts
#-------------------------------------------------------------
SCRIPT_DIR="$(cd "$(dirname "$0")"&& pwd)"

PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

TEMPLATE_FILE="$PROJECT_DIR/templates/dashboard.html"

CSS_FILE="$PROJECT_DIR/css/style.css"

FINAL_CSS_FILE="/var/www/html/css/style.css"

TMP_FILE="/tmp/status.html"

FINAL_FILE="/var/www/html/status.html"

# 2.Basic System Information
#-------------------------------------------------------------
HOSTNAME=$(hostname)

IP_ADDRESS=$(hostname -I | awk '{print$1}')

UPTIME=$(uptime -p | sed 's/^up //' )

CPU_CORES=$(nproc)

# 3.Resource Monitoring
#-------------------------------------------------------------
CPU_IDLE=$(top -bn1 | grep "Cpu" | awk '{print $8}')

CPU_USAGE=$(awk "BEGIN {printf \"%.0f\", 100-$CPU_IDLE}")

MEMORY_USAGE=$(free -h | awk '/^Mem:/ {print $3 " / " $2}')

DISK_USAGE=$(df -h / | awk 'NR==2 {print $3 "/" $2 "("$5")"}')

DISK_PERCENTAGE=$(df -h | awk 'NR==3 {gsub ("%" ,"", $5) ;print $5}')

LOAD_1MIN=$(awk '{print $1'} /proc/loadavg)

LOAD_5MIN=$(awk '{print $2'} /proc/loadavg)

LOAD_15MIN=$(awk '{print $3'} /proc/loadavg)

LOAD_STATUS=$(awk -v Sload=$"$LOAD_1MIN" -v cores="$CPU_CORES" '
BEGIN {
	if ( Sload < cores )
	 print "Healthy"
	else if ( Sload == cores )
	 print "Busy"
	else
	 print "High Load"
}'
)

LOAD_CLASS=$(if [ "$LOAD_STATUS" = "Healthy" ];
		then echo "status-green"
	elif [ "$LOAD_STATUS" = "Busy" ];
		then echo "status-yellow"
	else
		echo "status-red"
fi
)

# 4.Service Monitoring
#--------------------------------------------------------------
SSH_STATUS=$(systemctl is-active ssh)

SSH_CLASS=$(if [ "$SSH_STATUS" = "active" ];
		then echo "status-green"
	else echo "status-red"
fi
)

NGINX_STATUS=$(systemctl is-active nginx)

NGINX_CLASS=$(if [ "$NGINX_STATUS" = "active" ];
		then echo "status-green"
	else echo "status-red"
fi
)

# 5.Network Monitoring
#----------------------------------------------------------------
NETWORK_STATUS=$(
if ping -c 1 8.8.8.8 >/dev/null 2>&1
then
	echo "Connected"
else
	echo "Disconnected"
fi
)

NETWORK_CLASS=$(if [ "$NETWORK_STATUS" = "Connected" ];
		then echo "status-green"
	else echo "status-red"
fi
)

# 6.Overall Health Evaluaction
#-----------------------------------------------------------------
OVERALL_HEALTH=$(
if [ "$LOAD_STATUS" = "Healthy" ] &&  [ "$DISK_PERCENTAGE" -lt 80 ] &&
[ "$SSH_STATUS" = "active" ] && [ "$NGINX_STATUS" = "active" ] && [ "$NETWORK_STATUS" = "Connected" ]
then
	echo "Healthy"
else
	echo "Attention Required"
fi
)

HEALTH_CLASS=$(if [ "$OVERALL_HEALTH" = "Healthy" ];then echo "status-green"
else echo "status-red"
fi
)

# 7.Dashboard Metadata
#-----------------------------------------------------------------
LAST_UPDATED=$(date '+%d-%m-%Y %H:%M:%S')

# 8.Load HTML Template
#-----------------------------------------------------------------
HTML_TEMPLATE=$(cat "$TEMPLATE_FILE")

# 9.Replace Template Variable
#-----------------------------------------------------------------
HTML_TEMPLATE=$(echo "$HTML_TEMPLATE" | sed \
-e "s|\$HOSTNAME|$HOSTNAME|g" \
-e "s|\$IP_ADDRESS|$IP_ADDRESS|g" \
-e "s|\$CPU_USAGE|$CPU_USAGE|g" \
-e "s|\$MEMORY_USAGE|$MEMORY_USAGE|g" \
-e "s|\$DISK_USAGE|$DISK_USAGE|g" \
-e "s|\$DISK_PERCENTAGE|$DISK_PERCENTAGE|g" \
-e "s|\$SSH_STATUS|$SSH_STATUS|g" \
-e "s|\$NGINX_STATUS|$NGINX_STATUS|g" \
-e "s|\$HEALTH_CLASS|$HEALTH_CLASS|g" \
-e "s|\$NETWORK_CLASS|$NETWORK_CLASS|g" \
-e "s|\$NETWORK_STATUS|$NETWORK_STATUS |g" \
-e "s|\$NGINX_CLASS|$NGINX_CLASS |g" \
-e "s|\$SSH_CLASS|$SSH_CLASS|g" \
-e "s|\$UPTIME|$UPTIME|g" \
-e "s|\$OVERALL_HEALTH|$OVERALL_HEALTH|g" \
-e "s|\$LOAD_1MIN|$LOAD_1MIN|g" \
-e "s|\$LOAD_5MIN|$LOAD_5MIN|g" \
-e "s|\$LOAD_15MIN|$LOAD_15MIN|g" \
-e "s|\$LOAD_STATUS|$LOAD_STATUS|g" \
-e "s|\$LOAD_CLASS|$LOAD_CLASS|g" \
-e "s|\$LAST_UPDATED|$LAST_UPDATED|g")

# 10.Generate Temporary HTML
#-----------------------------------------------------------------
echo "$HTML_TEMPLATE" > "$TMP_FILE"

# 11.Deploy Dasnboard
#-----------------------------------------------------------------

sudo cp "$CSS_FILE" "$FINAL_CSS_FILE"

sudo mv "$TMP_FILE" "$FINAL_FILE"

# 12.Terminal Verfication Output
#-----------------------------------------------------------------
echo "Techcore Server Health Dashboard"
echo
echo "Hostname    : $HOSTNAME"
echo "IP Address  : $IP_ADDRESS"
echo "Uptime      : $UPTIME"
echo "CPU Cores   : $CPU_CORES"
echo "Load Average: $LOAD_1MIN, $LOAD_5MIN, $LOAD_15MIN"
echo "Load Status : $LOAD_STATUS"
echo
echo "===== Resources ====="
echo "CPU USAGE   : $CPU_USAGE"%
echo "Memory Usage: $MEMORY_USAGE"
echo "Disk Usage  : $DISK_USAGE"
echo "Disk Percentage: $DISK_PERCENTAGE"
echo
echo "===== Services ====="
echo "SSH Status  : $SSH_STATUS"
echo "NGINX Status: $NGINX_STATUS"
echo
echo "===== Network ====="
echo "Network Status:$NETWORK_STATUS"
echo
echo "======Overall Health====="
echo "Health Status: $OVERALL_HEALTH"
echo
echo "Last Updated: $LAST_UPDATED"




