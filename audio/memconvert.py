import struct
import os
import glob

def convert_pcm_to_mem(in_path, out_path):
    # Check the size to ensure it fits in the FPGA BRAM
    file_size_bytes = os.path.getsize(in_path)
    num_samples = file_size_bytes // 2
    print(f"Processing {in_path} ({num_samples} samples)...")

    if num_samples > 32768:
        print(f"WARNING: {in_path} has more than 32,768 samples.")
        print("It will not fit in a 15-bit address width!")

    with open(in_path, "rb") as f_in, open(out_path, "w") as f_out:
        count = 0
        while True:
            # Read 2 bytes (16 bits) at a time
            bytes_read = f_in.read(2)
            
            if not bytes_read:
                break
                
            # Pad with a zero byte if the file ends on an odd byte length
            if len(bytes_read) < 2:
                bytes_read += b'\x00'

            # Unpack as a little-endian 16-bit signed integer
            # '<' = little-endian, 'h' = short (2 bytes)
            sample = struct.unpack('<h', bytes_read)[0]

            # Convert to 16-bit unsigned hex (masking with 0xFFFF handles negatives)
            # 04x ensures it is exactly 4 characters long, lowercase
            hex_val = f"{sample & 0xFFFF:04x}"

            # Write to the .mem file with a newline
            f_out.write(hex_val + "\n")
            count += 1

    print(f"Successfully created {out_path} with {count} entries.")

# Run the conversion for all .pcm files in the current directory
if __name__ == "__main__":
    pcm_files = glob.glob("*.pcm")
    if not pcm_files:
        print("No .pcm files found in the current directory.")
    else:
        for pcm_file in pcm_files:
            mem_file = os.path.splitext(pcm_file)[0] + ".mem"
            convert_pcm_to_mem(pcm_file, mem_file)