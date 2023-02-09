TB_FILE=tb_file

SOURCES += ./src/ram_1r1w_sync.sv
SOURCES += ./src/sobel_pixel_mask.sv
SOURCES += ./src/sobel_filter.sv
SOURCES += ./src/testbench.sv

test:
	@python3 image_hex.py tohex
	@iverilog -g2012 -o ${TB_FILE} ${SOURCES}
	@vvp ${TB_FILE}
	@python3 image_hex.py topng
.PHONY: test

clean:
	@rm ${TB_FILE} | true
	@rm iverilog.vcd | true
	@rm *.hex | true
	@rm sample_grayscale.png | true
	@rm filtered.png | true
