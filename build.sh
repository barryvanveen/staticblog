# !/bin/bash

# scrape latest observations
./getObservations.sh

# output hugo version
hugo version

# build with production base URL
if [ "$CF_PAGES_BRANCH" == "main" ]; then
  hugo -b $BASE_URL

# build branch for CI/CD preview with Cloudflare base URL
else
  hugo -b $CF_PAGES_URL

fi