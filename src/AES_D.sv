`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/04/30 11:48:10
// Design Name: 
// Module Name: AES
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

module AES_D(
input wire rst,
input wire clk,
input wire [7:0] key[0:31],
input wire [7:0] in[0:(`channel_num-1)][0:3][0:3],
input wire en_i,
output reg [7:0] out[0:(`channel_num-1)][0:3][0:3],
output reg en_o
);


//////////////////////////////////////////////Data//////////////////////////////////////////////
reg[7:0] sbox[0:255] = {
    //0     1    2      3     4    5     6     7      8    9     A      B    C     D     E     F
    8'h63, 8'h7c, 8'h77, 8'h7b, 8'hf2, 8'h6b, 8'h6f, 8'hc5, 8'h30, 8'h01, 8'h67, 8'h2b, 8'hfe, 8'hd7, 8'hab, 8'h76,
    8'hca, 8'h82, 8'hc9, 8'h7d, 8'hfa, 8'h59, 8'h47, 8'hf0, 8'had, 8'hd4, 8'ha2, 8'haf, 8'h9c, 8'ha4, 8'h72, 8'hc0,
    8'hb7, 8'hfd, 8'h93, 8'h26, 8'h36, 8'h3f, 8'hf7, 8'hcc, 8'h34, 8'ha5, 8'he5, 8'hf1, 8'h71, 8'hd8, 8'h31, 8'h15,
    8'h04, 8'hc7, 8'h23, 8'hc3, 8'h18, 8'h96, 8'h05, 8'h9a, 8'h07, 8'h12, 8'h80, 8'he2, 8'heb, 8'h27, 8'hb2, 8'h75,
    8'h09, 8'h83, 8'h2c, 8'h1a, 8'h1b, 8'h6e, 8'h5a, 8'ha0, 8'h52, 8'h3b, 8'hd6, 8'hb3, 8'h29, 8'he3, 8'h2f, 8'h84,
    8'h53, 8'hd1, 8'h00, 8'hed, 8'h20, 8'hfc, 8'hb1, 8'h5b, 8'h6a, 8'hcb, 8'hbe, 8'h39, 8'h4a, 8'h4c, 8'h58, 8'hcf,
    8'hd0, 8'hef, 8'haa, 8'hfb, 8'h43, 8'h4d, 8'h33, 8'h85, 8'h45, 8'hf9, 8'h02, 8'h7f, 8'h50, 8'h3c, 8'h9f, 8'ha8,
    8'h51, 8'ha3, 8'h40, 8'h8f, 8'h92, 8'h9d, 8'h38, 8'hf5, 8'hbc, 8'hb6, 8'hda, 8'h21, 8'h10, 8'hff, 8'hf3, 8'hd2,
    8'hcd, 8'h0c, 8'h13, 8'hec, 8'h5f, 8'h97, 8'h44, 8'h17, 8'hc4, 8'ha7, 8'h7e, 8'h3d, 8'h64, 8'h5d, 8'h19, 8'h73,
    8'h60, 8'h81, 8'h4f, 8'hdc, 8'h22, 8'h2a, 8'h90, 8'h88, 8'h46, 8'hee, 8'hb8, 8'h14, 8'hde, 8'h5e, 8'h0b, 8'hdb,
    8'he0, 8'h32, 8'h3a, 8'h0a, 8'h49, 8'h06, 8'h24, 8'h5c, 8'hc2, 8'hd3, 8'hac, 8'h62, 8'h91, 8'h95, 8'he4, 8'h79,
    8'he7, 8'hc8, 8'h37, 8'h6d, 8'h8d, 8'hd5, 8'h4e, 8'ha9, 8'h6c, 8'h56, 8'hf4, 8'hea, 8'h65, 8'h7a, 8'hae, 8'h08,
    8'hba, 8'h78, 8'h25, 8'h2e, 8'h1c, 8'ha6, 8'hb4, 8'hc6, 8'he8, 8'hdd, 8'h74, 8'h1f, 8'h4b, 8'hbd, 8'h8b, 8'h8a,
    8'h70, 8'h3e, 8'hb5, 8'h66, 8'h48, 8'h03, 8'hf6, 8'h0e, 8'h61, 8'h35, 8'h57, 8'hb9, 8'h86, 8'hc1, 8'h1d, 8'h9e,
    8'he1, 8'hf8, 8'h98, 8'h11, 8'h69, 8'hd9, 8'h8e, 8'h94, 8'h9b, 8'h1e, 8'h87, 8'he9, 8'hce, 8'h55, 8'h28, 8'hdf,
    8'h8c, 8'ha1, 8'h89, 8'h0d, 8'hbf, 8'he6, 8'h42, 8'h68, 8'h41, 8'h99, 8'h2d, 8'h0f, 8'hb0, 8'h54, 8'hbb, 8'h16 };
reg[7:0] rsbox[0:255] = {
  8'h52, 8'h09, 8'h6a, 8'hd5, 8'h30, 8'h36, 8'ha5, 8'h38, 8'hbf, 8'h40, 8'ha3, 8'h9e, 8'h81, 8'hf3, 8'hd7, 8'hfb,
  8'h7c, 8'he3, 8'h39, 8'h82, 8'h9b, 8'h2f, 8'hff, 8'h87, 8'h34, 8'h8e, 8'h43, 8'h44, 8'hc4, 8'hde, 8'he9, 8'hcb,
  8'h54, 8'h7b, 8'h94, 8'h32, 8'ha6, 8'hc2, 8'h23, 8'h3d, 8'hee, 8'h4c, 8'h95, 8'h0b, 8'h42, 8'hfa, 8'hc3, 8'h4e,
  8'h08, 8'h2e, 8'ha1, 8'h66, 8'h28, 8'hd9, 8'h24, 8'hb2, 8'h76, 8'h5b, 8'ha2, 8'h49, 8'h6d, 8'h8b, 8'hd1, 8'h25,
  8'h72, 8'hf8, 8'hf6, 8'h64, 8'h86, 8'h68, 8'h98, 8'h16, 8'hd4, 8'ha4, 8'h5c, 8'hcc, 8'h5d, 8'h65, 8'hb6, 8'h92,
  8'h6c, 8'h70, 8'h48, 8'h50, 8'hfd, 8'hed, 8'hb9, 8'hda, 8'h5e, 8'h15, 8'h46, 8'h57, 8'ha7, 8'h8d, 8'h9d, 8'h84,
  8'h90, 8'hd8, 8'hab, 8'h00, 8'h8c, 8'hbc, 8'hd3, 8'h0a, 8'hf7, 8'he4, 8'h58, 8'h05, 8'hb8, 8'hb3, 8'h45, 8'h06,
  8'hd0, 8'h2c, 8'h1e, 8'h8f, 8'hca, 8'h3f, 8'h0f, 8'h02, 8'hc1, 8'haf, 8'hbd, 8'h03, 8'h01, 8'h13, 8'h8a, 8'h6b,
  8'h3a, 8'h91, 8'h11, 8'h41, 8'h4f, 8'h67, 8'hdc, 8'hea, 8'h97, 8'hf2, 8'hcf, 8'hce, 8'hf0, 8'hb4, 8'he6, 8'h73,
  8'h96, 8'hac, 8'h74, 8'h22, 8'he7, 8'had, 8'h35, 8'h85, 8'he2, 8'hf9, 8'h37, 8'he8, 8'h1c, 8'h75, 8'hdf, 8'h6e,
  8'h47, 8'hf1, 8'h1a, 8'h71, 8'h1d, 8'h29, 8'hc5, 8'h89, 8'h6f, 8'hb7, 8'h62, 8'h0e, 8'haa, 8'h18, 8'hbe, 8'h1b,
  8'hfc, 8'h56, 8'h3e, 8'h4b, 8'hc6, 8'hd2, 8'h79, 8'h20, 8'h9a, 8'hdb, 8'hc0, 8'hfe, 8'h78, 8'hcd, 8'h5a, 8'hf4,
  8'h1f, 8'hdd, 8'ha8, 8'h33, 8'h88, 8'h07, 8'hc7, 8'h31, 8'hb1, 8'h12, 8'h10, 8'h59, 8'h27, 8'h80, 8'hec, 8'h5f,
  8'h60, 8'h51, 8'h7f, 8'ha9, 8'h19, 8'hb5, 8'h4a, 8'h0d, 8'h2d, 8'he5, 8'h7a, 8'h9f, 8'h93, 8'hc9, 8'h9c, 8'hef,
  8'ha0, 8'he0, 8'h3b, 8'h4d, 8'hae, 8'h2a, 8'hf5, 8'hb0, 8'hc8, 8'heb, 8'hbb, 8'h3c, 8'h83, 8'h53, 8'h99, 8'h61,
  8'h17, 8'h2b, 8'h04, 8'h7e, 8'hba, 8'h77, 8'hd6, 8'h26, 8'he1, 8'h69, 8'h14, 8'h63, 8'h55, 8'h21, 8'h0c, 8'h7d };
reg[7:0] rcon[0:10]={8'h8d, 8'h01, 8'h02, 8'h04, 8'h08, 8'h10, 8'h20, 8'h40, 8'h80, 8'h1b, 8'h36};


//////////////////////////////////////////////Function//////////////////////////////////////////////
function [7:0] xtime(input[7:0] x);
begin
    xtime = ((x << 1) ^ (((x >> 7) & 1) * 8'h1b));
end
endfunction

function [7:0] Multiply(input[7:0] x, input[7:0] y);
begin
    Multiply = (((y&1)*x)^(( (y>>1)&1)*xtime(x))^(( (y>>2)&1)*xtime(xtime(x)))^(( (y>>3)&1)*xtime(xtime(xtime(x))))^(( (y>>4)&1)*xtime(xtime(xtime(xtime(x))))));
end
endfunction

//////////////////////////////////////////////RoundKey//////////////////////////////////////////////
int i,j,k,channel,roundkey_num,round;
reg[7:0] roundkey[0:239];
always@(posedge clk)begin
if(rst)begin
    for(i = 0; i < 240; ++i)begin
        roundkey[i] <= 0;
    end
    roundkey_num<=0;
end
else begin
    // The first round key is the key itself.
    if(roundkey_num < 4 * (14 + 1))begin
        if( roundkey_num<8 )begin
            roundkey[(roundkey_num * 4) + 0] <= key[(roundkey_num * 4) + 0];
            roundkey[(roundkey_num * 4) + 1] <= key[(roundkey_num * 4) + 1];
            roundkey[(roundkey_num * 4) + 2] <= key[(roundkey_num * 4) + 2];
            roundkey[(roundkey_num * 4) + 3] <= key[(roundkey_num * 4) + 3];
        end
        // All other round keys are found from the previous round keys.
        else if((roundkey_num%8)==0)begin
            roundkey[roundkey_num*4+0] <= roundkey[(roundkey_num-8)*4+0]^(sbox[ roundkey[((roundkey_num-1)*4)+1] ]^rcon[roundkey_num/8]);
            roundkey[roundkey_num*4+1] <= roundkey[(roundkey_num-8)*4+1]^(sbox[ roundkey[((roundkey_num-1)*4)+2] ]);
            roundkey[roundkey_num*4+2] <= roundkey[(roundkey_num-8)*4+2]^(sbox[ roundkey[((roundkey_num-1)*4)+3] ]);
            roundkey[roundkey_num*4+3] <= roundkey[(roundkey_num-8)*4+3]^(sbox[ roundkey[((roundkey_num-1)*4)+0] ]);
        end
        else if((roundkey_num%8)==4)begin
            roundkey[roundkey_num*4+0] <= roundkey[(roundkey_num-8)*4+0]^(sbox[ roundkey[((roundkey_num-1)*4)+0] ]);
            roundkey[roundkey_num*4+1] <= roundkey[(roundkey_num-8)*4+1]^(sbox[ roundkey[((roundkey_num-1)*4)+1] ]);
            roundkey[roundkey_num*4+2] <= roundkey[(roundkey_num-8)*4+2]^(sbox[ roundkey[((roundkey_num-1)*4)+2] ]);
            roundkey[roundkey_num*4+3] <= roundkey[(roundkey_num-8)*4+3]^(sbox[ roundkey[((roundkey_num-1)*4)+3] ]);
        end
        else begin
            roundkey[roundkey_num*4+0] <= roundkey[(roundkey_num-8)*4+0]^roundkey[(roundkey_num-1)*4+0];
            roundkey[roundkey_num*4+1] <= roundkey[(roundkey_num-8)*4+1]^roundkey[(roundkey_num-1)*4+1];
            roundkey[roundkey_num*4+2] <= roundkey[(roundkey_num-8)*4+2]^roundkey[(roundkey_num-1)*4+2];
            roundkey[roundkey_num*4+3] <= roundkey[(roundkey_num-8)*4+3]^roundkey[(roundkey_num-1)*4+3];
        end
        roundkey_num<=roundkey_num+1;
    end
end
end




reg[7:0] data[0:(`channel_num-1)][-3:60][0:3][0:3];//64层中间变量
reg data_en[0:(`channel_num-1)][-3:60];//64层中间变量使能
always@(posedge clk)begin
for(channel = 0; channel < `channel_num; ++channel)begin
if(rst)begin
    for(k = 0; k < 64; ++k)begin
        for(i = 0; i < 4; ++i)begin
            for(j = 0; j < 4; ++j)begin
                data[channel][k][i][j]<=0;
            end
        end
        data_en[channel][k]<=0;
    end
    for(i = 0; i < 4; ++i)begin
        for(j = 0; j < 4; ++j)begin
            out[channel][i][j]<=0;
        end
    end
    en_o<=0;
end
else if(roundkey_num >= 4 * (14 + 1))begin
    //////////////////////////////////////////////input//////////////////////////////////////////////
    // Add the First round key to the state before starting the rounds.
    if(en_i)begin
    for (i = 0; i < 4; ++i)begin
        for (j = 0; j < 4; ++j)begin
            data[channel][52][i][j]<=in[channel][i][j]^roundkey[(14*4*4)+(i*4)+j];
        end
    end
    data_en[channel][52]<=1;
    end
    else begin data_en[channel][52]<=0;end
    // Last one without MixColumns()
    for (round = 13; round > 0; --round)begin
        //InvShiftRows((state_t*)in);
        if(data_en[channel][4*(round-1)+4])begin
            data[channel][4*(round-1)+3][0][0] <= data[channel][4*(round-1)+4][0][0];data[channel][4*(round-1)+3][0][1] <= data[channel][4*(round-1)+4][3][1];data[channel][4*(round-1)+3][0][2] <= data[channel][4*(round-1)+4][2][2];data[channel][4*(round-1)+3][0][3] <= data[channel][4*(round-1)+4][1][3];
            data[channel][4*(round-1)+3][1][0] <= data[channel][4*(round-1)+4][1][0];data[channel][4*(round-1)+3][1][1] <= data[channel][4*(round-1)+4][0][1];data[channel][4*(round-1)+3][1][2] <= data[channel][4*(round-1)+4][3][2];data[channel][4*(round-1)+3][1][3] <= data[channel][4*(round-1)+4][2][3];
            data[channel][4*(round-1)+3][2][0] <= data[channel][4*(round-1)+4][2][0];data[channel][4*(round-1)+3][2][1] <= data[channel][4*(round-1)+4][1][1];data[channel][4*(round-1)+3][2][2] <= data[channel][4*(round-1)+4][0][2];data[channel][4*(round-1)+3][2][3] <= data[channel][4*(round-1)+4][3][3];
            data[channel][4*(round-1)+3][3][0] <= data[channel][4*(round-1)+4][3][0];data[channel][4*(round-1)+3][3][1] <= data[channel][4*(round-1)+4][2][1];data[channel][4*(round-1)+3][3][2] <= data[channel][4*(round-1)+4][1][2];data[channel][4*(round-1)+3][3][3] <= data[channel][4*(round-1)+4][0][3];
            data_en[channel][4*(round-1)+3]<=1;
        end
        else begin data_en[channel][4*(round-1)+3]<=0;end
        //InvSubBytes((state_t*)in);
        if(data_en[channel][4*(round-1)+3])begin
        for (i = 0; i < 4; ++i)begin
            for (j = 0; j < 4; ++j)begin
                data[channel][4*(round-1)+2][i][j]<=rsbox[data[channel][4*(round-1)+3][i][j]];
            end
        end
        data_en[channel][4*(round-1)+2]<=1;
        end
        else begin data_en[channel][4*(round-1)+2]<=0;end
        //AddRoundKey(round, (state_t*)in, RoundKey);
        if(data_en[channel][4*(round-1)+2])begin
        for (i = 0; i < 4; ++i)begin
            for (j = 0; j < 4; ++j)begin
                data[channel][4*(round-1)+1][i][j]<=data[channel][4*(round-1)+2][i][j]^roundkey[(round*4*4)+(i*4)+j];
            end
        end
        data_en[channel][4*(round-1)+1]<=1;
        end
        else begin data_en[channel][4*(round-1)+1]<=0;end
        //InvMixColumns((state_t*)in);
        if(data_en[channel][4*(round-1)+1])begin
        for (i = 0; i < 4; ++i)begin
            data[channel][4*(round-1)+0][i][0] = Multiply(data[channel][4*(round-1)+1][i][0], 8'h0e) ^ Multiply(data[channel][4*(round-1)+1][i][1], 8'h0b) ^ Multiply(data[channel][4*(round-1)+1][i][2], 8'h0d) ^ Multiply(data[channel][4*(round-1)+1][i][3], 8'h09);
            data[channel][4*(round-1)+0][i][1] = Multiply(data[channel][4*(round-1)+1][i][0], 8'h09) ^ Multiply(data[channel][4*(round-1)+1][i][1], 8'h0e) ^ Multiply(data[channel][4*(round-1)+1][i][2], 8'h0b) ^ Multiply(data[channel][4*(round-1)+1][i][3], 8'h0d);
            data[channel][4*(round-1)+0][i][2] = Multiply(data[channel][4*(round-1)+1][i][0], 8'h0d) ^ Multiply(data[channel][4*(round-1)+1][i][1], 8'h09) ^ Multiply(data[channel][4*(round-1)+1][i][2], 8'h0e) ^ Multiply(data[channel][4*(round-1)+1][i][3], 8'h0b);
            data[channel][4*(round-1)+0][i][3] = Multiply(data[channel][4*(round-1)+1][i][0], 8'h0b) ^ Multiply(data[channel][4*(round-1)+1][i][1], 8'h0d) ^ Multiply(data[channel][4*(round-1)+1][i][2], 8'h09) ^ Multiply(data[channel][4*(round-1)+1][i][3], 8'h0e);
        end
        data_en[channel][4*(round-1)+0]<=1;
        end
        else begin data_en[channel][4*(round-1)+0]<=0;end
    end
    round=0;
        //InvShiftRows((state_t*)in);
        if(data_en[channel][4*(round-1)+4])begin
            data[channel][4*(round-1)+3][0][0] <= data[channel][4*(round-1)+4][0][0];data[channel][4*(round-1)+3][0][1] <= data[channel][4*(round-1)+4][3][1];data[channel][4*(round-1)+3][0][2] <= data[channel][4*(round-1)+4][2][2];data[channel][4*(round-1)+3][0][3] <= data[channel][4*(round-1)+4][1][3];
            data[channel][4*(round-1)+3][1][0] <= data[channel][4*(round-1)+4][1][0];data[channel][4*(round-1)+3][1][1] <= data[channel][4*(round-1)+4][0][1];data[channel][4*(round-1)+3][1][2] <= data[channel][4*(round-1)+4][3][2];data[channel][4*(round-1)+3][1][3] <= data[channel][4*(round-1)+4][2][3];
            data[channel][4*(round-1)+3][2][0] <= data[channel][4*(round-1)+4][2][0];data[channel][4*(round-1)+3][2][1] <= data[channel][4*(round-1)+4][1][1];data[channel][4*(round-1)+3][2][2] <= data[channel][4*(round-1)+4][0][2];data[channel][4*(round-1)+3][2][3] <= data[channel][4*(round-1)+4][3][3];
            data[channel][4*(round-1)+3][3][0] <= data[channel][4*(round-1)+4][3][0];data[channel][4*(round-1)+3][3][1] <= data[channel][4*(round-1)+4][2][1];data[channel][4*(round-1)+3][3][2] <= data[channel][4*(round-1)+4][1][2];data[channel][4*(round-1)+3][3][3] <= data[channel][4*(round-1)+4][0][3];
            data_en[channel][4*(round-1)+3]<=1;
        end
        else begin data_en[channel][4*(round-1)+3]<=0;end
        //InvSubBytes((state_t*)in);
        if(data_en[channel][4*(round-1)+3])begin
        for (i = 0; i < 4; ++i)begin
            for (j = 0; j < 4; ++j)begin
                data[channel][4*(round-1)+2][i][j]<=rsbox[data[channel][4*(round-1)+3][i][j]];
            end
        end
        data_en[channel][4*(round-1)+2]<=1;
        end
        else begin data_en[channel][4*(round-1)+2]<=0;end
        //AddRoundKey(round, (state_t*)in, RoundKey);
        if(data_en[channel][4*(round-1)+2])begin
        for (i = 0; i < 4; ++i)begin
            for (j = 0; j < 4; ++j)begin
                data[channel][4*(round-1)+1][i][j]<=data[channel][4*(round-1)+2][i][j]^roundkey[(round*4*4)+(i*4)+j];
            end
        end
        data_en[channel][4*(round-1)+1]<=1;
        end
        else begin data_en[channel][4*(round-1)+1]<=0;end
        
        
    //////////////////////////////////////////////output//////////////////////////////////////////////
    if(data_en[channel][4*(round-1)+1])begin
        for (i = 0; i < 4; ++i)begin
            for (j = 0; j < 4; ++j)begin
                out[channel][i][j]<=data[channel][4*(round-1)+1][i][j];
            end
        end
        en_o<=1;
    end
    else begin en_o<=0;end
        
end
else begin
    for (i = 0; i < 4; ++i)begin
        for (j = 0; j < 4; ++j)begin
            out[channel][i][j]<=0;
        end
    end
    en_o<=0;
end
end//channel
end//posedge clk






endmodule





















