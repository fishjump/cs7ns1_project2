#!/usr/bin/bash

SECONDS=0

./scripts/downloader.sh

DOWNLOAD_TIME=$SECONDS

./py/classify.py --length-predictor-name models/length_predictor \
--captcha-predictor-name models/captcha_%d \
--output result.csv \
--symbols symbols.txt \
--captcha-dir captchas

sed -i "1 i\\$(whoami)" result.csv

CLASSIFY_TIME=$((SECONDS-DOWNLOAD_TIME))

echo "===== Download: ${DOWNLOAD_TIME}s ====="
echo "===== Classify: ${CLASSIFY_TIME}s ====="
echo "===== Total use: ${SECONDS}s ====="
