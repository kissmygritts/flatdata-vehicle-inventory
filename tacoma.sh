curl \
  --header "Content-Type: application/json" \
  --request POST \
  --data '{
      "brand": "TOY",
      "mode": "content",
      "group": true,
      "groupmode": "full",
      "relevancy": false,
      "pagesize": 50,
      "pagestart": 0,
      "filter": {
          "year": [2021], 
          "series": ["tacoma"], 
          "dealers": [36052],
          "andfields": ["accessory", "packages"]
        }
    }' \
  https://www.toyota.com/config/services/inventory/search/getInventory \
  | jq -c \
    '.body.response.docs
      | .[] 
      | {
          vin: .vin,
          year: .year.code,
          vehicle: .grade.series_code,
          model: .grade.code,
          enginge: .engine.title,
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
          packages: .accessories | map(.title) | join(", ")
        }' \
  > tacomas.jsonl

  cat tacomas.jsonl | jq -s '.' > tacomas.json