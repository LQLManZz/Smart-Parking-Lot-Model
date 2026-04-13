import wave
import struct
import os

def convert_mem_to_wav(mem_filename, wav_filename, sample_rate=16000):
    """
    Converts a hex .mem file to a 16-bit mono little-endian WAV file.
    """
    if not os.path.exists(mem_filename):
        print(f"File not found: {mem_filename}")
        return

    with open(mem_filename, 'r') as f:
        lines = f.readlines()

    # Open a new WAV file for writing
    with wave.open(wav_filename, 'wb') as wav_file:
        # Set parameters: 1 channel (mono), 2 bytes per sample (16-bit), 16kHz sample rate
        wav_file.setnchannels(1)
        wav_file.setsampwidth(2)
        wav_file.setframerate(sample_rate)

        for line in lines:
            line = line.strip()
            if not line:
                continue
            
            # Parse the hex string to an integer
            val = int(line, 16)
            
            # Convert to signed 16-bit integer (handle two's complement)
            if val > 32767:
                val -= 65536
                
            # Pack the integer as a little-endian ('<') 16-bit signed short ('h')
            data = struct.pack('<h', val)
            
            # Write the raw bytes to the audio file
            wav_file.writeframesraw(data)
            
    print(f"Successfully converted {mem_filename} -> {wav_filename}")

# List of your uploaded files
mem_files = [
    "goodbye.mem",
    "luilai.mem",
    "welcome.mem"
]

# Run the conversion
for mem_file in mem_files:
    wav_file = mem_file.replace(".mem", ".wav")
    convert_mem_to_wav(mem_file, wav_file)