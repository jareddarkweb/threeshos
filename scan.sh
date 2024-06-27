#!/bin/bash

# set vars
id="$1"
ppath="$(pwd)"
scope_path="$ppath/scope/$id"

timestamp="$(date +%s)"
scan_path="$ppath/scans/$id-$timestamp"

# exit if scope path doesnt exist
if [ ! -d "$scope_path" ]; then
  echo "Path doesn't exist"
  exit 1
fi

mkdir -p "$scan_path"
cd "$scan_path"

### PERFORM SCAN ###

## SETUP
echo "Starting scan against roots:"
cat "$scope_path/roots.txt"
cp -v "$scope_path/roots.txt" "$scan_path/roots.txt"

## DNS Enumeration Find Subdomains

cat "Sscan_path/roots.txt" | haktrails subdomains | anew subs.txt | wc -1
cat "$scan_path/roots.txt" | subfinder | anew subs.txt | wc -1
cat "Sscan_path/roots.txt" | shuffledns -w "$ppath/lists/pry-dns.txt" -r "$ppath/lists/resolvers.txt" | anew subs.txt | wc
-1

## DNS Resolution Resolve Discovered Subdomains

puredns resolve "Sscan_path/subs.txt" -r "Sppath/lists/resolvers.txt" -w "$scan_path/resolved.txt" | wc -1
dnsx -1 "$scan_path/resolved.txt -json -o "$scan_path/dns.json" | jq - .a?[]? | anew "$scan_path/ips.txt" | wc -1

################### ADD SCAN LOGIC HERE  ##################


# calculate time diff
end_time=$(date +%s)
seconds="$(expr $end_time - $timestamp)"
time=""

if [[ "$seconds" -gt 59 ]]
then
  minutes=$(expr $seconds / 60)
  time="$minutes minutes"
else
  time="$seconds seconds"
fi

echo "Scan $id took $time"
#echo "Scan $id took $time" | notify

