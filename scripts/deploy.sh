#!/usr/bin/env zsh

### parameters

USER='yuy4'
PI='rasp-037.berry.scss.tcd.ie'
SRC='./output/project2'
DST="$USER@$PI:~"

# model settings
# if any of them is empty, then find the latest model in ./model 
H5_MODEL=''
JSON_MODEL=''

# jumper settings
USE_JUMPER=true
JUMPER='macneill.scss.tcd.ie'

#### script

echo "===== Cleanup $SRC ====="
rm -r $SRC
mkdir -p $SRC

echo "===== Copy deploy to $SRC ====="
cp -r ./deploy $SRC

# find latest .h5 and .json
if [ -z $JSON_MODEL ] || [ -z $H5_MODEL ]; then
  H5_MODEL=$(find ./models -name '*.h5' | xargs ls -1tc | head -1)
  BASE_H5_MODEL=$(basename $H5_MODEL | sed -n 's/\(.*\).h5/\1/p')
  JSON_MODEL=$(find ./models -name "$BASE_H5_MODEL.json")

  if [ -z $JSON_MODEL ]; then
    echo '===== Failed to Find correspond .json Model ====='
    echo "Where H5 Model names $H5_Model"
    echo "Expect: $BASE_H5_MODEL.json"
    echo '===== exit ====='
    exit 1
  else
    echo '===== Detected the Latest Model ====='
    echo "JSON_MODEL: $JSON_MODEL"
    echo "H5_MODEL: $H5_MODEL"
  fi

else 
  
  echo '===== Use the Input Model ====='
  echo "JSON_MODEL: $JSON_MODEL"
  echo "H5_MODEL: $H5_MODEL"

fi

echo "===== Copy the Model Files to $SRC ====="
mkdir $SRC/models
cp -r $JSON_MODEL $SRC/models
cp -r $H5_MODEL $SRC/models

# push files to remote 
if [ $USE_JUMPER ]; then
  scp -rp -J $USER@$JUMPER $SRC $DST
else
  scp -rp $SRC $DST
fi

if [ $? == 0 ]; then
  echo '===== Done ======'
else 
  echo '===== Failed to Run scp, exit ====='
  exit 1
fi
