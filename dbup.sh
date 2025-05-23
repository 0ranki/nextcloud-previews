#!/bin/bash
/var/www/html/occ db:add-missing-indices
/var/www/html/occ maintenance:repair --include-expensive
