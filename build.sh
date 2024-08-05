# !/bin/bash

if [ "$CF_PAGES_BRANCH" == "production" ]; then
  hugo -b $BASE_URL

else
  hugo -b $CF_PAGES_URL

fi