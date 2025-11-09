# !/bin/bash

# download the contents of https://waarneming.nl/users/408111/observations/?advanced=on

# find the table with selector "div.app-content-section table"

# take the first 3 rows where "td.column-species" does not contain "i.status-uncertain" and where "td::last" contains "i.fa-camera"

# iterate over the 3 rows

  # collect the href from "td::first a" and download the page

  # from that page, take the following information
    # common name: .app-content h1 span.species-common-name
    # scientific name: .app-content div.species-subtitle i.species-scientific-name
    # photo: .app-content div#photos img

  # convert the first photo to a base64 encoded string

  # output the url, common name, scientific name and base64 encoded photo to a json file called observations.json

#!/bin/bash
set -euo pipefail

# Minimal deps: curl, xmllint (libxml2)
PAGE_URL="https://waarneming.nl/users/408111/observations/?advanced=on"
BASE_URL="https://waarneming.nl"

tmp=$(mktemp)
tmp2=$(mktemp)
tmpimg=$(mktemp)
trap 'rm -f "$tmp" "$tmp2" "$tmpimg"' EXIT

# fetch main page
curl -sL "$PAGE_URL" -o "$tmp"

COND="td[contains(concat(' ',normalize-space(@class),' '),' column-species ')][not(.//i[contains(concat(' ',normalize-space(@class),' '),' status-uncertain ')])] and td[last()]//i[contains(concat(' ',normalize-space(@class),' '),' fa-camera ')]"
ROWS_XPATH="//div[contains(concat(' ',normalize-space(@class),' '),' app-content-section ')]//table//tr[${COND}]"

# count matching rows
count_raw=$(xmllint --html --xpath "number(count(${ROWS_XPATH}))" "$tmp" 2>/dev/null || echo "0")
count=${count_raw%.*}
if [ "$count" -lt 1 ]; then
  echo "[]" > observations.json
  exit 0
fi
max=$(( count < 3 ? count : 3 ))

# helper: safely run xmllint and return empty on no-match
xmlexpr() {
  local expr="$1"; local file="$2"
  xmllint --html --noblanks --xpath "$expr" "$file" 2>/dev/null || true
}

json_escape() {
  printf '%s' "$1" | sed -e 's/\\/\\\\/g' -e 's/"/\\"/g' -e ':a;N;$!ba;s/\n/\\n/g'
}

items=()
for i in $(seq 1 $max); do
  href=$(xmlexpr "string(${ROWS_XPATH}[position()=$i]/td[1]//a/@href)" "$tmp")
  href=$(echo "$href" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
  if [ -z "$href" ]; then continue; fi
  if [[ "$href" =~ ^http ]]; then
    url="$href"
  else
    [[ "$href" != /* ]] && href="/$href"
    url="${BASE_URL}${href}"
  fi

  curl -sL "$url" -o "$tmp2"

  common_xpath="string(//div[contains(concat(' ',normalize-space(@class),' '),' app-content ')]//h1//span[contains(concat(' ',normalize-space(@class),' '),' species-common-name ')])"
  sci_xpath="string(//div[contains(concat(' ',normalize-space(@class),' '),' app-content ')]//div[contains(concat(' ',normalize-space(@class),' '),' species-subtitle ')]//i[contains(concat(' ',normalize-space(@class),' '),' species-scientific-name ')])"
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

  items+=("{\"url\": \"${esc_url}\", \"common_name\": \"${esc_common}\", \"scientific_name\": \"${esc_sci}\", \"photo\": \"${esc_photo}\"}")
done

printf '[%s]\n' "$(IFS=,; echo "${items[*]}")" > assets/observations.json