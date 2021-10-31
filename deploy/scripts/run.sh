#!/usr/bin/bash

./scripts/downloader.sh

./py/classify.py --length-predictor-name models/length_predictor \
--captcha-predictor-name models/captcha_%d \
--output result.csv \
--symbols symbols.txt \
--captcha-dir captchas

sed -i "1 i\$(whoami)" result.csv