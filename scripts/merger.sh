# json inventory to csv
rm -f data/inventory.csv toyota-inventory.csv

jq -r \
  '
    (map(keys) | add | unique) as $cols 
    | $cols, map([.[$cols[]]])[] 
    | @csv
  ' inventory.json > data/inventory.csv

ls -la data

# join dealers and inventory csvs
csvjoin -c "dealerId,dealer" dealers.csv data/inventory.csv > toyota-inventory.csv

ls -la .

cat toyota-inventory.csv