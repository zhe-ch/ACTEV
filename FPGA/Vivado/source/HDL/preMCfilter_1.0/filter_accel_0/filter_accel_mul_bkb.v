
`timescale 1 ns / 1 ps

  module filter_accel_mul_bkb_DSP48_0(a, b, p);
input signed [8 - 1 : 0] a;
input [11 - 1 : 0] b;
output signed [19 - 1 : 0] p;

assign p = $signed (a) * $signed ({1'b0, b});

endmodule
`timescale 1 ns / 1 ps
module filter_accel_mul_bkb(
    din0,
    din1,
    dout);

parameter ID = 32'd1;
parameter NUM_STAGE = 32'd1;
parameter din0_WIDTH = 32'd1;
parameter din1_WIDTH = 32'd1;
parameter dout_WIDTH = 32'd1;
input[din0_WIDTH - 1:0] din0;
input[din1_WIDTH - 1:0] din1;
output[dout_WIDTH - 1:0] dout;



filter_accel_mul_bkb_DSP48_0 filter_accel_mul_bkb_DSP48_0_U(
    .a( din0 ),
    .b( din1 ),
    .p( dout ));

endmodule
