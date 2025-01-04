#!/usr/bin/env bash

rm inventory.json
IFS=', ' read -r -a array < data/dealers.txt

for i in ${array[@]}
do
  curl --silent \
  --header "Content-Type: application/json" \
  --request POST \
  --data '{
      "brand": "TOY",
      "mode": "content",
      "group": true,
      "groupmode": "full",
      "relevancy": false,
      "pagesize": 300,
      "pagestart": 0,
      "filter": {
          "year": [2024, 2025], 
          "series": ["tacoma", "4runner", "tundra", "rav4", "landcruiser"], 
          "dealers": ["'$i'"],
          "andfields": ["accessory", "packages", "dealer"]
        }
    }' \
  https://www.toyota.com/config/services/inventory/search/getInventory \
  | jq -c \
    '.body.response.docs
      | .[] 
      | {
          dealer: "'$i'",
          vin: .vin,
          year: .year.code,
          vehicle: .grade.series_code,
          model: .grade.code,
          engine: .engine.title,
          transmission: .transmission.title,
          drivetrain: .drive.title,
          cab: .cab.title,
          bed: .bed.title,
          color: .exteriorcolor.title,
          interior: .interiorcolor.title,
          base_msrp: .priceInfo.baseMSRP,
          total_msrp: .priceInfo.totalMSRP,
          availability_date: .availabilityDate,
          total_packages: .accessories | length,
          packages: .accessories | map(.title) | join(", "),
          created_at: now | strflocaltime("%Y-%m-%d %H:%M:%S")
        }' \
  >> inventory.jsonl
done

cat inventory.jsonl | jq -s '.' > inventory.json
rm inventory.jsonl
