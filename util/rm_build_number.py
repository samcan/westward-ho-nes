# Remove commit number from title screen

import argparse
import os

def main(INPUT_FILE):
    # see https://stackoverflow.com/a/14643685
    with open(INPUT_FILE, 'r+b') as f:
        f.seek(0x0376)
    
        for i in range(8):
            val = 51
            f.write(bytes([val]))
        

parser = argparse.ArgumentParser(description='Given bin file, remove git commit number.')
parser.add_argument('--input', required=True, type=str, help='Input bin file')

args = parser.parse_args()

main(args.input)