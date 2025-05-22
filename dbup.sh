#!/bin/bash
su -c '/var/www/html/occ db:add-missing-indices' - www-data
su -c '/var/www/html/occ maintenance:repair --include-expensive' - www-data
