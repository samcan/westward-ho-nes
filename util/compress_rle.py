import argparse
import os

def main(input_file, output_file):
    if os.path.isfile(output_file):
        os.remove(output_file)

    with open(input_file, 'rb') as f:
        bytes_read = f.read()
        
        prev_byte = ''
        count = 0
        for byte in bytes_read:
            print('current byte:', byte)
            if prev_byte == '':
                prev_byte = byte
                count = 1
            elif byte == prev_byte:
                count += 1
            else:
                write_byte(output_file, count, prev_byte)
                
                print('setting prev_byte to',byte)
                prev_byte = byte
                count = 1
        
        # write final byte to file
        write_byte(output_file, count, prev_byte)
            

def write_byte(output, count, byte):
    print('writing',count,'of',bytes([byte]))
    with open(output, 'ba') as g:
        g.write(bytes([count]))
        g.write(bytes([byte]))

parser = argparse.ArgumentParser(description='Take bin file and RLE encode it.')
parser.add_argument('--input', required=True, type=str, help='Input bin file')
parser.add_argument('--output', required=True, type=str, help='Output bin file')
args = parser.parse_args()

main(args.input, args.output)