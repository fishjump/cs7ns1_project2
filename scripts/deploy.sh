#!/usr/bin/env zsh

### parameters

USER='yuy4'
PI='rasp-037.berry.scss.tcd.ie'
SRC='output/project2/*'
DST='~/project2'
MODELS='models/v4/*' # version 4

# jumper settings
USE_JUMPER=true
JUMPER='macneill.scss.tcd.ie'

#### script

echo "===== Cleanup $SRC ====="
rm -r $SRC
mkdir -p $SRC

echo "===== Copy deploy to $SRC ====="
cp -r deploy/* $SRC

echo "===== Copy the Model Files to $SRC ====="
mkdir $SRC/models
cp -r $MODELS $SRC/models

echo "===== Copy the symbol file to $SRC ====="
cp symbols.txt $SRC

# push files to remote 
if [ $USE_JUMPER ]; then
  ssh -J $USER@$JUMPER $USER@$PI "rm -r $DST"
  scp -rp -J $USER@$JUMPER $SRC $USER@$PI:$DST
else
  ssh $USER@$PI "rm -r $DST"
  scp -rp $SRC $USER@$PI:$DST
fi

if [ $? == 0 ]; then
  echo '===== Done ======'
else 
  echo '===== Failed to Run scp, exit ====='
  exit 1
fi
