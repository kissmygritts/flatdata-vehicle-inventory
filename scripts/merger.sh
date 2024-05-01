# json inventory to csv
rm -f data/inventory.csv toyota-inventory.csv

jq -r \
  '
    (map(keys) | add | unique) as $cols 
    | $cols, map([.[$cols[]]])[] 
    | @csv
  ' inventory.json > data/inventory.csv

# join dealers and inventory csvs
csvjoin -c "dealerId,dealer" data/dealers.csv data/inventory.csv > toyota-inventory.csv