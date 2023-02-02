module sobel_pixel_mask
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

    wire signed [10:0] gx, gy;    //11 bits because max value of gx and gy is  
    //255*4 and last bit for sign					 
    wire signed [10:0] abs_gx, abs_gy;	//it is used to find the absolute value of gx and gy 
    wire [10:0] sum;			//the max value is 255*8. here no sign bit needed. 

    assign gx = ((p2_i - p0_i) + ((p5_i - p3_i) << 1) + (p8_i - p6_i));//sobel mask for gradient in horiz. direction 
    assign gy = ((p0_i - p6_i) + ((p1_i - p7_i) << 1) + (p2_i - p8_i));//sobel mask for gradient in vertical direction 

    assign abs_gx = (gx[10] ? ~gx + 1 : gx);	// to find the absolute value of gx. 
    assign abs_gy = (gy[10] ? ~gy + 1 : gy);	// to find the absolute value of gy. 

    assign sum  = (abs_gx + abs_gy);				// finding the sum 
    assign p4_o = (|sum[10:8]) ? 8'hff : sum[7:0];	// to limit the max value to 255  

endmodule
