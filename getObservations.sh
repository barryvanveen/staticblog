# !/bin/bash

## Dependencies ##
# jq, curl, xmllint (libxml2)

## What this script does ##

# download the contents of https://waarneming.nl/users/408111/observations/?advanced=on
# find the table with selector "div.app-content-section table"
# take the first 3 rows where "td.column-species" does not contain "i.status-uncertain" and where "td::last" contains "i.fa-camera"
# iterate over the 3 rows
  # collect the href from "td::first a" and download the page
  # from that page, take the following information
    # common name: .app-content .species-common-name
    # scientific name: .app-content .species-scientific-name
    # photo: .app-content div#photos img
  # convert the first photo to a base64 encoded string
# output the url, common name, scientific name and base64 encoded photo to a json file called observations.json

set -euo pipefail

PAGE_URL="https://waarneming.nl/users/408111/observations/?advanced=on"
BASE_URL="https://waarneming.nl"

tmp=$(mktemp)
tmp2=$(mktemp)
tmpimg=$(mktemp)
trap 'rm -f "$tmp" "$tmp2" "$tmpimg"' EXIT

# fetch main page
curl -sL -b "django_language=en" "$PAGE_URL" -o "$tmp"

COND="td[contains(concat(' ',normalize-space(@class),' '),' column-species ')][not(.//i[contains(concat(' ',normalize-space(@class),' '),' status-uncertain ')])] and td[last()]//i[contains(concat(' ',normalize-space(@class),' '),' fa-camera ')]"
ROWS_XPATH="//div[contains(concat(' ',normalize-space(@class),' '),' app-content-section ')]//table//tr[${COND}]"

# count matching rows
count_raw=$(xmllint --html --xpath "number(count(${ROWS_XPATH}))" "$tmp" 2>/dev/null || echo "0")
count=${count_raw%.*}
if [ "$count" -lt 1 ]; then
  echo "## Found no observations"
  echo "[]" > observations.json
  exit 0
fi
max=$(( count < 3 ? count : 3 ))
echo "## Found $max observations"

# helper: safely run xmllint and return empty on no-match
xmlexpr() {
  local expr="$1"; local file="$2"
  xmllint --html --noblanks --xpath "$expr" "$file" 2>/dev/null || true
}

json_escape() {
  printf '%s' "$1" | jq -Rsa .
  #printf '%s' "$1" | sed '' -e 's/\\/\\\\/g' -e 's/"/\\"/g' -e ':a;N;$!ba;s/\n/\\n/g'
}

items=()
for i in $(seq 1 $max); do
  href=$(xmlexpr "string(${ROWS_XPATH}[position()=$i]/td[1]//a/@href)" "$tmp")
  url="${BASE_URL}${href}"

  curl -sL -b "django_language=en" "$url" -o "$tmp2"

  common_xpath="string((//div[contains(@class,'app-content')]//span[contains(@class,'species-common-name')])[1])"
  sci_xpath="string((//div[contains(@class,'app-content')]//i[contains(@class,'species-scientific-name')])[1])"
  photo_xpath="string(//div[contains(concat(' ',normalize-space(@class),' '),' app-content ')]//div[@id='photos']//img[1]/@src)"

  common=$(xmlexpr "$common_xpath" "$tmp2" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
  sci=$(xmlexpr "$sci_xpath" "$tmp2" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
  photo=$(xmlexpr "$photo_xpath" "$tmp2" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')

  if [[ -n "$photo" ]]; then
    [[ "$photo" =~ ^http ]] || photo="${BASE_URL}${photo}"
    curl -sL "$photo" -o "$tmpimg"
    photo_b64=$(base64 < "$tmpimg" | tr -d '\n')
  else
    photo_b64=""
  fi

  esc_url=$(json_escape "$url")
  esc_common=$(json_escape "$common")
  esc_sci=$(json_escape "$sci")
  esc_photo=$(json_escape "$photo_b64")

  echo "## Observation $i: $common - $sci"

  items+=("{\"url\": ${esc_url}, \"common_name\": ${esc_common}, \"scientific_name\": ${esc_sci}, \"photo\": ${esc_photo}}")
done

printf '[%s]\n' "$(IFS=,; echo "${items[*]}")" > assets/observations.json