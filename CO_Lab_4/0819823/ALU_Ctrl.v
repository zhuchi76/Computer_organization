//Subject:     CO project 2 - ALU Controller
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
`timescale 1ns/1ps
module ALU_Ctrl(
          funct_i,
          ALUOp_i,
          ALUCtrl_o
          );
          
//I/O ports 
input      [6-1:0] funct_i;
input      [3-1:0] ALUOp_i;

output     [4-1:0] ALUCtrl_o;    
     
//Internal Signals
reg        [4-1:0] ALUCtrl_o;

//Parameter

       
//Select exact operation
always@ (*) begin
    case (ALUOp_i)
        3'b000: begin 
            case (funct_i)
                6'b100000: begin ALUCtrl_o = 4'b0010; end //add
                6'b100010: begin ALUCtrl_o = 4'b0110; end //sub
                6'b100100: begin ALUCtrl_o = 4'b0000; end //AND
                6'b100101: begin ALUCtrl_o = 4'b0001; end //OR
                6'b011000: begin ALUCtrl_o = 4'b1111; end //MULT
                6'b101010: begin ALUCtrl_o = 4'b0111; end //slt
                default: ALUCtrl_o = 4'b0000;
            endcase
         end          
        3'b010: begin ALUCtrl_o = 4'b0010; end // addi / lw / sw
        3'b111: begin ALUCtrl_o = 4'b0111; end // slti
        3'b011: begin ALUCtrl_o = 4'b0110; end // beq
        
    endcase
end
endmodule     





                    
                    