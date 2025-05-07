module seven_segment_decoder #(parameter COMMON_ANODE = 1) (
input [3:0] i_data, // 4-bit binary input
output reg [6:0] o_display // 7-segment output (a, b, c, d, e, f, g)
);
always @(*) begin
case (i_data)
4'b0000: o_display = 7'b0111111; // 0
4'b0001: o_display = 7'b0000110; // 1
4'b0010: o_display = 7'b1011011; // 2
4'b0011: o_display = 7'b1001111; // 3
4'b0100: o_display = 7'b1100110; // 4
4'b0101: o_display = 7'b1101101; // 5
4'b0110: o_display = 7'b1111101; // 6
4'b0111: o_display = 7'b0000111; // 7
4'b1000: o_display = 7'b1111111; // 8
4'b1001: o_display = 7'b1101111; // 9
4'b1010: o_display = 7'b1110111; // A
4'b1011: o_display = 7'b1111100; // B
4'b1100: o_display = 7'b0111001; // C
4'b1101: o_display = 7'b1011110; // D
4'b1110: o_display = 7'b1111001; // E
4'b1111: o_display = 7'b1110001; // F
default: o_display = 7'b0000000; // Blank
endcase
// If it's common anode, invert the output
if (COMMON_ANODE)
o_display = ~o_display;
end
endmodule