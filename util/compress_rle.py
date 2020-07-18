import argparse
import os
from itertools import *

MAX_BYTE_COUNT = 255

def main(input_file, output_file):
    print('Input file:', input_file)
    print('Output file:', output_file)
    if os.path.isfile(output_file):
        os.remove(output_file)

    run = False
    with open(input_file, 'rb') as f:
        bytes_read_int = f.read()
        rle_bytes_int = rle_encode(bytes_read_int)
        rle_bytes_int = break_apart_too_big_counts(rle_bytes_int)
        rle_bytes_hex = convert_int_to_hex(rle_bytes_int)
        write_bytes(output_file, rle_bytes_hex)

    # print file compression info
    input_file_num_bytes = os.stat(input_file).st_size
    output_file_num_bytes = os.stat(output_file).st_size

    print('Input file size (bytes):', input_file_num_bytes)
    print('Output file size (bytes):', output_file_num_bytes)
    compression_pct = 1 - (output_file_num_bytes / input_file_num_bytes)
    print(f"Compression (%): {compression_pct * 100:.1f}")
    print()

# see https://www.techrepublic.com/article/run-length-encoding-in-python/
def rle_encode(l):
    return [(len(list(group)),name) for name, group in groupby(l)]

def break_apart_too_big_counts(l):
    # break apart any tuples that have a count greater than MAX_BYTE_COUNT
    new_l = list()
    for x in range(len(l)):
        count, byte_int = l[x]

        multiples = count // MAX_BYTE_COUNT
        remainder = count % MAX_BYTE_COUNT

        new_count = 0
        if multiples == 0:
            new_count = count
        else:
            new_count = MAX_BYTE_COUNT

        for multiple in range(multiples):
            new_l.append((new_count, byte_int))

        if remainder != 0:
            new_l.append((remainder, byte_int))

        x += 1
    return (new_l)

def convert_int_to_hex(l_ints):
    l_hexs = list()
    for tuple_int in l_ints:
        a, b = tuple_int
        l_hexs.append(bytes([a]))
        l_hexs.append(bytes([b]))
    return l_hexs


def write_bytes(output, byteslist):
    with open(output, 'ba') as g:
        for byte in byteslist:
            g.write(byte)

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Take bin file and RLE encode it.')
    parser.add_argument('--input', required=True, type=str, help='Input bin file')
    parser.add_argument('--output', required=True, type=str, help='Output bin file')
    args = parser.parse_args()

    main(args.input, args.output)