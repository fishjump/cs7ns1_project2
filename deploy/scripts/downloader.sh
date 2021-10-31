#!/usr/bin/bash

### parameters

USERNAME='yuy4'
BASE_URL='https://cs7ns1.scss.tcd.ie'
KEY="shortname=$USERNAME"
DOWNLOAD_LOCATION="captchas"

### script

FILELIST_PATH=$(curl -s "$BASE_URL?$KEY" | sed -n 's/.*\s\(.*\.csv\).*/\1/p')
DIR_NAME=$(echo $FILELIST_PATH | sed -n 's/\(.*\)\/.*\.csv/\1/p')
FILELIST_NAME=$(echo $FILELIST_PATH | sed -n 's/.*\/\(.*\.csv\)/\1/p')

if [ $? == 0 ] && [ $FILELIST_PATH != ''  ]; then  
  echo "===== Find Target File List at $BASE_URL/$DIR_NAME/$FILELIST_NAME ====="
else
  echo '===== Failed to Find the File List, exit ===='
  exit 1
fi

FILELIST=$(curl -s "$BASE_URL/$FILELIST_PATH" | sed -n 's/\(.*\.png\),/\1/p')
if [ $? == 0 ]; then  
  echo '===== Fetch Target File List Successfully  ====='
  echo "$BASE_URL/$FILELIST_PATH"
else
  echo '===== Failed to Fetch the File List, exit ===='
  exit 1
fi

echo "===== Download at $DOWNLOAD_LOCATION ====="
i=1
len=$(echo $FILELIST | wc -w)
for FILE in $FILELIST
do
  echo -ne "===== Downloading $FILE($i/$len) =====\r"
  wget -q $BASE_URL/$DIR_NAME/$FILE -P $DOWNLOAD_LOCATION
  i=$((i+1))
done
echo -e '\n===== Done ====='
