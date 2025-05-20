#!/usr/bin/python3
import os
import struct
import subprocess
import tempfile

BARS_NUMBER = 15
OUTPUT_BIT_FORMAT = "16bit"
RAW_TARGET = "/dev/stdout"

conpat = """
[general]
bars = %d
[output]
method = raw
raw_target = %s
bit_format = %s
"""

config = conpat % (BARS_NUMBER, RAW_TARGET, OUTPUT_BIT_FORMAT)
bytetype, bytesize, bytenorm = (
    ("H", 2, 65535) if OUTPUT_BIT_FORMAT == "16bit" else ("B", 1, 255)
)


GLYPHS = ["▁", "▂", "▃", "▄", "▅", "▆", "▇", "█"]


def run():
    with tempfile.NamedTemporaryFile() as config_file:
        config_file.write(config.encode())
        config_file.flush()

        process = subprocess.Popen(
            ["cava", "-p", config_file.name], stdout=subprocess.PIPE
        )
        chunk = bytesize * BARS_NUMBER
        fmt = bytetype * BARS_NUMBER

        if RAW_TARGET != "/dev/stdout":
            if not os.path.exists(RAW_TARGET):
                os.mkfifo(RAW_TARGET)
            source = open(RAW_TARGET, "rb")
        else:
            source = process.stdout

        try:
            while True:
                data = source.read(chunk)
                if len(data) < chunk:
                    break
                sample = [i / bytenorm for i in struct.unpack(fmt, data)]

                max_glyph_index = len(GLYPHS) - 1
                bar = "".join(
                    [
                        GLYPHS[min(max(int(v * max_glyph_index), 0), max_glyph_index)]
                        for v in sample
                    ]
                )

                print("\r" + bar, end="", flush=True)
        finally:
            process.kill()
            if RAW_TARGET != "/dev/stdout":
                source.close()


if __name__ == "__main__":
    run()
