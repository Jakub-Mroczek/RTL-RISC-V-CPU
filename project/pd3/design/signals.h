
/* Your Code Below! Enable the following define's 
 * and replace ??? with actual wires */
// ----- signals -----
// You will also need to define PC properly
`define F_PC                PD3_F_PC
`define F_INSN              PD3_F_INSN

`define D_PC                PD3_D_PC
`define D_OPCODE            PD3_D_OPCODE
`define D_RD                PD3_D_RD
`define D_RS1               PD3_D_RS1
`define D_RS2               PD3_D_RS2
`define D_FUNCT3            PD3_D_FUNCT3
`define D_FUNCT7            PD3_D_FUNCT7
`define D_IMM               PD3_D_IMM
`define D_SHAMT             PD3_D_SHAMT

`define R_WRITE_ENABLE      PD3_R_WRITE_ENABLE
`define R_WRITE_DESTINATION PD3_R_WRITE_DESTINATION
`define R_WRITE_DATA        PD3_R_WRITE_DATA
`define R_READ_RS1          PD3_R_READ_RS1
`define R_READ_RS2          PD3_R_READ_RS2
`define R_READ_RS1_DATA     PD3_R_READ_RS1_DATA
`define R_READ_RS2_DATA     PD3_R_READ_RS2_DATA

`define E_PC                PD3_E_PC
`define E_ALU_RES           PD3_E_ALU_RES
`define E_BR_TAKEN          PD3_E_BR_TAKEN

// ----- signals -----

// ----- design -----
`define TOP_MODULE          pd
// ----- design -----
