TB_FILE=tb_file

test:
	python3 image_hex.py tohex
	iverilog -g2012 -o ${TB_FILE} sobel_pixel_mask.sv sobel_filter.sv testbench.sv
	vvp ${TB_FILE}
	python3 image_hex.py topng
.PHONY: test

clean:
	rm ${TB_FILE}
