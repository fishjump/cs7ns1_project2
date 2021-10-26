#!/usr/bin/env python3

import os
import numpy
import random
import string
import cv2
import argparse
import captcha.image
import json


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--width', help='Width of captcha image', type=int)
    parser.add_argument('--height', help='Height of captcha image', type=int)
    parser.add_argument(
        '--length', help='Length of captchas in characters', type=int)
    parser.add_argument(
        '--count', help='How many captchas to generate', type=int)
    parser.add_argument(
        '--output-dir', help='Where to store the generated captchas', type=str)
    parser.add_argument(
        '--symbols', help='File with the symbols to use in captchas', type=str)
    args = parser.parse_args()

    if args.width is None:
        print("Please specify the captcha image width")
        exit(1)

    if args.height is None:
        print("Please specify the captcha image height")
        exit(1)

    if args.length is None:
        print("Please specify the captcha length")
        exit(1)

    if args.count is None:
        print("Please specify the captcha count to generate")
        exit(1)

    if args.output_dir is None:
        print("Please specify the captcha output directory")
        exit(1)

    if args.symbols is None:
        print("Please specify the captcha symbols file")
        exit(1)

    captcha_generator = captcha.image.ImageCaptcha(
        width=args.width, height=args.height)

    symbols_file = open(args.symbols, 'r')
    captcha_symbols = symbols_file.readline().strip()
    symbols_file.close()

    print("Generating captchas with symbol set {" + captcha_symbols + "}")

    if not os.path.exists(args.output_dir):
        print("Creating output directory " + args.output_dir)
        os.makedirs(args.output_dir)

    for i in range(args.count):
        captcha_len = args.length
        captcha_str = ''.join([random.choice(captcha_symbols)
                              for j in range(captcha_len)])

        captcha_info = {
            'captcha_len': captcha_len,
            'captcha_str': captcha_str
        }

        image_path = os.path.join(args.output_dir, str(i) + '.png')
        json_path = os.path.join(args.output_dir, str(i) + '.json')
        if os.path.exists(image_path):
            version = 1
            while os.path.exists(os.path.join(args.output_dir, str(i) + '_' + str(version) + '.png')):
                version += 1
            image_path = os.path.join(args.output_dir, str(
                i) + '_' + str(version) + '.png')
            json_path = os.path.join(args.output_dir, str(
                i) + '_' + str(version) + '.json')

        image = numpy.array(captcha_generator.generate_image(captcha_str))
        cv2.imwrite(image_path, image)
        with open(json_path, 'w') as f:
            json.dump(captcha_info, f)


if __name__ == '__main__':
    main()