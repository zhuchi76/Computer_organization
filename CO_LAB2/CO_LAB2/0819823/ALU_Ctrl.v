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
input      [2-1:0] ALUOp_i;

output     [4-1:0] ALUCtrl_o;    
     
//Internal Signals
reg        [4-1:0] ALUCtrl_o;

//Parameter

       
//Select exact operation
always@ (*) begin
    case (ALUOp_i)          
        2'b00: begin ALUCtrl_o = 4'b0010; end // addi
        2'b01: begin ALUCtrl_o = 4'b0111; end // slti
        2'b10: begin ALUCtrl_o = 4'b0110; end // beq
        2'b11: begin 
            case (funct_i)
                6'b100000: begin ALUCtrl_o = 4'b0010; end //add
                6'b100010: begin ALUCtrl_o = 4'b0110; end //sub
                6'b100100: begin ALUCtrl_o = 4'b0000; end //AND
                6'b100101: begin ALUCtrl_o = 4'b0001; end //OR
                6'b101010: begin ALUCtrl_o = 4'b0111; end //set in less than
            endcase
         end
    endcase
end
endmodule     





                    
                    