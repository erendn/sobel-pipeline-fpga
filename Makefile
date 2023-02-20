TB_FILE=tb_file

SOURCES += ./src/ram_1r1w_sync.sv
SOURCES += ./src/sobel_operator.sv
SOURCES += ./src/sobel_channel_filter.sv
SOURCES += ./src/sobel_pipeline.sv
SOURCES += ./src/testbench.sv

iverilog:
	@python3 image_hex.py tohex
	@iverilog -g2012 -o ${TB_FILE} ${SOURCES}
	@vvp ${TB_FILE}
	@python3 image_hex.py topng
	@mv filtered.png filtered_iverilog.png
.PHONY: iverilog

VERILATOR_OPTS = -sv --timing --trace-fst -timescale-override 1ns/1ps
verilator:
	@python3 image_hex.py tohex
	@verilator -o ${TB_FILE} ${VERILATOR_OPTS} --binary --top-module testbench ${SOURCES}
	@./obj_dir/${TB_FILE}
	@python3 image_hex.py topng
	@mv filtered.png filtered_verilator.png
.PHONY: verilator

all: iverilog verilator
.PHONY: all

clean:
	@rm -f ${TB_FILE}
	@rm -rf obj_dir/
	@rm -f iverilog.vcd
	@rm -f verilator.fst
	@rm -f *.hex
	@rm -f sample_grayscale.png
	@rm -f filtered*.png
