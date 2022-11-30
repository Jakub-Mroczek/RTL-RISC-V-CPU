
/* Your Code Below! Enable the following define's 
 * and replace ??? with actual wires */
// ----- signals -----
// You will also need to define PC properly
`define F_PC                PD4_F_PC
`define F_INSN              PD4_F_INSN

`define D_PC                PD4_D_PC
`define D_OPCODE            PD4_D_OPCODE
`define D_RD                PD4_D_RD
`define D_RS1               PD4_D_RS1
`define D_RS2               PD4_D_RS2
`define D_FUNCT3            PD4_D_FUNCT3
`define D_FUNCT7            PD4_D_FUNCT7
`define D_IMM               PD4_D_IMM
`define D_SHAMT             PD4_D_SHAMT

`define R_WRITE_ENABLE      PD4_R_WRITE_ENABLE
`define R_WRITE_DESTINATION PD4_R_WRITE_DESTINATION
`define R_WRITE_DATA        PD4_W_DATA
`define R_READ_RS1          PD4_R_READ_RS1
`define R_READ_RS2          PD4_R_READ_RS2
`define R_READ_RS1_DATA     PD4_R_READ_RS1_DATA
`define R_READ_RS2_DATA     PD4_R_READ_RS2_DATA

`define E_PC                PD4_E_PC
`define E_ALU_RES           PD4_E_ALU_RES
`define E_BR_TAKEN          PD4_E_BR_TAKEN

`define M_PC                PD4_M_PC
`define M_ADDRESS           PD4_M_ADDRESS
`define M_RW                PD4_M_RW
`define M_SIZE_ENCODED      PD4_M_SIZE_ENCODED
`define M_DATA              PD4_M_DATA

`define W_PC                PD4_W_PC
`define W_ENABLE            PD4_R_WRITE_ENABLE
`define W_DESTINATION       PD4_R_WRITE_DESTINATION
`define W_DATA              PD4_W_DATA

// ----- signals -----

// ----- design -----
`define TOP_MODULE                 pd
// ----- design -----
