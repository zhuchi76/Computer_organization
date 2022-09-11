`timescale 1ns/1ps

//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    15:15:11 08/18/2013
// Design Name:
// Module Name:    alu
// Project Name:
// Target Devices:
// Tool versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

module alu(
           clk,           // system clock              (input)
           rst_n,         // negative reset            (input)
           src1,          // 32 bits source 1          (input)
           src2,          // 32 bits source 2          (input)
           ALU_control,   // 4 bits ALU control input  (input)
           result,        // 32 bits result            (output)
           zero,          // 1 bit when the output is 0, zero must be set (output)
           cout,          // 1 bit carry out           (output)
           overflow       // 1 bit overflow            (output)
           );

input           clk;
input           rst_n;
input  [32-1:0] src1;
input  [32-1:0] src2;
input   [4-1:0] ALU_control;

output [32-1:0] result;
output          zero;
output          cout;
output          overflow;

wire             zero;
wire             cout;
wire             overflow;

reg        [1:0] op;
wire      [31:0] carry;
reg              A_inv;
reg              B_inv;
reg              less_sig;
wire      [31:0] result_tmp;
reg    [31:0] src1_tmp, src2_tmp;
reg   [3:0] ALU_control_tmp;
wire			     set;
wire			     equal;
assign result = result_tmp;
assign carry[0] = (ALU_control_tmp==4'b0110)? 1: (ALU_control_tmp==4'b0111)? 1: 0; //sub slt: cin =1
assign zero = (result_tmp == 0) ? 1 : 0;
//assign overflow = carry[31] ^ cout;
assign equal = (src1 == src2_tmp) ? 1 : 0;
assign overflow = ( (ALU_control_tmp==4'b0000) & src1_tmp[31] & src2_tmp[31] & ~result_tmp[31]) ? 1 
					  :( (ALU_control_tmp==4'b0000) & ~src1_tmp[31] & ~src2_tmp[31] & result_tmp[31]) ? 1 
					  :( (ALU_control_tmp==4'b0110) & src1_tmp[31] & ~src2_tmp[31] & ~(result_tmp[31])) ? 1 
					  :( (ALU_control_tmp==4'b0110) & ~src1_tmp[31] & src2_tmp[31] & result_tmp[31]) ? 1 
					  : 0;
					  

always@( posedge clk or negedge rst_n ) begin
//always@(*) begin
    if(rst_n == 1) begin
        less_sig <= 1'b0;
        case(ALU_control)
           4'b0000: begin A_inv <= 0; B_inv <= 0; op <= 0; end // and
           4'b0001: begin A_inv <= 0; B_inv <= 0; op <= 1; end // or
           4'b0010: begin A_inv <= 0; B_inv <= 0; op <= 2; end // add
           4'b0110: begin A_inv <= 0; B_inv <= 1; op <= 2; end // sub
           4'b1100: begin A_inv <= 1; B_inv <= 1; op <= 0; end // nor
           4'b0111: begin A_inv <= 0; B_inv <= 1; op <= 3; end // set less than
           default:;
	   endcase
	   src1_tmp <= src1;
	   src2_tmp <= src2;
	   ALU_control_tmp <= ALU_control;
	   
	end
end


genvar i;
generate for(i = 0 ; i < 32 ; i = i + 1)
begin:ALU
        if( i==31) begin
                alu_last ALU( .src1(src1_tmp[31]), .src2(src2_tmp[31]), .less(less_sig), .A_invert(A_inv), .B_invert(B_inv),
					.cin(carry[31]), .operation(op), .result(result_tmp[31]), .cout(cout),
					.set(set), .equal(equal) );
        end
        else if ( i == 0 ) begin
                alu_top alu0( .src1(src1_tmp[0]), .src2(src2_tmp[0]), .less(set), .A_invert(A_inv), .B_invert(B_inv),
				  .cin(carry[0]), .operation(op), .result(result_tmp[0]), .cout(carry[1]) );
        end
        else begin
                alu_top ALU( .src1(src1_tmp[i]), .src2(src2_tmp[i]), .less(less_sig), .A_invert(A_inv), .B_invert(B_inv),
				  .cin(carry[i]), .operation(op), .result(result_tmp[i]), .cout(carry[i+1]) );
        end
end
endgenerate

endmodule
