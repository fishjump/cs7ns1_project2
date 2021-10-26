#!/usr/bin/env python3

import argparse
import captcha.image
import cv2
import numpy as np


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument(
        '--symbols', help='File with the symbols to use in captchas', type=str)
    args = parser.parse_args()

    if args.symbols is None:
        print("Please specify the captcha symbols file")
        exit(1)

    symbols_file = open(args.symbols, 'r')
    captcha_symbols = symbols_file.readline().strip()
    symbols_file.close()

    print("Generating captchas with symbol set {" + captcha_symbols + "}")

    captcha_generator = captcha.image.ImageCaptcha(
        width=len(captcha_symbols) * 32, height=64)
    captcha_sample = np.array(
        captcha_generator.generate_image(captcha_symbols))
    cv2.imwrite('captcha_sample.jpg', captcha_sample)


if __name__ == '__main__':
    main()
