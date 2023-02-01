#!/bin/bash
data=$(date +%d/%m/%Y)
output=.
while read -r db ; do
  while read -r table ; do
  if [ "$db" == "system" ]; then
     echo "skiped system db"
     continue 2;
  fi
  if [[ "$table" == ".inner."* ]]; then
     echo "skiped materialized view $table ($db)"
     continue;
  fi
  echo "exporting table $table from database $db"
    clickhouse-client -f LineAsString -q "SHOW CREATE TABLE ${db}.${table}" > "${output}/${db}_${table}_schema.sql"
  done < <(clickhouse-client -q "SHOW TABLES FROM $db")
done < <(clickhouse-client -q "SHOW DATABASES")

#gitupload
git add -A .
git commit -m ${data}
git push origin master
