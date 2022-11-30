
/* Your Code Below! Enable the following define's 
 * and replace ??? with actual wires */
// ----- signals -----
// You will also need to define PC properly
`define F_PC                PD5_F_PC
`define F_INSN              PD5_F_INSN

`define D_PC                PD5_D_PC
`define D_OPCODE            PD5_D_OPCODE
`define D_RD                PD5_D_RD
`define D_RS1               PD5_D_RS1
`define D_RS2               PD5_D_RS2
`define D_FUNCT3            PD5_D_FUNCT3
`define D_FUNCT7            PD5_D_FUNCT7
`define D_IMM               PD5_D_IMM
`define D_SHAMT             PD5_D_SHAMT

`define R_WRITE_ENABLE      PD5_R_WRITE_ENABLE
`define R_WRITE_DESTINATION PD5_R_WRITE_DESTINATION
`define R_WRITE_DATA        PD5_W_DATA
`define R_READ_RS1          PD5_R_READ_RS1
`define R_READ_RS2          PD5_R_READ_RS2
`define R_READ_RS1_DATA     PD5_R_READ_RS1_DATA
`define R_READ_RS2_DATA     PD5_R_READ_RS2_DATA

`define E_PC                PD5_E_PC
`define E_ALU_RES           PD5_E_ALU_RES
`define E_BR_TAKEN          PD5_E_BR_TAKEN

`define M_PC                PD5_M_PC
`define M_ADDRESS           PD5_M_ADDRESS
`define M_RW                PD5_M_RW
`define M_SIZE_ENCODED      PD5_M_SIZE_ENCODED
`define M_DATA              PD5_M_DATA

`define W_PC                PD5_W_PC
`define W_ENABLE            PD5_R_WRITE_ENABLE
`define W_DESTINATION       PD5_R_WRITE_DESTINATION
`define W_DATA              PD5_W_DATA

// ----- signals -----

// ----- design -----
`define TOP_MODULE                 pd
// ----- design -----
