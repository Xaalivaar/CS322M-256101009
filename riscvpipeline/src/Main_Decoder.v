
module Main_Decoder(
    input  logic [6:0] Op,
    output logic       RegWrite,
    output logic [1:0] ImmSrc,
    output logic       ALUSrc,
    output logic       MemWrite,
    output logic       ResultSrc,
    output logic       Branch,
    output logic [1:0] ALUOp
);

    localparam int CONTROL_WIDTH = 9;

    function automatic logic [CONTROL_WIDTH-1:0] decode_op(logic [6:0] op_code);
        logic [CONTROL_WIDTH-1:0] control_word = 9'b000_000_000;

        case (op_code)
            7'b0000011: control_word = 9'b1_00_1_0_1_0_00; // Load (LW)
            7'b0010011: control_word = 9'b1_00_1_0_0_0_00; // Imm Arith (ADDI)
            7'b0110011: control_word = 9'b1_00_0_0_0_0_10; // Reg Arith (ADD)
            7'b0100011: control_word = 9'b0_01_1_1_0_0_00; // Store (SW)
            7'b1100011: control_word = 9'b0_10_0_0_0_1_01; // Branch (BEQ)
            7'b0001011: control_word = 9'b1_00_0_0_0_0_11; // RVX type
            default:    control_word = 9'b0_00_0_0_0_0_00; // Default (covered above)
        endcase

        return control_word;
    endfunction
    
    assign {RegWrite, ImmSrc, ALUSrc, MemWrite, ResultSrc, Branch, ALUOp} = decode_op(Op);

endmodule