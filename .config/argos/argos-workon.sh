#!/usr/bin/env bash

workon="/home/mjumbewu/.local/bin/workon"

echo "Work on..."
echo "---"

for task in `$workon --options-list`
do
  if [ "${task:0:2}" != '--' ]
  then
    echo "$task | bash=\"$workon $task\" terminal=false"
  fi
done
