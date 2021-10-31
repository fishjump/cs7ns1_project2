#!/usr/bin/env zsh

### parameters

USER='yuy4'
PI='rasp-037.berry.scss.tcd.ie'
SRC='~/project2/result.csv'
DST="."

# jumper settings
USE_JUMPER=true
JUMPER='macneill.scss.tcd.ie'

# push files to remote 
if [ $USE_JUMPER ]; then
  scp -J $USER@$JUMPER $USER@$PI:$SRC $DST
else
  scp $USER@$PI:$SRC $DST
fi