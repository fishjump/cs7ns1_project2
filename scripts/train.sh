#!/usr/bin/env zsh

rm -r ./output/training_data ./output/validation_data
./py/generate.py --width 128 --height 64 --length 6 --symbols symbols.txt --count 12800 --output-dir ./output/training_data
./py/generate.py --width 128 --height 64 --length 6 --symbols symbols.txt --count 1280 --output-dir ./output/validation_data
./py/train_length_predictor.py --width 128 --height 64 --length 6 --batch-size 128 --epoch 5 \
    --output-model length_predictor_v1 \
    --training_data ./output/training_data \
    --validation_data ./output/validation_data

for ((LEN=1;LEN<=1;LEN++)); do
rm -r ./output/training_data ./output/validation_data
./py/generate.py --width 128 --height 64 --length $LEN --symbols symbols.txt --count 128000 --output-dir ./output/training_data
./py/generate.py --width 128 --height 64 --length $LEN --symbols symbols.txt --count 1280 --output-dir ./output/validation_data
./py/train.py --width 128 --height 64 --length $LEN --batch-size 128 --epoch 5 \
    --symbols symbols.txt \
    --output-model captcha_$LEN_v1 \
    --train-dataset ./output/training_data \
    --validate-dataset ./output/validation_data
done