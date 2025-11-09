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
trap 'rm -f "$tmp" "$tmp2"' EXIT

# fetch main page
curl -sL "$PAGE_URL" -o "$tmp"

# XPath pieces
COND="td[contains(concat(' ',normalize-space(@class),' '),' column-species ')][not(.//i[contains(concat(' ',normalize-space(@class),' '),' status-uncertain ')])] and td[last()]//i[contains(concat(' ',normalize-space(@class),' '),' fa-camera ')]"
ROWS_XPATH="//div[contains(concat(' ',normalize-space(@class),' '),' app-content-section ')]//table//tr[${COND}]"

# count matching rows
count_raw=$(xmllint --html --xpath "number(count(${ROWS_XPATH}))" "$tmp" 2>/dev/null || echo "0")
count=${count_raw%.*}
if [ "$count" -lt 1 ]; then
  echo "[]"
  exit 0
fi
max=$(( count < 3 ? count : 3 ))

# helper: safely run xmllint and return empty on no-match
xmlexpr() {
  local expr="$1"; local file="$2"
  xmllint --html --noblanks --xpath "$expr" "$file" 2>/dev/null || true
}

# escape JSON string (basic)
json_escape() {
  printf '%s' "$1" | sed -e 's/\\/\\\\/g' -e 's/"/\\"/g' -e ':a;N;$!ba;s/\n/\\n/g'
}

# iterate rows and collect objects
items=()
for i in $(seq 1 $max); do
  href=$(xmlexpr "string(${ROWS_XPATH}[position()=$i]/td[1]//a/@href)" "$tmp")
  href=$(echo "$href" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
  if [ -z "$href" ]; then
    continue
  fi
  # make absolute
  if [[ "$href" =~ ^http ]]; then
    url="$href"
  else
    # ensure leading slash
    if [[ "$href" != /* ]]; then
      href="/$href"
    fi
    url="${BASE_URL}${href}"
  fi

  # fetch detail page
  curl -sL "$url" -o "$tmp2"

  # extract names
  common_xpath="string(//div[contains(concat(' ',normalize-space(@class),' '),' app-content ')]//h1//span[contains(concat(' ',normalize-space(@class),' '),' species-common-name ')])"
  sci_xpath="string(//div[contains(concat(' ',normalize-space(@class),' '),' app-content ')]//div[contains(concat(' ',normalize-space(@class),' '),' species-subtitle ')]//i[contains(concat(' ',normalize-space(@class),' '),' species-scientific-name ')])"

  common=$(xmlexpr "$common_xpath" "$tmp2")
  sci=$(xmlexpr "$sci_xpath" "$tmp2")

  common=$(echo "$common" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
  sci=$(echo "$sci" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')

  esc_url=$(json_escape "$url")
  esc_common=$(json_escape "$common")
  esc_sci=$(json_escape "$sci")

  items+=("{\"url\": \"${esc_url}\", \"common_name\": \"${esc_common}\", \"scientific_name\": \"${esc_sci}\"}")
done

# output JSON array
printf '[%s]\n' "$(IFS=,; echo "${items[*]}")"
