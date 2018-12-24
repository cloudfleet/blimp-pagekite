#!/bin/sh

set -e

curl -H "Accept: application/json" \
     -H "Authorization: Token $CLOUDFLEET_SECRET"
     -X PUT \
     -d "[\"$(echo $SUBDOMAINS | sed 's/;/\",\"/g')\"]" \
     $CLOUDFLEET_SPIRE_HOST/api/v1/blimps/$CLOUDFLEET_DOMAIN

KITE_PARAMS="--clean"

if [ $CLOUDFLEET_HOST ]; then
  KITE_PARAMS="$KITE_PARAMS --frontend=$CLOUDFLEET_PAGEKITE_HOST"
else
  KITE_PARAMS="$KITE_PARAMS --defaults"
fi

for SUBDOMAIN in $(echo $SUBDOMAINS | tr ";" "\n"); do
  KITE_PARAMS="$KITE_PARAMS --service_on=http:$SUBDOMAIN.$CLOUDFLEET_DOMAIN:$LOCAL_HOST:80:$CLOUDFLEET_SECRET"
  KITE_PARAMS="$KITE_PARAMS --service_on=https:$SUBDOMAIN.$CLOUDFLEET_DOMAIN:$LOCAL_HOST:443:$CLOUDFLEET_SECRET"
done

python pagekite.py $KITE_PARAMS
