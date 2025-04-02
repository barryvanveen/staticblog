# !/bin/bash

hugo version

if [ "$CF_PAGES_BRANCH" == "main" ]; then
  hugo -b $BASE_URL

else
  hugo -b $CF_PAGES_URL

fi