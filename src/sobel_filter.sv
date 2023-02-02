module sobel_filter
   #(parameter WIDTH_P = 10
    ,parameter HEIGHT_P = 10)
    (input  [0:0] clk_i
    ,input  [0:0] reset_i
    ,input  [7:0] image_i [WIDTH_P-1:0][HEIGHT_P-1:0]
    ,output [7:0] image_o [WIDTH_P-1:0][HEIGHT_P-1:0]);

    // Keep input here
    logic [7:0] image_r [WIDTH_P-1:0][HEIGHT_P-1:0];
    // Keep output here
    logic [7:0] filtered_r [WIDTH_P-1:0][HEIGHT_P-1:0];

    assign image_o = filtered_r;

    always_ff @(posedge clk_i) begin
        for (int i = 0; i < WIDTH_P; i += 1) begin
            for (int j = 0; j < HEIGHT_P; j += 1) begin
                image_r[i][j] <= image_i[i][j];
            end
        end
    end

    generate
        assign filtered_r[0][0] = 8'h00;
        assign filtered_r[WIDTH_P-1][0] = 8'h00;
        assign filtered_r[0][HEIGHT_P-1] = 8'h00;
        assign filtered_r[WIDTH_P-1][HEIGHT_P-1] = 8'h00;
        for (genvar i = 1; i < WIDTH_P-1; i = i + 1) begin
            assign filtered_r[i][0] = 8'h00;
            assign filtered_r[i][HEIGHT_P-1] = 8'h00;
        end
        for (genvar i = 1; i < HEIGHT_P-1; i = i + 1) begin
            assign filtered_r[0][i] = 8'h00;
            assign filtered_r[WIDTH_P-1][i] = 8'h00;
        end
    endgenerate

    generate
        for (genvar i = 1; i < WIDTH_P - 1; i = i + 1) begin
            for (genvar j = 1; j < HEIGHT_P - 1; j = j + 1) begin
                sobel_pixel_mask
                    #()
                sobel_pixel_mask_inst
                    (.p0_i(image_r[i - 1][j - 1])
                    ,.p1_i(image_r[i + 0][j - 1])
                    ,.p2_i(image_r[i + 1][j - 1])
                    ,.p3_i(image_r[i - 1][j + 0])
                    ,.p4_i(image_r[i + 0][j + 0])
                    ,.p5_i(image_r[i + 1][j + 0])
                    ,.p6_i(image_r[i - 1][j + 1])
                    ,.p7_i(image_r[i + 0][j + 1])
                    ,.p8_i(image_r[i + 1][j + 1])
                    ,.p4_o(filtered_r[i][j]));
            end
        end
    endgenerate

endmodule
