# !/bin/bash

# scrape latest observations
echo "## Getting observations..."
chmod +x getObservations.sh
./getObservations.sh
echo "## Finished getting observations:"

FILE="assets/observations.json"

if [ ! -f "$FILE" ]; then
  echo "$FILE does not exist."
else
  cat $FILE
fi

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