//Subject:     CO project 2 - Decoder
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      Luke
//----------------------------------------------
//Date:        2010/8/16
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module Decoder(
    instr_op_i,
	RegWrite_o,
	ALU_op_o,
	ALUSrc_o,
	RegDst_o,
	Branch_o,
	Jump_o,
	MemRead_o,
	MemWrite_o,
	MemtoReg_o
	);
     
//I/O ports
input  [6-1:0] instr_op_i;

output         RegWrite_o;
output [2-1:0] ALU_op_o;//output [3-1:0] ALU_op_o;  
output         ALUSrc_o;
output [2-1:0] RegDst_o;
output         Branch_o;

//output [2-1:0]  BranchType_o;
output          Jump_o;
output      	MemRead_o;
output      	MemWrite_o;
output [2-1:0]  MemtoReg_o;
 
//Internal Signals
reg    [2-1:0] ALU_op_o;  //reg    [3-1:0] ALU_op_o;  
reg            ALUSrc_o;
reg            RegWrite_o;
reg    [2-1:0] RegDst_o;
reg            Branch_o;

//reg [2-1:0]  BranchType_o;
reg          Jump_o;
reg      	 MemRead_o;
reg      	 MemWrite_o;
reg [2-1:0]  MemtoReg_o;

//Parameter


//Main function

always @(*) begin
    case(instr_op_i[5:3]) // instr [31:29]
        3'b000: begin
                if(instr_op_i[2:0] == 3'b000) begin // R type
                    RegDst_o = 1;
                    ALUSrc_o = 0;
                    MemtoReg_o = 0;
                    RegWrite_o = 1;
                    MemRead_o = 0;
                    MemWrite_o = 0;
                    Branch_o = 0;
                    ALU_op_o = 2'b00;   //ALU_op_o = 3'b000;   
				    Jump_o = 0;
                end
                else begin // J & B
                    ALU_op_o = 2'b10;    //ALU_op_o = 3'b011;  
				    ALUSrc_o = 0;
				    Branch_o = 1;
				    MemRead_o = 0;
				    MemWrite_o = 0;
                    case (instr_op_i[2:0])
                        3'b010: begin // j
                            Jump_o = 1;
                            RegWrite_o = 0;
                        end
                        3'b011: begin // jal
                            Jump_o = 1;
                            RegWrite_o = 1;
                            RegDst_o = 2'd2;
                            MemtoReg_o = 2'd3;
                        end
                        3'b100: begin // beq
                            //BranchType_o = 2'd0;
                            Jump_o = 0;
                            RegWrite_o = 0;
                        end
                        /*
                        3'b101: begin // bne
                            //BranchType_o = 2'd3;
                            Jump_o = 0;
                            RegWrite_o = 0;
                        end
                        3'b001: begin // bge
                            //BranchType_o = 2'd2;
                            Jump_o = 0;
                            RegWrite_o = 0;
                        end
                        3'b111: begin // bgt
                            //BranchType_o = 2'd1;
                            Jump_o = 0;
                            RegWrite_o = 0;
                        end
                        */
				    endcase
                end
        end
        3'b001: begin // I-type
			ALUSrc_o = 1;
			RegWrite_o = 1;
			RegDst_o = 0;
			Branch_o = 0;
			Jump_o = 0;
			MemRead_o = 0;
			MemWrite_o = 0;
			MemtoReg_o = 0;
			case (instr_op_i[2:0])
				3'b000: ALU_op_o = 2'b01; // addi   3'b000: ALU_op_o = 3'b010;    
				3'b010: ALU_op_o = 2'b11; // slti    3'b010: ALU_op_o = 3'b111;    
				//3'b100: ALU_op_o = 3'b100; // andi
				//3'b101: ALU_op_o = 3'b101; // ori
				//3'b110: ALU_op_o = 3'b110; // xori
				//3'b111: ALU_op_o = 3'b010; // lui
			endcase
		end
		3'b100: begin // load
			ALU_op_o = 2'b01;    //ALU_op_o = 3'b010;   
			ALUSrc_o = 1;
			RegWrite_o = 1;
			RegDst_o = 0;
			Branch_o = 0;
			Jump_o = 0;
			MemRead_o = 1;
			MemWrite_o = 0;
			MemtoReg_o = 1;
		end
		3'b101: begin // store
			ALU_op_o = 2'b01;    //ALU_op_o = 3'b010;   
			ALUSrc_o = 1;
			RegWrite_o = 0;
			RegDst_o = 0;
			Branch_o = 0;
			Jump_o = 0;
			MemRead_o = 0;
			MemWrite_o = 1;
		end
    endcase
end
endmodule





                    
                    