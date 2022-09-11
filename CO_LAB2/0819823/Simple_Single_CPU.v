//Subject:     CO project 2 - Simple Single CPU
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
module Simple_Single_CPU(
        clk_i,
		rst_i
		);
		
//I/O port
input         clk_i;
input         rst_i;

//Internal Signles

// PC Wire
wire [32-1:0] PC_in;
wire [32-1:0] PC_out;

//Greate componentes
ProgramCounter PC(
        .clk_i(clk_i),      
	    .rst_i (rst_i),     
	    .pc_in_i(PC_in) ,   
	    .pc_out_o(PC_out) 
	    );

wire [32-1:0] PC_add1;	
Adder Adder1(
        .src1_i(PC_out),     
	    .src2_i(32'd4),     
	    .sum_o(PC_add1)    
	    );

wire [32-1:0] Instr;	
Instr_Memory IM(
        .pc_addr_i(PC_out),  
	    .instr_o(Instr)    
	    );

wire RegDst;
wire Branch;
//wire MemRead;
//wire MemtoReg;
wire [2-1:0]ALUop;
//wire Memwrite;
wire ALU_src;
wire RegWrite;
Decoder Decoder(
        .instr_op_i(Instr[31:26]), 
	    .RegWrite_o(RegWrite), 
	    .ALU_op_o(ALUop),   
	    .ALUSrc_o(ALU_src),   
	    .RegDst_o(RegDst),   
		.Branch_o(Branch)   
	    );
	    
wire [5-1:0]WriteReg; // RD or RT
MUX_2to1 #(.size(5)) Mux_Write_Reg(
        .data0_i(Instr[20:16]),
        .data1_i(Instr[15:11]),
        .select_i(RegDst),
        .data_o(WriteReg)
        );	

wire [32-1:0]Read_data1;
wire [32-1:0]Read_data2;	
wire [32-1:0]Write_data;
Reg_File RF(
        .clk_i(clk_i),      
	    .rst_i(rst_i) ,     
        .RSaddr_i(Instr[25:21]) ,  
        .RTaddr_i(Instr[20:16]) ,  
        .RDaddr_i(WriteReg) ,  
        .RDdata_i(Write_data)  , 
        .RegWrite_i(RegWrite),
        .RSdata_o(Read_data1) ,  
        .RTdata_o(Read_data2)   
        );

wire [4-1:0] ALUCtrl;
ALU_Ctrl AC(
        .funct_i(Instr[5:0]),   
        .ALUOp_i(ALUop),   
        .ALUCtrl_o(ALUCtrl) 
        );
	
wire [32-1:0] Offset;
Sign_Extend SE(
        .data_i(Instr[15:0]),
        .data_o(Offset)
        );

wire [32-1:0] ALU_src2;
MUX_2to1 #(.size(32)) Mux_ALUSrc(
        .data0_i(Read_data2),
        .data1_i(Offset),
        .select_i(ALU_src),
        .data_o(ALU_src2)
        );	

wire Zero;
ALU ALU(
        .src1_i(Read_data1),
	    .src2_i(ALU_src2),
	    .ctrl_i(ALUCtrl),
	    .result_o(Write_data),
		.zero_o(Zero)
	    );

wire [32-1:0] PCALU_src2;
Shift_Left_Two_32 Shifter(
        .data_i(Offset),
        .data_o(PCALU_src2)
        ); 		

wire [32-1:0] PC_add2;	
Adder Adder2(
        .src1_i(PC_add1),     
	    .src2_i(PCALU_src2),     
	    .sum_o(PC_add2)      
	    );

//wire PCMuxCtrl = Branch & Zero;
wire PCMuxCtrl;
and(PCMuxCtrl, Branch, Zero);	

MUX_2to1 #(.size(32)) Mux_PC_Source(
        .data0_i(PC_add1),
        .data1_i(PC_add2),
        .select_i(PCMuxCtrl),
        .data_o(PC_in)
        );	

endmodule
		  


