//Subject:     CO project 2 - Decoder
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      Luke
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
`timescale 1ns/1ps
module Decoder(
    instr_op_i,
	RegWrite_o,
	ALU_op_o,
	ALUSrc_o,
	RegDst_o,
	Branch_o
	);
     
//I/O ports
input  [6-1:0] instr_op_i;

output         RegWrite_o;
output [2-1:0] ALU_op_o;
output         ALUSrc_o;
output         RegDst_o;
output         Branch_o;
 
//Internal Signals
reg    [2-1:0] ALU_op_o;
reg            ALUSrc_o;
reg            RegWrite_o;
reg            RegDst_o;
reg            Branch_o;

//Parameter


//Main function

always@ (*) begin
    case(instr_op_i)
        6'b000000: begin // R format
            RegDst_o = 1;
            ALUSrc_o = 0;
            RegWrite_o = 1;
            Branch_o = 0;
            ALU_op_o = 2'b11;
        end
        
        6'b001000: begin // addi
            RegDst_o = 0;
            ALUSrc_o = 1;
            RegWrite_o = 1;
            Branch_o = 0;
            ALU_op_o = 2'b00;
        end
        
        6'b001010: begin // slti
            RegDst_o = 0;
            ALUSrc_o = 1;
            RegWrite_o = 1;
            Branch_o = 0;
            ALU_op_o = 2'b01;
        end
        
        6'b000100: begin // beq
            RegDst_o = 1; // 0 or 1 ok
            ALUSrc_o = 0;
            RegWrite_o = 0;
            Branch_o = 1;
            ALU_op_o = 2'b10;
        end
   endcase
end         
endmodule





                    
                    