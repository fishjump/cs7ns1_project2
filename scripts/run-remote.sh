#!/usr/bin/env zsh

### parameters

USER='yuy4'
PI='rasp-037.berry.scss.tcd.ie'
CMD='cd ~/project2; ./scripts/run.sh'

# jumper settings
USE_JUMPER=true
JUMPER='macneill.scss.tcd.ie'

# push files to remote 
if [ $USE_JUMPER ]; then
  ssh -J $USER@$JUMPER $USER@$PI $CMD
else
  ssh $USER@$PI $CMD
fi