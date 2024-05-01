# json inventory to csv
rm -f data/inventory.csv data/toyota-inventory.csv

jq -r \
  '
    (map(keys) | add | unique) as $cols 
    | $cols, map([.[$cols[]]])[] 
    | @csv
  ' inventory.json > data/inventory.csv

# join dealers and inventory csvs
csvjoin -c "dealerId,dealer" data/dealers.csv data/inventory.csv |\
  csvcut -c name,state,vin,year,vehicle,model,engine,transmission,drivetrain,cab,bed,color,interior,base_msrp,total_msrp,availability_date,total_packages,packages,dealerId,url,regionId,lat,long > data/toyota-inventory.csv