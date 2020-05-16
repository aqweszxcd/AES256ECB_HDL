`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/04/30 13:43:14
// Design Name: 
// Module Name: testbench
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`include"include.vh"

module testbench(

);
reg rst,clk;
//encode
reg [7:0] encode_key[0:31] = { 8'h60, 8'h3d, 8'heb, 8'h10, 8'h15, 8'hca, 8'h71, 8'hbe, 8'h2b, 8'h73, 8'hae, 8'hf0, 8'h85, 8'h7d, 8'h77, 8'h81,
                      8'h1f, 8'h35, 8'h2c, 8'h07, 8'h3b, 8'h61, 8'h08, 8'hd7, 8'h2d, 8'h98, 8'h10, 8'ha3, 8'h09, 8'h14, 8'hdf, 8'hf4 };
reg [7:0] encode_in[0:(`channel_num-1)][0:3][0:3]=
{
{{8'h6b, 8'hc1, 8'hbe, 8'he2}, {8'h2e, 8'h40, 8'h9f, 8'h96}, {8'he9, 8'h3d, 8'h7e, 8'h11}, {8'h73, 8'h93, 8'h17, 8'h2a}},
{{8'h6b, 8'hc1, 8'hbe, 8'he2}, {8'h2e, 8'h40, 8'h9f, 8'h96}, {8'he9, 8'h3d, 8'h7e, 8'h11}, {8'h73, 8'h93, 8'h17, 8'h2a}},
{{8'h6b, 8'hc1, 8'hbe, 8'he2}, {8'h2e, 8'h40, 8'h9f, 8'h96}, {8'he9, 8'h3d, 8'h7e, 8'h11}, {8'h73, 8'h93, 8'h17, 8'h2a}},
{{8'h6b, 8'hc1, 8'hbe, 8'he2}, {8'h2e, 8'h40, 8'h9f, 8'h96}, {8'he9, 8'h3d, 8'h7e, 8'h11}, {8'h73, 8'h93, 8'h17, 8'h2a}}
};
reg encode_en_i;
wire [7:0] encode_out[0:(`channel_num-1)][0:3][0:3];
wire encode_en_o;
//decode
reg [7:0] decode_key[0:31] = { 8'h60, 8'h3d, 8'heb, 8'h10, 8'h15, 8'hca, 8'h71, 8'hbe, 8'h2b, 8'h73, 8'hae, 8'hf0, 8'h85, 8'h7d, 8'h77, 8'h81,
                      8'h1f, 8'h35, 8'h2c, 8'h07, 8'h3b, 8'h61, 8'h08, 8'hd7, 8'h2d, 8'h98, 8'h10, 8'ha3, 8'h09, 8'h14, 8'hdf, 8'hf4 };
reg [7:0] decode_in[0:(`channel_num-1)][0:3][0:3]=
{
{ {8'hf3, 8'hee, 8'hd1, 8'hbd}, {8'hb5, 8'hd2, 8'ha0, 8'h3c}, {8'h06, 8'h4b, 8'h5a, 8'h7e}, {8'h3d, 8'hb1, 8'h81, 8'hf8} },
{ {8'hf3, 8'hee, 8'hd1, 8'hbd}, {8'hb5, 8'hd2, 8'ha0, 8'h3c}, {8'h06, 8'h4b, 8'h5a, 8'h7e}, {8'h3d, 8'hb1, 8'h81, 8'hf8} },
{ {8'hf3, 8'hee, 8'hd1, 8'hbd}, {8'hb5, 8'hd2, 8'ha0, 8'h3c}, {8'h06, 8'h4b, 8'h5a, 8'h7e}, {8'h3d, 8'hb1, 8'h81, 8'hf8} },
{ {8'hf3, 8'hee, 8'hd1, 8'hbd}, {8'hb5, 8'hd2, 8'ha0, 8'h3c}, {8'h06, 8'h4b, 8'h5a, 8'h7e}, {8'h3d, 8'hb1, 8'h81, 8'hf8} }
};
reg decode_en_i;
wire [7:0] decode_out[0:(`channel_num-1)][0:3][0:3];
wire decode_en_o;


initial begin
rst=0;
clk=0;
encode_en_i=0;decode_en_i=0;
#30 rst=1;
#30 rst=0;
#1440 encode_en_i=1;decode_en_i=1;
end

always #10 clk=~clk;

AES AES_0(
.rst(rst),
.clk(clk),
.key(encode_key),
.in(encode_in),
.en_i(encode_en_i),
.out(encode_out),
.en_o(encode_en_o)
);
AES_D AES_D_0(
.rst(rst),
.clk(clk),
.key(decode_key),
.in(decode_in),
.en_i(decode_en_i),
.out(decode_out),
.en_o(decode_en_o)
);



endmodule












