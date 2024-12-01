#!/bin/bash

# PASS_KEY_NAME=p/cloudflare/maketh-dev-edit-zone-token # I used pass to store all my credentials hence.

# API_TOKEN=$(pass show $PASS_KEY_NAME | head -n 1) # CloudFlare API Token
# ZONE_ID=$(pass show $PASS_KEY_NAME | grep '^ZONE_ID=' | head -n 1 | sed 's/^ZONE_ID=//') # CloudFlare Zone ID
# DNS_RECORD_ID=$(pass show $PASS_KEY_NAME | grep '^DNS_RECORD_ID=' | head -n 1 | sed 's/^DNS_RECORD_ID=//') # CloudFlare DNS Record ID
# DNS_RECORD_NAME=$(pass show $PASS_KEY_NAME | grep '^DNS_RECORD_NAME=' | head -n 1 | sed 's/^DNS_RECORD_NAME=//')
TTL=1 # automatic
source ./variables
CACHE_FILE="/tmp/last_public_ip_${DNS_RECORD_ID}.txt"

# Get Public IP Address
PUBLIC_IP=$(curl -s https://api.ipify.org)

if [ -z "$PUBLIC_IP" ]; then
	echo "Failed to fetch Public IP Address"
	exit 1
fi

echo "Public IP: $PUBLIC_IP"

# Get Last Public IP
if [ -f "$CACHE_FILE" ]; then
	LAST_PUBLIC_IP=$(cat $CACHE_FILE)
	if [ "$PUBLIC_IP" == "$LAST_PUBLIC_IP" ]; then
		echo "Public IP hasn't changed. (Cached)"
		echo "> To clear cache simply rm $CACHE_FILE"
		exit 0
	fi
fi

echo "Updating IP Address for $DNS_RECORD_NAME to $PUBLIC_IP."

# Update DNS Records to CloudFlare
# REF: https://developers.cloudflare.com/api/operations/dns-records-for-a-zone-update-dns-record
RESPONSE=$(curl -s -X PUT "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records/$DNS_RECORD_ID" \
	-H "Authorization: Bearer $API_TOKEN" \
	-H "Content-Type: application/json" \
	--data "{\"type\":\"A\",\"name\":\"$DNS_RECORD_NAME\",\"content\":\"$PUBLIC_IP\",\"ttl\":$TTL,\"proxied\":false,\"comment\":\"updated by crontab\"}")

# Check response
if echo "$RESPONSE" | grep -q '"success":true'; then
  echo "DNS record updated successfully!"
  echo "$PUBLIC_IP" > "$CACHE_FILE"  # Cache the new IP
else
  echo "Failed to update DNS record. Response: $RESPONSE"
  exit 1
fi
