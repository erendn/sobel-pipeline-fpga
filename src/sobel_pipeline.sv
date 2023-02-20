// This is the sobel pipeline module
module sobel_pipeline
   #(parameter WIDTH_P  = 10
    ,parameter HEIGHT_P = 10
    ,parameter CHANNELS_P = 1
    )
    (input  [0:0]   clk_i
    ,input  [0:0] reset_i
    ,input  [0:0] valid_i
    ,input  [(CHANNELS_P*8)-1:0] pixel_i
    ,output [0:0] valid_o
    ,output [(CHANNELS_P*8)-1:0] pixel_o
    );

    generate
        for (genvar itr = 0; itr < CHANNELS_P; itr++) begin
            sobel_channel_filter
               #(.WIDTH_P(WIDTH_P)
                ,.HEIGHT_P(HEIGHT_P)
                )
            sobel_channel_filter_inst
                (.clk_i(clk_i)
                ,.reset_i(reset_i)
                ,.valid_i(valid_i)
                ,.pixel_i(pixel_i[itr*8 +: 8])
                ,.valid_o(valid_o)
                ,.pixel_o(pixel_o[itr*8 +: 8])
                );
        end
    endgenerate

endmodule

