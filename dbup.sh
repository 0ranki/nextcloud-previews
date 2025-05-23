#!/bin/bash
su -s /bin/bash -c '/var/www/html/occ db:add-missing-indices' www-data
su -s /bin/bash -c '/var/www/html/occ maintenance:repair --include-expensive' www-data
