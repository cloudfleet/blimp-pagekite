#!/bin/bash

pagekite --clean --frontend=$CLOUDFLEET_HOST \
         --service_on=http,https:blimp.$CLOUDFLEET_DOMAIN:nginx:443:$CLOUDFLEET_SECRET \
         --logfile=/opt/cloudfleet/data/logs/pagekite/pagekite.log
