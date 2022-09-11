//Subject:     CO project 2 - ALU
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module ALU(
    src1_i,
	src2_i,
	ctrl_i,
	result_o,
	zero_o
	);
     
//I/O ports
input  [32-1:0]  src1_i;
input  [32-1:0]	 src2_i;
input  [4-1:0]   ctrl_i;

output [32-1:0]	 result_o;
output           zero_o;

//Internal signals
reg    [32-1:0]  result_o;
//wire             zero_o;

//Parameter

//Main function
assign zero_o = (result_o == 0);
always @(ctrl_i, src1_i, src2_i) begin
    case(ctrl_i)
        0: result_o <= src1_i & src2_i;
        1: result_o <= src1_i | src2_i;
        2: result_o <= src1_i + src2_i;
        6: result_o <= src1_i - src2_i;
        7: result_o <= src1_i < src2_i ? 1:0;
        12: result_o <= ~(src1_i | src2_i); //nor
        15: result_o <= src1_i ^ src2_i; //xor
        default: result_o <= 0;
    endcase
end
/*
assign zero_o = (result_o == 0)? 1 : 0;
always @(src1_i, src2_i, ctrl_i) begin
	case(ctrl_i)
		4'b0000: result_o = src1_i & src2_i; //  and
		4'b0001: result_o = src1_i | src2_i; //  or
		4'b0010: result_o = src1_i + src2_i; // add
		4'b0110: result_o = src1_i - src2_i; // sub
		4'b0111: result_o = (src1_i < src2_i)? 1 : 0; // slt
		4'b1100: result_o = ~(src1_i | src2_i); // Nor
		4'b1111: result_o = src1_i ^ src2_i; // xor
	endcase
end
*/

endmodule





                    
                    