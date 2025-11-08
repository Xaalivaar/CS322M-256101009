module ALU_Decoder(
    input  logic [1:0] ALUOp,
    input  logic [2:0] funct3,
    input  logic [6:0] funct7,
    input  logic [6:0] op,
    output logic [4:0] ALUControl
);

logic [4:0] RVX10ins;
assign RVX10ins = { funct7[1:0], funct3 };

logic RtypeSub;
assign RtypeSub = funct7[5] & op[5];

    always_comb begin
        ALUControl = 3'b000;
        case (ALUOp)
            2'b00: ALUControl = 5'b00000;
            2'b01: ALUControl = 5'b00001;
            2'b10: 
                  case (funct3)
                      3'b000:  ALUControl = RtypeSub ? 5'b00001 : 5'b00000; 
                      3'b001:  ALUControl = 5'b00110; 
                      3'b010:  ALUControl = 5'b00101; 
                      3'b101:  ALUControl = 5'b00111; 
                      3'b110:  ALUControl = 5'b00011; 
                      3'b111:  ALUControl = 5'b00010; 
                      default: ALUControl = 5'bxxxxx; 
                  endcase
            2'b11: case (RVX10ins)
                      5'b00000: ALUControl = 5'b10000; // andn
                      5'b00001: ALUControl = 5'b10001; // orn
                      5'b00010: ALUControl = 5'b10010; // xnor
                      5'b01000: ALUControl = 5'b10011; // min
                      5'b01001: ALUControl = 5'b10100; // max
                      5'b01010: ALUControl = 5'b10101; // minu
                      5'b01011: ALUControl = 5'b10110; // maxu
                      5'b10000: ALUControl = 5'b11000; // rol
                      5'b10001: ALUControl = 5'b11001; // ror
                      5'b11000: ALUControl = 5'b10111; // abs
                      default:  ALUControl = 5'bxxxxx; // undefined RVX10 instruction
                  endcase
            default: ALUControl = 5'bxxxxx; 
        endcase
    end
endmodule