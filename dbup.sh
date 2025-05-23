#!/bin/bash
/var/www/html/occ db:add-missing-indices
/var/www/html/occ maintenance:repair --include-expensive
if [[ -z "$(/var/www/html/occ config:system:get maintenance_window_start)" ]]; then
	/var/www/html/occ config:system:set maintenance_window_start --value=1
fi
if [[ -z "$(/var/www/html/occ config:system:get default_phone_region)" ]]; then
	/var/www/html/occ config:system:set default_phone_region --value="FI"
fi
