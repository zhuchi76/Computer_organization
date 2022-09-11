`timescale 1ns / 1ps
//Subject:     CO project 4 - Pipe CPU 1
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
module Pipe_CPU_1(
    clk_i,
    rst_i
    );
    
/****************************************
I/O ports
****************************************/
input clk_i;
input rst_i;

/****************************************
Internal signal
****************************************/
/**** IF stage ****/
wire [31:0]	pc_next_IF, pc_in_IF, pc_out_IF, instr_IF;

/**** ID stage ****/
wire [31:0]	pc_next_ID, instr_ID, RSdata_ID, RTdata_ID, extended_ID;

//control signal
wire 		RegWrite_ID, ALUSrc_ID, RegDst_ID, Branch_ID, MemRead_ID, MemWrite_ID, MemtoReg_ID;
wire [2:0]	ALU_op_ID;

/**** EX stage ****/
wire [31:0]	pc_next_EX, RSdata_EX, RTdata_EX, extended_EX, shifted_EX, selected_EX, result_EX, pc_branch_EX;
wire [4:0]	Dst0_EX, Dst1_EX, RDaddr_EX;

//control signal
wire [3:0]	ALUCtrl_EX;
wire [2:0]	ALU_op_EX, MEM_EX;
wire [1:0]	WB_EX;
wire		    RegDst_EX, ALUSrc_EX, zero_EX;

/**** MEM stage ****/
wire [31:0]	pc_branch_MEM, result_MEM, RTdata_MEM, Memdata_MEM;
wire [4:0]	RDaddr_MEM;

//control signal
wire [1:0]	WB_MEM;
wire 		Branch_MEM, MemRead_MEM, MemWrite_MEM, zero_MEM;

/**** WB stage ****/
wire [31:0]	RDdata_WB, Memdata_WB, result_WB;
wire [4:0]	RDaddr_WB;

//control signal
wire 		RegWrite_WB, MemtoReg_WB;

/****************************************
Instantiate modules
****************************************/
//Instantiate the components in IF stage
MUX_2to1 #(.size(32)) Mux0(
    .data0_i(pc_next_IF),
	.data1_i(pc_branch_MEM),
	.select_i(Branch_MEM & zero_MEM),
	.data_o(pc_in_IF)
);

ProgramCounter PC(
    .clk_i(clk_i),
	.rst_i(rst_i),
	.pc_in_i(pc_in_IF),
	.pc_out_o(pc_out_IF)
);

Instruction_Memory IM(
    .addr_i(pc_out_IF),
	.instr_o(instr_IF)
);
			
Adder Add_pc(
    .src1_i(pc_out_IF),
	.src2_i(32'd4),
	.sum_o(pc_next_IF)
);

		
Pipe_Reg #(.size(64)) IF_ID(       //N is the total length of input/output
    .clk_i(clk_i),
	.rst_i(rst_i),
	.data_i({pc_next_IF, instr_IF}),
	.data_o({pc_next_ID, instr_ID})
);


//Instantiate the components in ID stage
Reg_File RF(
    .clk_i(clk_i),
	.rst_i(rst_i),
	.RSaddr_i(instr_ID[25:21]),
	.RTaddr_i(instr_ID[20:16]),
	.RDaddr_i(RDaddr_WB),
	.RDdata_i(RDdata_WB),
	.RegWrite_i(RegWrite_WB),
	.RSdata_o(RSdata_ID),
	.RTdata_o(RTdata_ID)
);

Decoder Control(
    .instr_op_i(instr_ID[31:26]),
	.RegWrite_o(RegWrite_ID), //WB
	.ALU_op_o(ALU_op_ID), // EX
	.ALUSrc_o(ALUSrc_ID), // EX
	.RegDst_o(RegDst_ID), // EX
	.Branch_o(Branch_ID), // MEM
	.MemRead_o(MemRead_ID), // MEM
	.MemWrite_o(MemWrite_ID), // MEM
	.MemtoReg_o(MemtoReg_ID) // WB
);

Sign_Extend Sign_Extend(
    .data_i(instr_ID[15:0]),
	.data_o(extended_ID)
);	

Pipe_Reg #(.size(148)) ID_EX(
    .clk_i(clk_i),
	.rst_i(rst_i),
	.data_i({ RegWrite_ID, MemtoReg_ID, Branch_ID, MemRead_ID, MemWrite_ID, RegDst_ID, ALU_op_ID, ALUSrc_ID, pc_next_ID, RSdata_ID, RTdata_ID, extended_ID, instr_ID[20:11] }),
	.data_o({ WB_EX, MEM_EX, RegDst_EX, ALU_op_EX, ALUSrc_EX, pc_next_EX, RSdata_EX, RTdata_EX, extended_EX, Dst0_EX, Dst1_EX })
);


//Instantiate the components in EX stage	   
Shift_Left_Two_32 Shifter(
    .data_i(extended_EX),
	.data_o(shifted_EX)
);

MUX_2to1 #(.size(32)) Mux1(
    .data0_i(RTdata_EX),
	.data1_i(extended_EX),
	.select_i(ALUSrc_EX),
	.data_o(selected_EX)
);
		
ALU_Ctrl ALU_Ctrl(
    .funct_i(extended_EX[5:0]),
	.ALUOp_i(ALU_op_EX),
	.ALUCtrl_o(ALUCtrl_EX)
);


ALU ALU(
    .src1_i(RSdata_EX),
	.src2_i(selected_EX),
	.ctrl_i(ALUCtrl_EX),
	.result_o(result_EX),
	.zero_o(zero_EX)
);
		
MUX_2to1 #(.size(5)) Mux2(
    .data0_i(Dst0_EX),
	.data1_i(Dst1_EX),
	.select_i(RegDst_EX),
	.data_o(RDaddr_EX)
);

Adder Add_pc_branch(
    .src1_i(pc_next_EX),
	.src2_i(shifted_EX),
	.sum_o(pc_branch_EX)
);

Pipe_Reg #(.size(107)) EX_MEM(
	.clk_i(clk_i),
	.rst_i(rst_i),
	.data_i({WB_EX, MEM_EX, pc_branch_EX, zero_EX, result_EX, RTdata_EX, RDaddr_EX}),
	.data_o({WB_MEM, Branch_MEM, MemRead_MEM, MemWrite_MEM, pc_branch_MEM, zero_MEM, result_MEM, RTdata_MEM, RDaddr_MEM})
);


//Instantiate the components in MEM stage
Data_Memory DM(
    .clk_i(clk_i),
	.addr_i(result_MEM),
	.data_i(RTdata_MEM),
	.MemRead_i(MemRead_MEM),
	.MemWrite_i(MemWrite_MEM),
	.data_o(Memdata_MEM)
);

Pipe_Reg #(.size(71)) MEM_WB(
	.clk_i(clk_i),
	.rst_i(rst_i),
	.data_i({WB_MEM, Memdata_MEM, result_MEM, RDaddr_MEM}),
	.data_o({RegWrite_WB, MemtoReg_WB, Memdata_WB, result_WB, RDaddr_WB})
);


//Instantiate the components in WB stage
MUX_2to1 #(.size(32)) Mux3(
	.data0_i(result_WB),
	.data1_i(Memdata_WB),
	.select_i(MemtoReg_WB),
	.data_o(RDdata_WB)
);

/****************************************
signal assignment
****************************************/

endmodule

