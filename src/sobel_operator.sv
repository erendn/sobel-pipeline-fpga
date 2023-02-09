// I got this module from Mahboob Karimian's website:
//     https://hellotech.altervista.org/sobel-method-simulation-and-implementation-on-fpga/
// I modified the code slightly but this module is essentialy an optimized sobel operator.
module sobel_operator
    (input  [7:0] p0_i
    ,input  [7:0] p1_i
    ,input  [7:0] p2_i
    ,input  [7:0] p3_i
    ,input  [7:0] p4_i
    ,input  [7:0] p5_i
    ,input  [7:0] p6_i
    ,input  [7:0] p7_i
    ,input  [7:0] p8_i
    ,output [7:0] p4_o);

    // 11 bits because max value of gx and gy is 255*4 and last bit for sign
    wire signed [10:0] gx, gy;
    wire signed [10:0] abs_gx, abs_gy;
    wire        [10:0] sum;

    // Horizontal mask
    assign gx = ((p2_i - p0_i) + ((p5_i - p3_i) << 1) + (p8_i - p6_i));
    // Vertical mask
    assign gy = ((p0_i - p6_i) + ((p1_i - p7_i) << 1) + (p2_i - p8_i));

    // Absolute values of both axes
    assign abs_gx = (gx[10] ? ~gx + 1 : gx);
    assign abs_gy = (gy[10] ? ~gy + 1 : gy);

    // Add both axes to find the combined value
    assign sum  = (abs_gx + abs_gy);

    // Limit the max value to 255    
    assign p4_o = (|sum[10:8]) ? 8'hff : sum[7:0];

endmodule

