#!/usr/bin/env python3

import tensorflow.keras as keras
import tensorflow as tf
import argparse
import random
import string
import numpy
import cv2
import os
import warnings
warnings.filterwarnings("ignore", category=FutureWarning)
warnings.filterwarnings("ignore", category=DeprecationWarning)


def preprocess(raw_data):
    data = cv2.cvtColor(raw_data, cv2.COLOR_BGR2GRAY)
    threshold, data = cv2.threshold(data, 0, 255, cv2.THRESH_OTSU)
    data = cv2.dilate(data, (1, 3), iterations=3)

    data = cv2.medianBlur(data, 3)
    data = cv2.filter2D(data, -1, kernel=numpy.array(
        [[0, -1, 0],
         [-1, 5, -1],
         [0, -1, 0]]
    ))

    return numpy.array(data)[..., numpy.newaxis]


def decode(characters, y):
    if type(y) == list:
        y = numpy.argmax(numpy.array(y), axis=2)[:, 0]
        return ''.join([characters[x] for x in y])
    else:
        y = numpy.argmax(numpy.array(y), axis=1)
        return ''.join([characters[x] for x in y])


def get_captcha_length(prediction):
    return numpy.argmax(prediction)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument(
        '--length-predictor-name', help='Model name to use for classification', type=str)
    parser.add_argument(
        '--captcha-predictor-name', help='', type=str)
    parser.add_argument(
        '--captcha-dir', help='Where to read the captchas to break', type=str)
    parser.add_argument(
        '--output', help='File where the classifications should be saved', type=str)
    parser.add_argument(
        '--symbols', help='File with the symbols to use in captchas', type=str)
    args = parser.parse_args()

    if args.length_predictor_name is None:
        print("Please specify the CNN model to use")
        exit(1)

    if args.captcha_predictor_name is None:
        print("Please specify the CNN model to use")
        exit(1)

    if args.captcha_dir is None:
        print("Please specify the directory with captchas to break")
        exit(1)

    if args.output is None:
        print("Please specify the path to the output file")
        exit(1)

    if args.symbols is None:
        print("Please specify the captcha symbols file")
        exit(1)

    symbols_file = open(args.symbols, 'r')
    captcha_symbols = symbols_file.readline().strip()
    symbols_file.close()

    print("Classifying captchas with symbol set {" + captcha_symbols + "}")

    with tf.device('/cpu:0'):
        with open(args.output, 'w') as output_file:
            json_file = open(args.length_predictor_name + '.json', 'r')
            loaded_model_json = json_file.read()
            json_file.close()
            length_predictor = keras.models.model_from_json(loaded_model_json)
            length_predictor.load_weights(args.length_predictor_name + '.h5')
            length_predictor.compile(loss='categorical_crossentropy',
                                     optimizer=keras.optimizers.Adam(
                                         1e-3, amsgrad=True),
                                     metrics=['accuracy'])

            captcha_predictors = []
            for i in range(6):
                captcha_predictors_name = args.captcha_predictor_name % (i + 1)
                captcha_predictors_json_file = open(
                    captcha_predictors_name + '.json', 'r')
                captcha_predictor = keras.models.model_from_json(
                    captcha_predictors_json_file.read())
                captcha_predictors_json_file.close()
                captcha_predictor.load_weights(captcha_predictors_name + '.h5')
                captcha_predictors.append(captcha_predictor)

            captcha_files = os.listdir(args.captcha_dir)
            captcha_files.sort()
            for x in captcha_files:
                # load image and preprocess it
                raw_data = cv2.imread(os.path.join(args.captcha_dir, x))
                length_predictor_image = raw_data / 255.0
                image = preprocess(raw_data) / 255.0
                (c, h, w) = image.shape
                image = image.reshape([-1, c, h, w])
                (c, h, w) = length_predictor_image.shape
                length_predictor_image = length_predictor_image.reshape(
                    [-1, c, h, w])
                prediction = length_predictor.predict(length_predictor_image)
                length = get_captcha_length(prediction)
                prediction = captcha_predictors[length].predict(image)
                output_file.write(
                    x + "," + decode(captcha_symbols, prediction) + "\n")
                print('Classified ' + x)


if __name__ == '__main__':
    main()
