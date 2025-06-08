# Dynamic DNS via CloudFlare

Given that you have the IP Address from your local network that is not NAT. You can use this script to
public your IP address to your own domain name.

## Prerequisites

1. (Dynamic) Public IP Address
1. Cloudflare Account
1. Domain Name (managed by given Cloudflare Account)

## How it works

Set up a crontab on your local server. Run the script to get the public ip-address from `ipify.org` then update
the ipv4 records to your Cloudflare dns record. [Doc](https://developers.cloudflare.com/api/operations/dns-records-for-a-zone-update-dns-record)

## Acquiring Keys

API_TOKEN can be issued via [CloudFlare Console](https://dash.cloudflare.com/profile/api-tokens).

There are 2 modes of authentication.

1. **API Key** = User Level (Global Key + CloudFlare's user email). This usess `X-Auth-Key` and `X-Auth-Email` which is similar to username + password. This approach is not supported by the script. This Global Key is the key accessing in `API Keys` section in the console page (named **Global API Key**).
1. **API Token** = Token Level (Create a dedicate key add proper permissions (`Zone.DNS` = `DNS:Read` (for debug if needed) and `DNS:Edit`). This approach uses `Authorization` header and Bearer token.

Hence please create the `API Token` and set this into variable needed.

## Configurations

```bash
API_TOKEN=""  # API Token for accessing CloudFlare's API
ZONE_ID="" # Zone ID obtained this from Cloudflare's Zone (Domain)'s URL.
DNS_RECORD_ID="" # When your DNS record. Inspect the traffic, See the API that it returns. The id denote the DNS record.
DNS_RECORD_NAME="" # your subdomain name.
```

