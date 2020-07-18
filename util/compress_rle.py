import argparse
import os
from itertools import *

MAX_BYTE_COUNT = 127
NUM_BYTES = 8

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
        rle_bytes_int = compress_small_counts(rle_bytes_int)
        print(rle_bytes_int)
        rle_bytes_int = add_terminating_bytes(rle_bytes_int, 0, 0)
        rle_bytes_list_int = convert_to_straight_list_ints(rle_bytes_int)
        print(rle_bytes_list_int)
        rle_bytes_hex = convert_int_to_hex(rle_bytes_list_int)
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
    for item in l_ints:
        l_hexs.append(bytes([item]))
    return l_hexs

def compress_small_counts(l):
    new_l = list()
    are_we_in_run = False
    for x in range(len(l)):
        count, byte_int = l[x]
        if count > 1:
            new_l.append((count, byte_int))
            are_we_in_run = False
        elif count == 1 and not are_we_in_run:
            new_l.append((count, (byte_int, )))
            are_we_in_run = True
        elif are_we_in_run:
            if new_l[-1][0] + 1 <= MAX_BYTE_COUNT:
                new_count = new_l[-1][0] + 1
                new_run = new_l[-1][1] + (byte_int, )
                new_l[-1] = (new_count, new_run)
            else:
                new_l.append((count, (byte_int, )))
                are_we_in_run = True
        x += 1
    return new_l

def convert_to_straight_list_ints(l_int):
    new_l_int = list()
    for item in l_int:
        a, b = item
        if isinstance(b, int):
            new_l_int.append(a)
            new_l_int.append(b)
        else:
            new_l_int.append(2**NUM_BYTES - a)
            for subitem in b:
                new_l_int.append(subitem)
    return new_l_int

def add_terminating_bytes(l_ints, int_a, int_b):
    l_ints.append((int_a, int_b))
    return l_ints

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