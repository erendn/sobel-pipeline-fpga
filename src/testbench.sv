`timescale 1ns/1ps
module testbench();

    localparam WIDTH  = 64;
    localparam HEIGHT = 64;

    logic  [0:0] clk;
    wire   [0:0] reset;

    logic [7:0] image_r [WIDTH-1:0][HEIGHT-1:0];
    wire  [7:0] image_w [WIDTH-1:0][HEIGHT-1:0];

    logic [7:0] image_out_r [WIDTH-1:0][HEIGHT-1:0];

    sobel_filter
       #(.WIDTH_P(WIDTH)
        ,.HEIGHT_P(HEIGHT))
    sobel_filter_inst
        (.clk_i(clk)
        ,.reset_i(reset)
        ,.image_i(image_r)
        ,.image_o(image_w)
        );

    initial begin
        clk = 1;
        forever
            #5 clk = ~clk;
    end

    initial begin
`ifdef VERILATOR
        $dumpfile("verilator.fst");
`else
        $dumpfile("iverilog.vcd");
`endif
        $dumpvars;

        $display("Begin Test:");

        $display("   Reading image file: sample.hex");
        $readmemh("sample.hex", image_r);
        $display("   Image file is read.");
        $display("      Sample pixel at (%0d, %0d) = 0x%0h", 5, 5, image_r[5][5]);

        $display("   Starting to apply the filter.");
        @(posedge clk);
        @(negedge clk);
        $display("   Filter should be applied now.");
        $display("      Sample pixel at (%0d, %0d) = 0x%0h", 5, 5, image_w[5][5]);

        $display("   Writing the filtered image to the memory.");
        for (int i = 0; i < WIDTH; i = i + 1) begin
            for (int j = 0; j < HEIGHT; j = j + 1) begin
                image_out_r[i][j] = image_w[i][j];
            end
        end
        $display("   Filtered image is written to the memory.");
        $display("      Sample pixel at (%0d, %0d) = 0x%0h", 5, 5, image_out_r[5][5]);

        $finish();
    end

    final begin
        $display("End test:");
        $display("   Writing the output hex file.");
        $writememh("filtered.hex", image_out_r);
        $display("   Hex file is written.");
    end

endmodule
