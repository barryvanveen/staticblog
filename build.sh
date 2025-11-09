# !/bin/bash

# scrape latest observations
echo "## Getting observations..."
./getObservations.sh
echo "## Finished getting observations:"
cat assets/observations.json

# output hugo version
echo "## Hugo version"
hugo version

echo "## Hugo build"
# build with production base URL
if [ "$CF_PAGES_BRANCH" == "main" ]; then
  hugo -b $BASE_URL

# build branch for CI/CD preview with Cloudflare base URL
else
  hugo -b $CF_PAGES_URL

fi