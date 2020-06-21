# Add latest commit number to title screen

import argparse
import os

def main(INPUT_FILE, COMMIT):
    # see https://stackoverflow.com/a/14643685
    with open(INPUT_FILE, 'r+b') as f:
        f.seek(0x0376)
        
        val = 244
        f.write(bytes([val]))
        
        for char in COMMIT:
            if char == '0':
                val = 1
            elif char == '1':
                val = 2
            elif char == '2':
                val = 3
            elif char == '3':
                val = 4
            elif char == '4':
                val = 5
            elif char == '5':
                val = 6
            elif char == '6':
                val = 7
            elif char == '7':
                val = 8
            elif char == '8':
                val = 9
            elif char == '9':
                val = 10
            elif char == 'a':
                val = 16+1
            elif char == 'b':
                val = 16+2
            elif char == 'c':
                val = 16+3
            elif char == 'd':
                val = 16+4
            elif char == 'e':
                val = 16+5
            elif char == 'f':
                val = 16+6
            
            f.write(bytes([val]))
    

parser = argparse.ArgumentParser(description='Given bin file, patch it with latest git commit number.')
parser.add_argument('--input', required=True, type=str, help='Input bin file')
parser.add_argument('--commit', required=True, type=str, help='Short git commit hash, should be 7 chars long')

args = parser.parse_args()

main(args.input, args.commit.lower())