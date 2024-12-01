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

