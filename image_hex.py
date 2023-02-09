import sys
from PIL import Image


image_to_hex = "sample"
hex_to_image = "filtered"
grayscale = True

size = Image.open(f"{image_to_hex}.png").size

warning_message = ""

if sys.argv[1] == "tohex":
    img = Image.open(f"{image_to_hex}.png")
    if grayscale:
        img = img.convert("L")
        img.save(f"{image_to_hex}_grayscale.png")
    with open(f"{image_to_hex}.hex", "w") as f:
        for i in range(size[0]):
            for j in range(size[1]):
                rgb = img.getpixel((i, j))
                if not grayscale:
                    hex_val = ""
                    for k in range(3):
                        hex_val += "{0:0{1}X}".format(rgb[k], 2)
                else:
                    hex_val = "{0:0{1}X}".format(rgb, 2)
                f.write(hex_val)
                if j < img.size[1] - 1:
                    f.write(" ")
            f.write("\n")


if sys.argv[1] == "topng":
    if grayscale:
        img = Image.new(mode="L", size=size)
    else:
        img = Image.new(mode="RGB", size=size)
    with open(f"{hex_to_image}.hex", "r") as rf:
        lines = rf.readlines()
        rows = []
        for line in lines:
            if line[0] == '/':
                continue
            if 'x' in line:
                warning_message = "X found in data"
                line = line.replace('x', '0')
            rows.append(line.rstrip('\n'))
        for i in range(size[0]):
            for j in range(size[1]):
                if grayscale:
                    pixel = int(rows[i * size[1] + j], 16)
                    img.putpixel((i, j), pixel)
                else:
                    pixel = [0, 0, 0, 255]
                    for k in range(3):
                        pixel[k] = int(hex_pixels[j][k*2:(k+1)*2], 16)
                    img.putpixel((i, j), tuple(pixel))
    img.save(f"{hex_to_image}.png")

if len(warning_message):
    print(warning_message)
