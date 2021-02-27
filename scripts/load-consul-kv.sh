#/bin/bash

SECRETS=".env"
while IFS= read -r line
do
  KEY=$(echo $line | cut -d '=' -f 1)
  VALUE=$(echo $line | cut -d '=' -f 2)

  echo "Adding $KEY to consul"
  consul kv put secrets/$KEY $VALUE
  echo "$line"
done < "$SECRETS"

