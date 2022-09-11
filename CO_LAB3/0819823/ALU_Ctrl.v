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

module ALU_Ctrl(
          funct_i,
          ALUOp_i,
          ALUCtrl_o,
          jr_o
          );
          
//I/O ports 
input      [6-1:0] funct_i;
input      [2-1:0] ALUOp_i;   //input      [3-1:0] ALUOp_i;  

output     [4-1:0] ALUCtrl_o;    
output     jr_o;
     
//Internal Signals
reg        [4-1:0] ALUCtrl_o;
reg        jr_o;

//Parameter

       
//Select exact operation
always @(*) begin
    case(ALUOp_i)
        2'b00: begin  //3'b000: begin   // R type
                case(funct_i)
                    6'b001000: ALUCtrl_o = 4'b0000; // jr
                    6'b100000: ALUCtrl_o = 4'b0010; // add
                    6'b100010: ALUCtrl_o = 4'b0110; // sub
                    6'b100100: ALUCtrl_o = 4'b0000; // and
                    6'b100101: ALUCtrl_o = 4'b0001; // or
                    6'b100110: ALUCtrl_o = 4'b1111; // xor ???
                    6'b101010: ALUCtrl_o = 4'b0111; // slt
                endcase
        end
        2'b01:  ALUCtrl_o = 4'b0010; // addi / load / store   //3'b010:
        2'b10:  ALUCtrl_o = 4'b0110; // J & B    //3'b011:  
        //3'd4: ALUCtrl_o = 4'd0; // andi
		//3'd5: ALUCtrl_o = 4'd1; // ori
		//3'd6: ALUCtrl_o = 4'd15; // xori
		2'b11: ALUCtrl_o = 4'b0111; // slti   //3'b111:  
    endcase

    if(ALUOp_i == 2'd0 && funct_i == 6'b001000) begin // jr  //ALUOp_i == 3'd0
            jr_o = 1;
    end
    else begin
            jr_o = 0;
    end
end

endmodule     





                    
                    