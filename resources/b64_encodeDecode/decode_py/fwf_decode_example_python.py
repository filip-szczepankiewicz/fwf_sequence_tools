import struct, base64
import numpy as np

mdmr_dtypes = { 0: 's', 1: 'I', 2: 'q', 3: 'f', 4: 'd'}

# output of test_encode
b64data = """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"""
strdata = base64.b64decode(b64data)

def parse(data):
    ptr = 0
    hdr_st = '=' + ''.join(('4s', '4s', 'I'))
    hdr_size = struct.calcsize(hdr_st)
    magic,version,n_blocks = struct.unpack(hdr_st, data[:hdr_size])
    ptr += hdr_size

    blocks = []
    for block_i in range(n_blocks):
        block_fmt = '=iq'
        block_size = struct.calcsize(block_fmt)
        dtype, length = struct.unpack(block_fmt, data[ptr:ptr+block_size])
        blocks.append((dtype,length))

    base_offset = hdr_size + (struct.calcsize(block_fmt) * n_blocks)

    output_data = []
    for block_i, blockinfo in enumerate(blocks):
        ptr = base_offset
        dtype, length = blockinfo
        dtype_fmt = mdmr_dtypes[dtype]

        format = '{}{}'.format(length, dtype_fmt)
        block_size = struct.calcsize(format)

        block_data = struct.unpack(format, data[ptr:ptr+block_size])
        output_data.append(np.array(block_data))
        
        ptr += block_size

    return (magic, version, n_blocks, output_data)
        

if __name__ == '__main__':
    (magic, version, n_blocks, data) = parse(strdata)

    print("magic: ", magic)
    print("version: ", version)
    print("n_blocks: ", n_blocks)
    print("data (arrays): ")
    for i,array in enumerate(data):
        print("### array number:", i)
        print(array)