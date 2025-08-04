#!/usr/bin/env bash

echo "Testing interactive input for both direct execution and piped execution..."
echo "Press 'y' to continue:"

while : ; do
    read -n 1 k
    if [[ $k = 'y' ]] ; then
        echo -e "\nSuccess! Input works correctly."
        break
    else
        echo -e "\nPlease press 'y' to continue"
    fi
done

echo "Test completed successfully!"