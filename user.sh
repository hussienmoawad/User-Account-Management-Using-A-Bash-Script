#!/bin/bash

CSV_FILE="employee.csv"

if [ "$UID" -ne 0 ]; then
  echo "This script must be run as root."
  exit 1
fi

if [ ! -f "$CSV_FILE" ]; then
  echo "CSV file not found: $CSV_FILE"
  exit 1
fi

while IFS=, read -r username full_name; do
  password=$(openssl rand -base64 12)

  useradd -m -c "$full_name" "$username"
  echo "$username:$password" | chpasswd

  chage -d 0 "$username"

  echo "User created: $username"
  echo "Full Name: $full_name"
  echo "Random Password: $password"
  echo "-------------------"
  echo $username,$password >> out.txt

done < "$CSV_FILE"

echo "User creation completed.
