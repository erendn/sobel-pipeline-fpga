TB_FILE=tb_file

SOURCES += ./src/sobel_pixel_mask.sv
SOURCES += ./src/sobel_filter.sv
SOURCES += ./src/testbench.sv

test:
	python3 image_hex.py tohex
	iverilog -g2012 -o ${TB_FILE} ${SOURCES}
	vvp ${TB_FILE}
	python3 image_hex.py topng
.PHONY: test

clean:
	rm ${TB_FILE}
	rm iverilog.vcd
	rm *.hex
	rm sample_grayscale.png
	rm filtered.png
